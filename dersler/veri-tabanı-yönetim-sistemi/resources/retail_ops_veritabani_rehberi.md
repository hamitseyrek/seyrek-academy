# Retail Ops Veritabanı Rehberi

Bu doküman, `retail_ops_sample.sql` ile kurulan e-ticaret operasyon veritabanını uçtan uca açıklar.
Amaç, şemanın sadece tablo isimlerini değil, iş akışını da anlaşılır hale getirmektir.

---

## 0) Hızlı Akış Diyagramları

Önce büyük resmi hızlıca görmek için küçük akışları kullan:

```mermaid
flowchart LR
  subgraph Catalog[Ürün Kataloğu]
    SUP[supplier] --> PROD[product]
    CAT[category] --> PROD
  end

  subgraph Commerce[Sipariş ve Satış]
    CUS[customer] --> SO[sales_order]
    SO --> SOI[sales_order_item]
    PROD --> SOI
  end

  subgraph Ops[Operasyon]
    WH[warehouse] --> INV[inventory]
    PROD --> INV
    SO --> PAY[payment]
    SO --> SH[shipment]
    WH --> SH
  end
```

---

## 1) Kapsam ve amaç

Bu veritabanı aşağıdaki süreçleri kapsar:

- müşteri ve tedarikçi yönetimi
- ürün/kategori yönetimi
- depo ve stok takibi
- sipariş oluşturma ve sipariş kalemleri
- ödeme takibi
- sevkiyat/kargo takibi

Tek cümleyle:
`retail_ops`, siparişten teslimata kadar tüm operasyon zincirini ilişkisel modelde toplar.

```mermaid
flowchart LR
  Müşteri --> Sipariş
  Sipariş --> Ödeme
  Sipariş --> Sevkiyat
  Sipariş --> Stok
  Stok --> Depo
```

---

## 2) Hızlı kurulum

```sql
SOURCE /path/to/retail_ops_sample.sql;
USE retail_ops;
SHOW TABLES;
```

Beklenen tablolar:

- `customer`
- `supplier`
- `category`
- `product`
- `warehouse`
- `inventory`
- `sales_order`
- `sales_order_item`
- `payment`
- `shipment`

---

## 3) Genel mimari

```mermaid
flowchart LR
  C[customer] --> SO[sales_order]
  SO --> SOI[sales_order_item]
  SOI --> P[product]
  P --> CAT[category]
  P --> S[supplier]
  P --> INV[inventory]
  W[warehouse] --> INV
  SO --> PAY[payment]
  SO --> SH[shipment]
  W --> SH
```

Bu akışın mantığı:

1. müşteri sipariş verir (`sales_order`)
2. sipariş satırlarında ürünler tutulur (`sales_order_item`)
3. ürün stokları depoya göre yönetilir (`inventory`)
4. siparişin ödeme ve sevkiyat kayıtları ayrı izlenir (`payment`, `shipment`)

Kısa karar akışı:

```mermaid
flowchart TD
  A[Sipariş açıldı] --> B{Stok yeterli mi?}
  B -- Hayır --> C[Sipariş beklemeye alınır]
  B -- Evet --> D[Onaylanır]
  D --> E{Ödeme başarılı mı?}
  E -- Hayır --> F[Payment: failed/pending]
  E -- Evet --> G[Payment: paid]
  G --> H[Sevkiyat hazırlanır]
  H --> I[Shipment: in_transit]
  I --> J[Shipment: delivered]
```

---

## 4) ER diyagramı (tablo ilişkileri)

