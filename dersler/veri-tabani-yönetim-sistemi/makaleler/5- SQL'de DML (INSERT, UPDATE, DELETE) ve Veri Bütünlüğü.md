# SQL'de DML (INSERT, UPDATE, DELETE) ve Veri Bütünlüğü

Bu makalenin odağı, SQL'de veri değiştiren komutlardir.
Yani:

- `INSERT` (ekleme)
- `UPDATE` (güncelleme)
- `DELETE` (silme)

Bu komutlarin ortak sınıfı: **DML (Data Manipulation Language)**.

---

## 1) Terminoloji notu

Kısa siniflama:

- `SELECT` -> DQL (Data Query Language)
- `INSERT/UPDATE/DELETE` -> DML (Data Manipulation Language)
- `CREATE/ALTER/DROP` -> DDL (Data Definition Language)

---

## 2) DML çalışmadan önce güvenlik refleksi

Uretim ortaminda en kritik hata:
`WHERE` unutulmuş `UPDATE` veya `DELETE`.

Kural:

1. Önce `SELECT` ile hedef satırları gör.
2. Sonra aynı kosulla `UPDATE/DELETE` çalıştır.
3. Mümkünse transaction içinde yap.

---

## 3) INSERT: veri ekleme

Tüm örnekler `retail_ops` üzerindedir.

### 3.1 Basit insert

```sql
INSERT INTO customer (customer_code, full_name, email, city, segment)
VALUES ('C0099', 'Kerem Ak', 'kerem.ak@mail.com', 'Istanbul', 'individual');
```

### 3.2 Çoklu satır insert

```sql
INSERT INTO category (name)
VALUES ('Giyilebilir Teknoloji'),
       ('Ofis Urunleri');
```

### 3.3 Select'ten insert (toplu taşıma)

```sql
INSERT INTO customer (customer_code, full_name, email, city, segment)
SELECT CONCAT('ARCH-', customer_code),
       full_name,
       CONCAT('arch.', email),
       city,
       segment
FROM customer
WHERE segment = 'corporate';
```

Bu tip kullanım ETL ve arşivleme senaryolarinda sık görülür.

---

## 4) UPDATE: mevcut veriyi değiştirme

### 4.1 Tek satır güncelleme

```sql
UPDATE customer
SET city = 'Izmir'
WHERE customer_code = 'C0004';
```

### 4.2 Koşullu toplu güncelleme

```sql
UPDATE sales_order
SET status = 'approved'
WHERE status = 'new'
  AND order_date < '2025-01-12';
```

### 4.3 JOIN ile update

Örnek: teslim edilmiş siparişlerin ödeme kaydını `paid` yapmak.

```sql
UPDATE payment p
JOIN sales_order so ON so.id = p.order_id
SET p.status = 'paid'
WHERE so.status = 'delivered'
  AND p.status = 'pending';
```

JOIN'li update güçlüdür, ama kosul net değilse büyük hasar verir.

---

## 5) DELETE: satır silme

### 5.1 Hedefli delete

```sql
DELETE FROM customer
WHERE customer_code = 'C0099';
```

### 5.2 Koşullu toplu delete

```sql
DELETE FROM payment
WHERE status = 'failed'
  AND paid_at IS NULL;
```

### 5.3 Güvenli delete akışı

1. Hedefi gör:

```sql
SELECT *
FROM payment
WHERE status = 'failed'
  AND paid_at IS NULL;
```

2. Adedi kontrol et:

```sql
SELECT COUNT(*)
FROM payment
WHERE status = 'failed'
  AND paid_at IS NULL;
```

3. Sonra delete çalıştır.

---

## 6) Veri bütünlüğü neden hayati?

Veri bütünlüğü:
verinin teknik ve iş kuralı açısından tutarlı kalmasidir.

Örnek bozulma:

- sipariş `delivered`, ödeme `pending`
- stok eksiye dusmus
- shipment var ama sipariş iptal

Bu tür tutarsizliklar raporu da operasyonu da bozar.

---

## 7) Bütünlüğü koruyan katmanlar

### 7.1 PRIMARY KEY

Satiri tekil tanımlar.

### 7.2 FOREIGN KEY

İlişkili kayitlarin geçersiz olmasını engeller.

### 7.3 UNIQUE

Aynı kritik degerin tekrar etmesini engeller (`email`, `sku`).

### 7.4 CHECK (MySQL sürüme bağlı)

Alan değerlerini iş kuralina göre sınırlar.

### 7.5 Uygulama + transaction katmanı

Tek bir SQL kuralinin yetmediği yerde
işlemi adım adım transaction ile güvenceye alır.

