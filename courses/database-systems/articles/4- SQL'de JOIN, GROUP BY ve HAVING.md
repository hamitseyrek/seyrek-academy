# SQL'de JOIN, GROUP BY ve HAVING

Bu makale, `3- SQL Temelleri: SELECT.md` dosyasının doğrudan devamıdır.
Odak noktasi:

- birden fazla tablodan veri birlestirme (`JOIN`)
- veriyi ozetleme (`GROUP BY`)
- gruplanmis sonucu filtreleme (`HAVING`)

Tüm örnekler `veritabanı/kaynaklar/retail_ops_sample.sql` verisi üzerindedir.

---

## 1) Tablo alias'i (`so`, `c`, `p`) neden kullanılır?

Aşağıdaki ifade bir kısaltma değil, tablo takma adıdır:

```sql
FROM sales_order so
JOIN customer c ON c.id = so.customer_id
```

Burada:

- `so` = `sales_order`
- `c` = `customer`

### Alias kullanmanin faydası

- Uzun adlari tekrar tekrar yazmazsin
- JOIN'li sorgular daha okunur olur
- Aynı isimli kolonlarda belirsizlik azalir (`status` gibi)

### Alias kullanma kuralları (onerilen standart)

1. Her tabloda tutarlı ol: `sales_order` her yerde `so` olsun.
2. Anlamsız tek harflerden kaçın: `a`, `b`, `x` yerine `so`, `soi`, `pr`.
3. Çok tablo varsa alias listeni sorgu ustunde yorumla notu olarak yazabilirsin.
4. Takım standardı varsa ona uy.

---

## 3) JOIN'e geçiş: tek tablodan çoklu tabloya

### 3.1 Tek tablo

```sql
SELECT order_no, customer_id, status, total_amount
FROM sales_order
ORDER BY order_date DESC;
```

Bu sorgu siparişleri getirir ama müşteri adini vermez.
`customer_id` sayisal bir anahtar olduğu için tek başına iş tarafinda yeterince okunur olmaz.

### 3.2 İlk JOIN: sipariş + müşteri

```sql
SELECT so.order_no,
       so.order_date,
       c.full_name AS customer_name,
       so.status,
       so.total_amount
FROM sales_order so
JOIN customer c ON c.id = so.customer_id
ORDER BY so.order_date DESC;
```

Bu sorgu ne yapıyor?

- `sales_order` tablosunu temel aliyor.
- `customer` tablosuyla `customer_id` üzerinden eslestirme yapıyor.
- Sipariş numarasi, tarih, müşteri adı, durum ve tutari tek satırda gösteriyor.
- Sonuçları en yeni sipariş üstte olacak şekilde sıralıyor.

Satır satır semantik:

- `SELECT ...`: ciktiya alınacak kolonları tanımlar.
- `FROM sales_order so`: ana veri kaynağı sipariş tablosudur.
- `JOIN customer c ON c.id = so.customer_id`: siparişi müşteriyle ilişki anahtarı üzerinden eşleştirir.
- `ORDER BY so.order_date DESC`: çıktıyı tarihe göre en yeniden eskiye sıralar.

### 3.3 LEFT JOIN ile ödeme durumunu ekleme

```sql
SELECT so.order_no,
       c.full_name AS customer_name,
       so.status AS order_status,
       p.status AS payment_status
FROM sales_order so
JOIN customer c ON c.id = so.customer_id
LEFT JOIN payment p ON p.order_id = so.id
ORDER BY so.order_date DESC;
```

`LEFT JOIN` seçimi, ödemesi henüz oluşmayan siparişleri listede tutar.
Bu nedenle `payment_status` bazen `NULL` gelebilir; bu bir hata değil, ödeme kaydinin henüz olusmadigi anlamına gelir.

---

## 4) JOIN türleri

### INNER JOIN

Iki tabloda da eslesen satırları getirir.

```sql
SELECT so.order_no, c.full_name
FROM sales_order so
INNER JOIN customer c ON c.id = so.customer_id;
```

Burada yalnızca iki tabloda da eşleşme olan satırlar döner.

### LEFT JOIN

Soldaki tüm satırları getirir, eşleşmeyen sağ kolonlar `NULL` olur.

```sql
SELECT so.order_no, p.status
FROM sales_order so
LEFT JOIN payment p ON p.order_id = so.id;
```

Bu sorgu, ödemesi olmayan siparişleri de görmek istediğin durumlarda kullanılır.

### RIGHT JOIN

MySQL'de desteklenir, ama pratikte daha okunur olduğu için
tabloları yer değiştirip `LEFT JOIN` kullanmak daha yaygındır.

---

## 5) JOIN'de sık hatalar