```mermaid
erDiagram
  CUSTOMER ||--o{ SALES_ORDER : places
  SALES_ORDER ||--|{ SALES_ORDER_ITEM : contains
  PRODUCT ||--o{ SALES_ORDER_ITEM : sold_in
  CATEGORY ||--o{ PRODUCT : groups
  SUPPLIER ||--o{ PRODUCT : supplies
  PRODUCT ||--o{ INVENTORY : tracked_as
  WAREHOUSE ||--o{ INVENTORY : stores
  SALES_ORDER ||--o{ PAYMENT : paid_by
  SALES_ORDER ||--o{ SHIPMENT : shipped_as
  WAREHOUSE ||--o{ SHIPMENT : ships_from

  CUSTOMER {
    int id PK
    varchar customer_code UK
    varchar full_name
    varchar email UK
    varchar city
    enum segment
    datetime created_at
  }

  SUPPLIER {
    int id PK
    varchar supplier_code UK
    varchar name
    varchar contact_email UK
    varchar city
  }

  CATEGORY {
    int id PK
    varchar name UK
  }

  PRODUCT {
    int id PK
    varchar sku UK
    varchar name
    int category_id FK
    int supplier_id FK
    decimal unit_price
    decimal cost_price
    tinyint is_active
    datetime created_at
  }

  WAREHOUSE {
    int id PK
    varchar code UK
    varchar name
    varchar city
  }

  INVENTORY {
    int product_id PK_FK
    int warehouse_id PK_FK
    int stock_qty
    int reorder_level
  }

  SALES_ORDER {
    int id PK
    varchar order_no UK
    int customer_id FK
    datetime order_date
    enum status
    decimal total_amount
  }

  SALES_ORDER_ITEM {
    int id PK
    int order_id FK
    int product_id FK
    int quantity
    decimal unit_price
    decimal discount_pct
    decimal line_total
  }

  PAYMENT {
    int id PK
    int order_id FK
    datetime paid_at
    decimal amount
    enum method
    enum status
  }

  SHIPMENT {
    int id PK
    int order_id FK
    int warehouse_id FK
    datetime shipped_at
    datetime delivered_at
    enum status
    varchar tracking_no UK
    decimal shipping_cost
  }
```

> Not: Bu bölümdeki ER şeması, operasyonun ilişkisel omurgasını gösterir.

---

## 4.1) Sade EER (öğrenme amaçlı)

Detay kolonları azaltılmış, yalnızca ilişkiyi gösteren sade sürüm:

```mermaid
erDiagram
  CUSTOMER ||--o{ SALES_ORDER : places
  SALES_ORDER ||--|{ SALES_ORDER_ITEM : contains
  PRODUCT ||--o{ SALES_ORDER_ITEM : appears_in
  CATEGORY ||--o{ PRODUCT : classifies
  SUPPLIER ||--o{ PRODUCT : provides
  PRODUCT ||--o{ INVENTORY : has_stock
  WAREHOUSE ||--o{ INVENTORY : stores
  SALES_ORDER ||--o{ PAYMENT : has_payment
  SALES_ORDER ||--o{ SHIPMENT : has_shipment
  WAREHOUSE ||--o{ SHIPMENT : ships_from
```

Bu sürüm, özellikle ilk okuma için idealdir.

---

## 4.2) Modüler EER - Satış alanı

```mermaid
erDiagram
  CUSTOMER ||--o{ SALES_ORDER : places
  SALES_ORDER ||--|{ SALES_ORDER_ITEM : contains
  PRODUCT ||--o{ SALES_ORDER_ITEM : sold_as
  SALES_ORDER ||--o{ PAYMENT : paid_by

  CUSTOMER {
    int id PK
    varchar customer_code UK
    varchar full_name
  }
  SALES_ORDER {
    int id PK
    varchar order_no UK
    int customer_id FK
    enum status
    decimal total_amount
  }
  SALES_ORDER_ITEM {
    int id PK
    int order_id FK
    int product_id FK
    int quantity
    decimal line_total
  }
  PAYMENT {
    int id PK
    int order_id FK
    decimal amount
    enum status
  }
```

---

## 4.3) Modüler EER - Stok alanı

```mermaid
erDiagram
  CATEGORY ||--o{ PRODUCT : groups
  SUPPLIER ||--o{ PRODUCT : supplies
  PRODUCT ||--o{ INVENTORY : tracked_as
  WAREHOUSE ||--o{ INVENTORY : stores

  CATEGORY {
    int id PK
    varchar name UK
  }
  SUPPLIER {
    int id PK
    varchar supplier_code UK
    varchar name
  }
  PRODUCT {
    int id PK
    varchar sku UK
    varchar name
    int category_id FK
    int supplier_id FK
  }
  WAREHOUSE {
    int id PK
    varchar code UK
    varchar name
  }
  INVENTORY {
    int product_id PK_FK
    int warehouse_id PK_FK
    int stock_qty
    int reorder_level
  }
```

---

## 4.4) Modüler EER - Lojistik alanı

```mermaid
erDiagram
  SALES_ORDER ||--o{ SHIPMENT : shipped_as
  WAREHOUSE ||--o{ SHIPMENT : ships_from

  SALES_ORDER {
    int id PK
    varchar order_no UK
    enum status
  }
  WAREHOUSE {
    int id PK
    varchar code UK
  }
  SHIPMENT {
    int id PK
    int order_id FK
    int warehouse_id FK
    enum status
    varchar tracking_no UK
  }
```

---

## 4.5) İlişki lejandı (okuma kılavuzu)