---

## 8) Pratikte en kritik 5 DML hatasi

1. `WHERE` unutmak
2. Yanlış `JOIN` kosuluyla toplu update
3. `DELETE` önce `SELECT` kontrolü yapmamak
4. Uygun index olmadan büyük toplu update çalıştırmak
5. Transaction olmadan çok adımlı güncelleme yapmak

---

## 9) DML'de alias kullanımı (so, p, c) nasıl olmalı?

`UPDATE ... JOIN` veya çoklu sorgularda alias neredeyse zorunludur.

Örnek:

```sql
UPDATE payment p
JOIN sales_order so ON so.id = p.order_id
SET p.status = 'paid'
WHERE so.status = 'delivered'
  AND p.status = 'pending';
```

Kurallar:

1. Takım içinde tek standart belirle.
2. Her tabloya her sorguda aynı alias'i ver.
3. Alias'i sorgu boyunca tutarlı kullan.
4. Çok kısaltılmış ama anlamsız alias'tan kaçın (`x1`, `t2` gibi).

Öneri listesi:

- `so` -> `sales_order`
- `soi` -> `sales_order_item`
- `c` -> `customer`
- `pr` -> `product`
- `p` -> `payment`
- `sh` -> `shipment`

---

## 10) DML + veri bütünlüğü mini senaryo

Senaryo:
"Sipariş iptal olduğunda stok geri eklensin ve ödeme iadeye cekilsin."

Bu operasyon tek sorgu değil, iş akışıdır.

---

## 11) Alıştırma seti

1. Yeni bir müşteri ekle.
2. Belirli bir müşterinin şehir bilgisini güncelle.
3. `status='new'` siparişleri `approved` yap.
4. `failed` ödeme kayitlarini temizle.
5. Önce `SELECT` sonra `DELETE` akışını her adımda uygula.
6. JOIN ile payment status toplu güncellemesi yaz.

---

## Sonuç

DML komutları, SQL'in "yazan eli"dir.
Doğru kullanıldığında sistemi ilerletir,
yanlış kullanıldığında veriyi bozabilir.

Bu nedenle DML öğrenimi sadece syntax değil,
güvenlik, bütünlük ve iş akışıyla birlikte ele alınmalıdır.

---

## 12) INSERT detayları: sık kullanilan varyasyonlar

### 12.1 Varsayılan degerlerle insert

```sql
INSERT INTO warehouse (code, name, city)
VALUES ('W-BOD', 'Bodrum Mikro Depo', 'Mugla');
```

### 12.2 Hesaplanmış değerle insert

```sql
INSERT INTO sales_order (order_no, customer_id, order_date, status, total_amount)
VALUES ('SO-2025-0999', 1, NOW(), 'new', 0);
```

### 12.3 Idempotent insert fikri

Tekrar çalıştığında çift kayıt üretmemesi istenen islerde
benzersiz kolon ve kosullu insert birlikte düşünülür.

---

## 13) UPDATE detayları: kontrollü değişim

### 13.1 Önce seç, sonra güncelle

```sql
SELECT *
FROM sales_order
WHERE status = 'new'
  AND order_date < '2025-01-10';
```

```sql
UPDATE sales_order
SET status = 'approved'
WHERE status = 'new'
  AND order_date < '2025-01-10';
```

### 13.2 Kademeli update

Büyük tabloda tüm satırı tek seferde güncellemek yerine
parti parti ilerlemek daha güvenli olabilir.

---

## 14) DELETE detayları: geri dönüşü zor komut

`DELETE` en riskli DML komutudur.
Üretimde en iyi uygulama:

1. önce snapshot/backup
2. önce `SELECT` ile hedef
3. önce sayı kontrolü
4. transaction içinde sil

### Örnek: transaction ile delete

```sql
START TRANSACTION;

SELECT *
FROM payment
WHERE status = 'failed'
  AND paid_at IS NULL
FOR UPDATE;

DELETE FROM payment
WHERE status = 'failed'
  AND paid_at IS NULL;

COMMIT;
```

---

## 15) Soft delete mi hard delete mi?

### Hard delete

Satır fiziksel olarak silinir.

Avantaj:
- tablo temiz kalir

Risk:
- geri dönüş zor

### Soft delete

Satiri silmek yerine `is_deleted=1` veya `deleted_at` set edilir.

Avantaj:
- geri alma kolay
- audit kolay

Risk:
- her sorguda filtre disiplini gerekir

---

## 16) Veri bütünlüğü: iş kuralı örnekleri

E-ticaret senaryosunda tipik kurallar:

1. `order_status = delivered` ise `shipment_status = delivered` olmalı
2. `payment_status = paid` değilse bazi sipariş gecisleri engellenmeli
3. `stock_qty` negatif olmamali
4. `order_total` ile satır toplamlari uyusmali

Bu kuralların bir kısmı DB constraint ile,
bir kısmı application veya transaction akışıyla korunur.

---

## 17) Constraint ve DML ilişkisi

### UNIQUE ihlali ornegi

`customer.email` benzersizse,
aynı email ile ikinci insert hata verir.

### FOREIGN KEY ihlali ornegi

Olmayan `customer_id` ile sipariş insert denemesi hata verir.

### ON DELETE davranışı

FK tanımına göre:

- `CASCADE`: ebeveyn silinince çocuk da silinir
- `RESTRICT`: bağlı kayıt varsa ebeveyn silinemez

Üretimde bu kararlar tasarımın kritik parçasıdır.

---

## 18) DML ve performans ilişkisi

`UPDATE`/`DELETE` sorgularinda da index hayati olabilir.

Örnek:

```sql
EXPLAIN
UPDATE sales_order
SET status = 'approved'
WHERE status = 'new'
  AND order_date < '2025-01-10';
```

Burada uygun index yoksa tam tablo taraması olabilir.

---

## 19) Alias kuralları: ileri seviye notlar

### Kısa ama anlamsız alias'tan kaçın

- kötü: `a`, `b`, `t1`, `t2`
- iyi: `so`, `soi`, `c`, `p`, `sh`

### Aynı tabloda farklı roller

Nadir durumlarda aynı tabloyu iki kez joinlersen
rol bazlı alias ver:

- `c_bill` (fatura müşteri)
- `c_ship` (teslim müşteri)

### Sorgu üstü alias notu

Uzun sorguda ilk satıra yorum ekleyebilirsin:

```sql
-- so:sales_order, soi:sales_order_item, c:customer, p:payment
```

Bu küçük not ekip içi okunurluğu ciddi artırır.

---

## 20) DML güvenlik checklist'i

1. `WHERE` var mi?
2. Hedef satır sayısı biliniyor mu?
3. Önce `SELECT` çalıştı mi?
4. İşlem transaction içinde mi?
5. Rollback plani var mi?
6. İşlem saati uygun mu? (iş yükünün düşük olduğu zaman)
7. Sonuç doğrulama sorgusu hazır mı?

---

## 21) Örnek: sipariş durum geçiş tablosu fikri

Durum geçişlerini doğrulamak için
kural tablosu kurulabilir:

```text
new -> approved
approved -> shipped
shipped -> delivered
new -> cancelled
approved -> cancelled
```

Bu tabloya dayalı update kontrolü,
yanlış durum geçişlerini azaltır.

---

## 22) DML test paketi (geniş)

1. Yeni müşteri ekle, aynı email ile ikinci insert dene.
2. Olmayan customer id ile sipariş insert dene.
3. `new` siparişleri seç, sonra approved yap.
4. `pending` ödemelerin bir kısmını paid yap.
5. `failed` ödeme kayitlarinda önce sayı sonra delete yap.
6. Her adımdan sonra doğrulama select yaz.
7. Tüm akışı transaction ile tekrar et.

---

## 23) Kapanış

DML komutları SQL'in operasyonel kalbidir.
Ama güvenli DML; syntax + bütünlük + test + rollback disiplininin toplamidir.

Bu disiplini erken oturtursan,
ileride transaction ve concurrency konuları çok daha kolay oturur.

---

## 24) DML komutları için "kırmızı çizgi" kuralları

Canlı ortam için pratik kırmızı cizgiler:

1. `UPDATE` ve `DELETE` komutunu `WHERE` olmadan çalıştırma.
2. `WHERE`te PK veya indexli kolon yoksa iki kez kontrol et.
3. Beklenen etkilenen satır adedini önceden yaz.
4. İşlem sonrası doğrulama sorgusu hazır olmadan çalıştırma.

Bu kurallar basit görünür ama ciddi veri kaybini engeller.

---

## 25) DML değişiklik kaydı (change log) fikri

Operasyonel sistemlerde şu model kullanilabilir:

- kritik update/delete öncesi
- eski değerleri log tablosuna yaz
- sonra asıl değişikliği yap

Bu model geri izleme ve denetim için faydalidir.

---

## 26) Son mini kontrol listesi

Komut çalıştırmadan önce:

- hedef satırlar görüldü mu?
- transaction gerekli mi?
- rollback plani var mi?
- index durumu uygun mu?
- sonuç kontrolü hazır mi?

Bu beş adım, DML tarafinda profesyonel standart oluşturur.