### 5.1 Yanlış ON kosulu

Hatali:

```sql
SELECT so.order_no, p.status
FROM sales_order so
JOIN payment p ON p.id = so.id;
```

Doğru:

```sql
SELECT so.order_no, p.status
FROM sales_order so
JOIN payment p ON p.order_id = so.id;
```

Neden doğru?

- `payment.id` ile `sales_order.id` farklı varliklarin PK alanlaridir.
- İlişki `payment.order_id -> sales_order.id` olduğu için `ON` kosulu bu şekilde kurulmalidir.

### 5.2 Belirsiz kolon kullanımı

Hatali:

```sql
SELECT status
FROM sales_order so
JOIN payment p ON p.order_id = so.id;
```

Doğru:

```sql
SELECT so.status AS order_status,
       p.status  AS payment_status
FROM sales_order so
JOIN payment p ON p.order_id = so.id;
```

Bu adlandırma, aynı isimli iki kolonu (`status`) karıştırmadan okumayi saglar.

---

## 6) GROUP BY: satırdan özet bilgiye geçiş

`GROUP BY`, satır satır veriyi özet bilgiye cevirir.

### 6.1 Kategori bazlı ciro

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

Bu sorgu ne yapıyor?

- Sipariş kalemlerini ürün ve kategoriyle bagliyor.
- Her kategori için toplam adet ve toplam ciro hesapliyor.
- En yüksek ciroyu üstte gösterecek şekilde sıralıyor.

Satır satır semantik:

- `SELECT cat.name AS category_name`: kategori adini ciktiya "category_name" olarak verir.
- `SUM(soi.quantity) AS total_units`: her grup için toplam satılan adet hesaplar.
- `ROUND(SUM(soi.line_total), 2) AS gross_revenue`: her grup için toplam ciroyu iki ondalikla verir.
- `FROM sales_order_item soi`: hesaplamanin taban satırları sipariş kalemleridir.
- `JOIN product pr ...`: her kalemi ilgili ürünle eşleştirir.
- `JOIN category cat ...`: üründen kategoriye geçiş yapar.
- `GROUP BY cat.id, cat.name`: toplamlarin kategori bazinda alinacagini tanımlar.
- `ORDER BY gross_revenue DESC`: ciroya göre büyükten küçüğe sıralar.

Neden `GROUP BY` gerekli?

- Sorguda hem aggregate (`SUM`) hem de aggregate olmayan kolon (`cat.name`) var.
- Bu nedenle aggregate olmayan kolonların gruplama anahtarına alınması gerekir.
- `GROUP BY` kaldırılırsa çoğu SQL motorunda hata alirsin.

### 6.2 Müşteri bazlı sipariş ozeti

```sql
SELECT c.customer_code,
       c.full_name,
       COUNT(so.id) AS order_count,
       ROUND(SUM(so.total_amount), 2) AS total_revenue
FROM customer c
JOIN sales_order so ON so.customer_id = c.id
GROUP BY c.id, c.customer_code, c.full_name
ORDER BY total_revenue DESC;
```

Burada her satır bir müşteriyi temsil eder; aynı müşteriye ait tüm siparişler tek satıra özetlenir.

---

## 7) HAVING: gruplanmis sonucu filtreleme

`WHERE` satırları gruplanmadan önce filtreler.
`HAVING` gruplanmis sonuca kosul uygular.

### 7.1 Cirosu 10000 üstü kategoriler

```sql
SELECT cat.name AS category_name,
       ROUND(SUM(soi.line_total), 2) AS gross_revenue
FROM sales_order_item soi
JOIN product pr ON pr.id = soi.product_id
JOIN category cat ON cat.id = pr.category_id
GROUP BY cat.id, cat.name
HAVING SUM(soi.line_total) >= 10000
ORDER BY gross_revenue DESC;
```

`HAVING` filtresi, grup oluştuktan sonra çalıştığı için kategori bazlı toplamlara kosul koyabiliriz.

### 7.2 En az 2 siparişi olan müşteriler

```sql
SELECT c.full_name,
       COUNT(so.id) AS order_count
FROM customer c
JOIN sales_order so ON so.customer_id = c.id
GROUP BY c.id, c.full_name
HAVING COUNT(so.id) >= 2
ORDER BY order_count DESC;
```

Bu sorgu, en az iki sipariş veren müşterileri bulmak için ideal kalıptır.

---

## 8) WHERE ve HAVING birlikte

Gerçek hayatta ikisi birlikte kullanılır:

```sql
SELECT c.city,
       COUNT(so.id) AS order_count,
       ROUND(SUM(so.total_amount), 2) AS total_amount
FROM sales_order so
JOIN customer c ON c.id = so.customer_id
WHERE so.status <> 'cancelled'
GROUP BY c.city
HAVING SUM(so.total_amount) >= 20000
ORDER BY total_amount DESC;
```

Mantik:

- `WHERE`: iptal siparişleri çıkar
- `GROUP BY`: şehir bazlı ozetle
- `HAVING`: eşiği aşmayan gruplari ele

---

## Sonuç

`JOIN` veriyi birlestirir.
`GROUP BY` veriyi ozetler.
`HAVING` özet sonuca karar kosulu uygular.

Bu üç yapının birlikte kullanımı,
raporlama ve operasyon analizi için SQL'in omurgasini oluşturur.

---

## 10) JOIN karar agaci: hangi durumda hangi JOIN?

Sorguyu yazmadan önce şu soruyu sor:
"Soldaki kayitlarin hepsini korumam gerekiyor mu?"

- Evet -> `LEFT JOIN`
- Hayir, yalnızca eslesenler -> `INNER JOIN`

İkinci soru:
"Eslesmeyen kayıtları tespit etmek istiyor muyum?"

- Evet -> `LEFT JOIN ... WHERE sag_tablo.id IS NULL`

Örnek: ödeme kaydı olmayan siparişler:

```sql
SELECT so.order_no,
       so.order_date,
       so.total_amount
FROM sales_order so
LEFT JOIN payment p ON p.order_id = so.id
WHERE p.id IS NULL
ORDER BY so.order_date DESC;
```

---

## 11) Aynı sorunun 3 farklı JOIN çözüm stili

Soru:
"Her sipariş için müşteri, ödeme ve kargo durumunu getir."

### Stil 1: Duz alias ve tek blok

```sql
SELECT so.order_no,
       c.full_name,
       p.status AS payment_status,
       sh.status AS shipment_status
FROM sales_order so
JOIN customer c ON c.id = so.customer_id
LEFT JOIN payment p ON p.order_id = so.id
LEFT JOIN shipment sh ON sh.order_id = so.id;
```

### Stil 2: Kolon gruplu

```sql
SELECT
  -- sipariş
  so.order_no,
  so.order_date,
  so.status AS order_status,
  -- müşteri
  c.customer_code,
  c.full_name,
  c.city,
  -- odeme
  p.status AS payment_status,
  p.method AS payment_method,
  -- kargo
  sh.status AS shipment_status,
  sh.tracking_no
FROM sales_order so
JOIN customer c ON c.id = so.customer_id
LEFT JOIN payment p ON p.order_id = so.id
LEFT JOIN shipment sh ON sh.order_id = so.id;
```

### Stil 3: Önce CTE sonra final secim

```sql
WITH order_base AS (
  SELECT so.id,
         so.order_no,
         so.order_date,
         so.status AS order_status,
         c.full_name
  FROM sales_order so
  JOIN customer c ON c.id = so.customer_id
)
SELECT ob.order_no,
       ob.order_date,
       ob.full_name,
       ob.order_status,
       p.status AS payment_status,
       sh.status AS shipment_status
FROM order_base ob
LEFT JOIN payment p ON p.order_id = ob.id
LEFT JOIN shipment sh ON sh.order_id = ob.id;
```

CTE nedir?

- CTE, `WITH` ile tanimlanan gecici isimli sorgu sonucudur.
- Ana sorguyu parçalara ayırarak okunabilirliği artırır.
- Ozellikle uzun JOIN zincirlerinde ilk adimi sade bir "base set" haline getirir.

Bu örnekte CTE ne yapıyor?

- `order_base` adli ilk adımda sipariş + müşteri bilgisi tek bir ara sonuç olarak uretiliyor.
- Alttaki final sorgu bu ara sonucu kullanip ödeme ve kargo kolonlarını ekliyor.
- Boylece tek sorguda her seyi üst uste yazmak yerine, mantik iki asamada okunuyor.

Üç stil de doğru olabilir.
Takım okunabilirliği hangi stilde daha yüksekse onu seç.

---

## 12) GROUP BY'da "granularity" kavrami

Granularity = raporun satır seviyesi.

Örnek:

- `GROUP BY city` -> şehir seviyesi
- `GROUP BY city, segment` -> şehir + segment seviyesi
- `GROUP BY city, segment, status` -> daha detayli seviye

Aynı veri, farklı granularity ile farklı karar bilgisi uretir.

### Sehir seviyesi

```sql
SELECT c.city,
       COUNT(*) AS order_count,
       SUM(so.total_amount) AS total_amount
FROM sales_order so
JOIN customer c ON c.id = so.customer_id
GROUP BY c.city;
```