```mermaid
flowchart LR
  A["||"] --> B["Tam olarak 1"]
  C["o{"] --> D["0 veya çok (0..N)"]
  E["|{"] --> F["1 veya çok (1..N)"]
  G["o|"] --> H["0 veya 1 (0..1)"]
```

Bu işaretleri bildiğinde EER diyagramını çok daha hızlı okursun.

---

## 5) Tabloların görevleri

## `customer`

- sistemde sipariş verecek kişi/kurum kartı
- `customer_code` ve `email` benzersiz
- `segment` ile bireysel/kurumsal ayrımı yapılır

## `supplier`

- ürün tedarik eden firma bilgisi
- ürün kartı bu tabloya bağlanır (`product.supplier_id`)

## `category`

- ürünleri mantıksal gruplara ayırır
- kategori bazlı raporların temelidir

## `product`

- satılan ürün kartı
- kategori ve tedarikçiye FK ile bağlıdır
- `unit_price` satış, `cost_price` maliyet analizi için tutulur

## `warehouse`

- fiziksel depo tanımı
- stok ve sevkiyat bu tabloya bağlıdır

## `inventory`

- ürünün depoya göre stok kırılımı
- bileşik PK: `(product_id, warehouse_id)`
- stok operasyonlarının çekirdeği

## `sales_order`

- sipariş başlığı (header)
- müşteri, tarih, durum ve toplam tutar bilgisi
- yaşam döngüsü: `new -> approved -> shipped -> delivered`

## `sales_order_item`

- sipariş satırları (line item)
- her satır bir ürün + miktar + tutar içerir
- sipariş toplamları bu tablodan doğrulanır

## `payment`

- ödeme hareketi
- durumlar: `pending`, `paid`, `failed`, `refunded`
- finansal takip için ayrı tutulur

## `shipment`

- sevkiyat hareketi
- hangi depodan gönderildiği ve takip no bilgisi
- durumlar: `preparing`, `in_transit`, `delivered`, `returned`

---

## 6) İlişki kuralları (FK davranışları)

Önemli ilişki davranışları:

- `sales_order -> customer`: `ON DELETE RESTRICT`
  - müşteriye bağlı sipariş varken müşteri silinemez
- `sales_order_item -> sales_order`: `ON DELETE CASCADE`
  - sipariş silinirse satırlar da silinir
- `payment -> sales_order`: `ON DELETE CASCADE`
  - sipariş yoksa ödeme kaydının kalması engellenir
- `shipment -> warehouse`: `ON DELETE RESTRICT`
  - geçmiş sevkiyat kayıtlarını korumak için depo silme sınırlandırılır

Bu kararlar, veri tutarlılığını iş kurallarıyla uyumlu tutar.

---

## 7) Durum (status) alanları ve semantik

## Sipariş (`sales_order.status`)

- `new`: sipariş açıldı
- `approved`: operasyon onayı alındı
- `shipped`: sevkiyata çıktı
- `delivered`: teslim edildi
- `cancelled`: iptal edildi

## Ödeme (`payment.status`)

- `pending`: ödeme bekleniyor
- `paid`: ödeme tamamlandı
- `failed`: ödeme başarısız
- `refunded`: ödeme iade edildi

## Sevkiyat (`shipment.status`)

- `preparing`: hazırlık aşamasında
- `in_transit`: yolda
- `delivered`: teslim edildi
- `returned`: iade döndü

Durumların görsel özeti:

```mermaid
stateDiagram-v2
  [*] --> new
  new --> approved
  approved --> shipped
  shipped --> delivered
  new --> cancelled
  approved --> cancelled
```

```mermaid
stateDiagram-v2
  [*] --> pending
  pending --> paid
  pending --> failed
  paid --> refunded
```

```mermaid
stateDiagram-v2
  [*] --> preparing
  preparing --> in_transit
  in_transit --> delivered
  in_transit --> returned
```

---

## 8) Siparişten teslimata iş akışı

```mermaid
sequenceDiagram
  participant U as Customer
  participant O as sales_order
  participant I as inventory
  participant P as payment
  participant S as shipment

  U->>O: Sipariş oluştur
  O->>I: Stok kontrol + rezervasyon
  O->>P: Ödeme kaydı aç (pending/paid)
  O->>S: Sevkiyat kaydı aç (preparing)
  S-->>O: shipped
  S-->>O: delivered
```

Not:
Gerçek sistemde bu adımlar transaction ve kilitleme ile güvenceye alınmalıdır.

Aynı akışın tablo odaklı kısa görünümü:

```mermaid
flowchart LR
  SO[sales_order] --> SOI[sales_order_item]
  SO --> PAY[payment]
  SO --> SH[shipment]
  SOI --> INV[inventory]
  SH --> WH[warehouse]
```

---

## 9) Sorgu örnekleri (şemayı anlamak için)

## 9.1 Sipariş özeti

```sql
SELECT so.order_no,
       c.full_name AS customer_name,
       so.status AS order_status,
       p.status AS payment_status,
       sh.status AS shipment_status
FROM sales_order so
JOIN customer c ON c.id = so.customer_id
LEFT JOIN payment p ON p.order_id = so.id
LEFT JOIN shipment sh ON sh.order_id = so.id
ORDER BY so.order_date DESC;
```

## 9.2 Kategori bazlı ciro

```sql
SELECT cat.name AS category_name,
       SUM(soi.quantity) AS total_units,
       ROUND(SUM(soi.line_total), 2) AS gross_revenue
FROM sales_order_item soi
JOIN product pr ON pr.id = soi.product_id
JOIN category cat ON cat.id = pr.category_id
GROUP BY cat.id, cat.name
ORDER BY gross_revenue DESC;
```

## 9.3 Kritik stok listesi

```sql
SELECT w.code AS warehouse_code,
       pr.sku,
       pr.name AS product_name,
       i.stock_qty,
       i.reorder_level
FROM inventory i
JOIN warehouse w ON w.id = i.warehouse_id
JOIN product pr ON pr.id = i.product_id
WHERE i.stock_qty <= i.reorder_level
ORDER BY i.stock_qty ASC;
```

---

## 10) İndeks mantığı (şemadaki ipuçları)

Şemadaki çoğu FK alanında index bulunur:

- `sales_order.customer_id`
- `sales_order_item.order_id`, `sales_order_item.product_id`
- `payment.order_id`
- `shipment.order_id`, `shipment.warehouse_id`

Sebep:
JOIN ve filtre sorgularında tam tablo taramasını azaltmak.

Ek performans senaryosu:
`sales_order(status, order_date)` bileşik indexi, durum+tarih filtreli dashboard sorgularında etkilidir.

Index düşünme akışı:

```mermaid
flowchart TD
  Q[Sorgu yavaş] --> J{JOIN var mı?}
  J -- Evet --> A[FK alanlarına index kontrolü]
  J -- Hayır --> F{WHERE/ORDER BY var mı?}
  F -- Evet --> B[Filtre ve sıralama kolonlarını incele]
  B --> C[EXPLAIN ile planı doğrula]
  A --> C
  C --> D[rows/type/key alanlarını değerlendir]
  D --> E[Hedefli index ekle]
```

---

## 11) Veri kalitesi için kontrol sorguları

## 11.1 Sipariş total doğrulama

```sql
SELECT so.order_no,
       so.total_amount AS stored_total,
       ROUND(SUM(soi.line_total), 2) AS calculated_total,
       ROUND(so.total_amount - SUM(soi.line_total), 2) AS diff
FROM sales_order so
JOIN sales_order_item soi ON soi.order_id = so.id
GROUP BY so.id, so.order_no, so.total_amount
ORDER BY ABS(diff) DESC;
```

## 11.2 Teslim edilmiş ama ödenmemiş sipariş kontrolü

```sql
SELECT so.order_no,
       so.status AS order_status,
       p.status AS payment_status
FROM sales_order so
LEFT JOIN payment p ON p.order_id = so.id
WHERE so.status = 'delivered'
  AND COALESCE(p.status, 'pending') <> 'paid';
```

Kontrol mantığının diyagramı:

```mermaid
flowchart TD
  A[sales_order: delivered] --> B{payment_status = paid ?}
  B -- Evet --> C[Normal durum]
  B -- Hayır --> D[Anomali listesine ekle]
```

---

## 12) Geliştirme önerileri

Bu şema eğitim ve demo için yeterli; üretimde şu iyileştirmeler eklenebilir:

- `sales_order` için `currency`, `tax_total`, `net_total` alanları
- `payment` için çoklu ödeme desteği (aynı siparişe birden fazla kayıt politikası)
- `inventory_movement` tablosu ile stok hareket geçmişi
- audit log (status geçişleri için)
- soft delete yaklaşımı (`deleted_at`) gereken tablolarda

---

## 13) Sonuç

Bu veritabanı, e-ticaret operasyonlarında en kritik üç hattı bir araya getirir:

1. sipariş hattı (`sales_order`, `sales_order_item`)
2. finans hattı (`payment`)
3. lojistik hattı (`shipment`, `inventory`, `warehouse`)

Şemayı bu üç hat üzerinden okuduğunda, hem SQL sorguları hem de transaction tasarımı çok daha anlaşılır hale gelir.