### Sehir + segment seviyesi

```sql
SELECT c.city,
       c.segment,
       COUNT(*) AS order_count,
       SUM(so.total_amount) AS total_amount
FROM sales_order so
JOIN customer c ON c.id = so.customer_id
GROUP BY c.city, c.segment;
```

---

## 13) HAVING ile iş kuralı filtreleri

`HAVING` sadece "büyük-küçük" için değil,
iş kuralı tabanli raporlarda da kullanılır.

### En az 2 farklı ürün alan müşteriler

```sql
SELECT c.customer_code,
       c.full_name,
       COUNT(DISTINCT soi.product_id) AS distinct_product_count
FROM customer c
JOIN sales_order so ON so.customer_id = c.id
JOIN sales_order_item soi ON soi.order_id = so.id
GROUP BY c.id, c.customer_code, c.full_name
HAVING COUNT(DISTINCT soi.product_id) >= 2
ORDER BY distinct_product_count DESC;
```

### Ortalama sepeti 10000 üstü sehirler

```sql
SELECT c.city,
       ROUND(AVG(so.total_amount), 2) AS avg_basket
FROM sales_order so
JOIN customer c ON c.id = so.customer_id
GROUP BY c.city
HAVING AVG(so.total_amount) >= 10000
ORDER BY avg_basket DESC;
```

---

## 14) JOIN + GROUP BY kombinasyonunda doğruluk kontrolü

Çok tablolu sorgularda en sık problem:
satır carpimi nedeniyle toplamlarin sismesi.

Kontrol adimi:

1. Önce ham satır sayısı
2. Sonra grup sonucu
3. Sonra birim test sorgusu

### Ham satır

```sql
SELECT COUNT(*) AS row_count
FROM sales_order_item soi
JOIN sales_order so ON so.id = soi.order_id;
```

### Grup sonucu

```sql
SELECT so.order_no,
       SUM(soi.line_total) AS total
FROM sales_order so
JOIN sales_order_item soi ON soi.order_id = so.id
GROUP BY so.id, so.order_no;
```

### Rastgele bir siparişi manuel kontrol

```sql
SELECT so.order_no,
       soi.quantity,
       soi.unit_price,
       soi.line_total
FROM sales_order so
JOIN sales_order_item soi ON soi.order_id = so.id
WHERE so.order_no = 'SO-2025-0001';
```

---

## 15) Alias sozlugu (makale serisi standardı)

Bu seride şu alias'lari sabit tut:

- `c` -> `customer`
- `sp` -> `supplier`
- `cat` -> `category`
- `pr` -> `product`
- `w` -> `warehouse`
- `i` -> `inventory`
- `so` -> `sales_order`
- `soi` -> `sales_order_item`
- `p` -> `payment`
- `sh` -> `shipment`

Bu standardı korumak, okuma suresini ciddi azaltır.

---

## 16) Pratik: 10 ek JOIN/HAVING görevi

1. Sehir bazinda `delivered` sipariş sayisini getir.
2. Odeme metodu `card` olan siparişlerin toplam tutarini hesapla.
3. Kargosu `in_transit` olan siparişleri müşteri adiyla listele.
4. Her kategoride en çok satılan ürünün SKU bilgisini getir.
5. Her depoda kritik stok adedini say.
6. Segmente göre ortalama sipariş tutarini hesapla.
7. En az 2 şehirde satış yapan müşterileri bul.
8. Kargo ucreti ortalamanin ustunde olan siparişleri getir.
9. Iptal siparişlerin şehir dağılımını çıkar.
10. Toplam cirosu 30000 üstü müşterileri listele.

---

## 17) Sorgu yazim kalibi (tekrar kullan)

JOIN + GROUP BY sorgusu yazarken şu kalip:

1. `FROM` tablosunu belirle
2. `JOIN` ilişkilerini birer birer ekle
3. `WHERE` satır filtresini yaz
4. `GROUP BY` granularity seç
5. `HAVING` grup filtresi ekle
6. `ORDER BY` rapor okunurluğu ayarla

Sablon:

```sql
SELECT ...
FROM base_table bt
JOIN table_1 t1 ON ...
LEFT JOIN table_2 t2 ON ...
WHERE ...
GROUP BY ...
HAVING ...
ORDER BY ...;
```

---

## 18) Kapanış: neden bu kadar detay?

`JOIN` bilmek tek başına yetmez.
Asıl farkı şu kombinasyon yaratir:

- doğru JOIN
- doğru granularity
- doğru HAVING filtresi
- doğru doğrulama adımı

Bu disiplini kurdugunda,
raporlar sadece çalışan değil,
guvenilir hale gelir.
