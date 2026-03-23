# SQL'de DML (INSERT, UPDATE, DELETE) ve Veri Butunlugu

Bu makalenin odagi, SQL'de veri degistiren komutlardir.
Yani:

- `INSERT` (ekleme)
- `UPDATE` (guncelleme)
- `DELETE` (silme)

Bu komutlarin ortak sinifi: **DML (Data Manipulation Language)**.

---

## 1) Terminoloji notu

Kisa siniflama:

- `SELECT` -> DQL (Data Query Language)
- `INSERT/UPDATE/DELETE` -> DML (Data Manipulation Language)
- `CREATE/ALTER/DROP` -> DDL (Data Definition Language)

---

## 2) DML calismadan once guvenlik refleksi

Uretim ortaminda en kritik hata:
`WHERE` unutulmus `UPDATE` veya `DELETE`.

Kural:

1. Once `SELECT` ile hedef satirlari gor.
2. Sonra ayni kosulla `UPDATE/DELETE` calistir.
3. Mumkunse transaction icinde yap.

---

## 3) INSERT: veri ekleme

Tum ornekler `retail_ops` uzerindedir.

### 3.1 Basit insert

```sql
INSERT INTO customer (customer_code, full_name, email, city, segment)
VALUES ('C0099', 'Kerem Ak', 'kerem.ak@mail.com', 'Istanbul', 'individual');
```

### 3.2 Coklu satir insert

```sql
INSERT INTO category (name)
VALUES ('Giyilebilir Teknoloji'),
       ('Ofis Urunleri');
```

### 3.3 Select'ten insert (toplu tasima)

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

Bu tip kullanim ETL ve arsivleme senaryolarinda sik gorulur.

---

## 4) UPDATE: mevcut veriyi degistirme

### 4.1 Tek satir guncelleme

```sql
UPDATE customer
SET city = 'Izmir'
WHERE customer_code = 'C0004';
```

### 4.2 Kosullu toplu guncelleme

```sql
UPDATE sales_order
SET status = 'approved'
WHERE status = 'new'
  AND order_date < '2025-01-12';
```

### 4.3 JOIN ile update

Ornek: teslim edilmis siparislerin odeme kaydini `paid` yapmak.

```sql
UPDATE payment p
JOIN sales_order so ON so.id = p.order_id
SET p.status = 'paid'
WHERE so.status = 'delivered'
  AND p.status = 'pending';
```

JOIN'li update gucludur, ama kosul net degilse buyuk hasar verir.

---

## 5) DELETE: satir silme

### 5.1 Hedefli delete

```sql
DELETE FROM customer
WHERE customer_code = 'C0099';
```

### 5.2 Kosullu toplu delete

```sql
DELETE FROM payment
WHERE status = 'failed'
  AND paid_at IS NULL;
```

### 5.3 Guvenli delete akisi

1. Hedefi gor:

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

3. Sonra delete calistir.

---

## 6) Veri butunlugu neden hayati?

Veri butunlugu:
verinin teknik ve is kurali acisindan tutarli kalmasidir.

Ornek bozulma:

- siparis `delivered`, odeme `pending`
- stok eksiye dusmus
- shipment var ama siparis iptal

Bu tur tutarsizliklar raporu da operasyou da bozar.

---

## 7) Butunlugu koruyan katmanlar

### 7.1 PRIMARY KEY

Satiri tekil tanimlar.

### 7.2 FOREIGN KEY

Iliskili kayitlarin gecersiz olmasini engeller.

### 7.3 UNIQUE

Ayni kritik degerin tekrar etmesini engeller (`email`, `sku`).

### 7.4 CHECK (MySQL surume bagli)

Alan degerlerini is kuralina gore sinirlar.

### 7.5 Uygulama + transaction katmani

Tek bir SQL kuralinin yetmedigi yerde
islemi adim adim transaction ile guvenceye alir.

---

## 8) Pratikte en kritik 5 DML hatasi

1. `WHERE` unutmak
2. Yanlis `JOIN` kosuluyla toplu update
3. `DELETE` once `SELECT` kontrolu yapmamak
4. Uygun index olmadan buyuk toplu update calistirmak
5. Transaction olmadan cok adimli guncelleme yapmak

---

## 9) DML'de alias kullanimi (so, p, c) nasil olmali?

`UPDATE ... JOIN` veya coklu sorgularda alias neredeyse zorunludur.

Ornek:

```sql
UPDATE payment p
JOIN sales_order so ON so.id = p.order_id
SET p.status = 'paid'
WHERE so.status = 'delivered'
  AND p.status = 'pending';
```

Kurallar:

1. Takim icinde tek standart belirle.
2. Her tabloya her sorguda ayni alias'i ver.
3. Alias'i sorgu boyunca tutarli kullan.
4. Cok kisaltilmis ama anlamsiz alias'tan kacin (`x1`, `t2` gibi).

Oneri listesi:

- `so` -> `sales_order`
- `soi` -> `sales_order_item`
- `c` -> `customer`
- `pr` -> `product`
- `p` -> `payment`
- `sh` -> `shipment`

---

## 10) DML + veri butunlugu mini senaryo

Senaryo:
"Siparis iptal oldugunda stok geri eklensin ve odeme iadeye cekilsin."

Bu operasyon tek sorgu degil, is akisidir.

---

## 11) Alistirma seti

1. Yeni bir musteri ekle.
2. Belirli bir musterinin sehir bilgisini guncelle.
3. `status='new'` siparisleri `approved` yap.
4. `failed` odeme kayitlarini temizle.
5. Once `SELECT` sonra `DELETE` akisini her adimda uygula.
6. JOIN ile payment status toplu guncellemesi yaz.

---

## Sonuc

DML komutlari, SQL'in "yazan eli"dir.
Doğru kullanıldığında sistemi ilerletir,
yanlis kullanildiginda veriyi bozabilir.

Bu nedenle DML ogrenimi sadece syntax degil,
guvenlik, butunluk ve is akisiyla birlikte ele alinmalidir.

---

## 12) INSERT detaylari: sik kullanilan varyasyonlar

### 12.1 Varsayilan degerlerle insert

```sql
INSERT INTO warehouse (code, name, city)
VALUES ('W-BOD', 'Bodrum Mikro Depo', 'Mugla');
```

### 12.2 Hesaplanmis degerle insert

```sql
INSERT INTO sales_order (order_no, customer_id, order_date, status, total_amount)
VALUES ('SO-2025-0999', 1, NOW(), 'new', 0);
```

### 12.3 Idempotent insert fikri

Tekrar calistiginda cift kayit uretmemesi istenen islerde
benzersiz kolon ve kosullu insert birlikte dusunulur.

---

## 13) UPDATE detaylari: kontrollu degisim

### 13.1 Once sec, sonra guncelle

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

Buyuk tabloda tum satiri tek seferde guncellemek yerine
parti parti ilerlemek daha guvenli olabilir.

---

## 14) DELETE detaylari: geri donusu zor komut

`DELETE` en riskli DML komutudur.
Uretimde en iyi uygulama:

1. once snapshot/backup
2. once `SELECT` ile hedef
3. once sayi kontrolu
4. transaction icinde sil

### Ornek: transaction ile delete

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

Satir fiziksel olarak silinir.

Avantaj:
- tablo temiz kalir

Risk:
- geri donus zor

### Soft delete

Satiri silmek yerine `is_deleted=1` veya `deleted_at` set edilir.

Avantaj:
- geri alma kolay
- audit kolay

Risk:
- her sorguda filtre disiplini gerekir

---

## 16) Veri butunlugu: is kurali ornekleri

E-ticaret senaryosunda tipik kurallar:

1. `order_status = delivered` ise `shipment_status = delivered` olmali
2. `payment_status = paid` degilse bazi siparis gecisleri engellenmeli
3. `stock_qty` negatif olmamali
4. `order_total` ile satir toplamlari uyusmali

Bu kurallarin bir kismi DB constraint ile,
bir kismi application veya transaction akisiyla korunur.

---

## 17) Constraint ve DML iliskisi

### UNIQUE ihlali ornegi

`customer.email` benzersizse,
ayni email ile ikinci insert hata verir.

### FOREIGN KEY ihlali ornegi

Olmayan `customer_id` ile siparis insert denemesi hata verir.

### ON DELETE davranisi

FK tanimina gore:

- `CASCADE`: ebeveyn silinince cocuk da silinir
- `RESTRICT`: bagli kayit varsa ebeveyn silinemez

Uretimde bu kararlar tasarimin kritik parcasidir.

---

## 18) DML ve performans iliskisi

`UPDATE`/`DELETE` sorgularinda da index hayati olabilir.

Ornek:

```sql
EXPLAIN
UPDATE sales_order
SET status = 'approved'
WHERE status = 'new'
  AND order_date < '2025-01-10';
```

Burada uygun index yoksa tam tablo taramasi olabilir.

---

## 19) Alias kurallari: ileri seviye notlar

### Kisa ama anlamsiz alias'tan kacin

- kotu: `a`, `b`, `t1`, `t2`
- iyi: `so`, `soi`, `c`, `p`, `sh`

### Ayni tabloda farkli roller

Nadir durumlarda ayni tabloyu iki kez joinlersen
rol bazli alias ver:

- `c_bill` (fatura musteri)
- `c_ship` (teslim musteri)

### Sorgu ustu alias notu

Uzun sorguda ilk satira yorum ekleyebilirsin:

```sql
-- so:sales_order, soi:sales_order_item, c:customer, p:payment
```

Bu kucuk not ekip ici okunurlugu ciddi artirir.

---

## 20) DML guvenlik checklist'i

1. `WHERE` var mi?
2. Hedef satir sayisi biliniyor mu?
3. Once `SELECT` calisti mi?
4. Islem transaction icinde mi?
5. Rollback plani var mi?
6. Islem saati uygun mu? (is yukunun dusuk oldugu zaman)
7. Sonuç doğrulama sorgusu hazır mı?

---

## 21) Ornek: siparis durum gecis tablosu fikri

Durum geçişlerini doğrulamak için
kural tablosu kurulabilir:

```text
new -> approved
approved -> shipped
shipped -> delivered
new -> cancelled
approved -> cancelled
```

Bu tabloya dayali update kontrolu,
yanlis durum gecislerini azaltir.

---

## 22) DML test paketi (genis)

1. Yeni musteri ekle, ayni email ile ikinci insert dene.
2. Olmayan customer id ile siparis insert dene.
3. `new` siparisleri sec, sonra approved yap.
4. `pending` odemelerin bir kismini paid yap.
5. `failed` odeme kayitlarinda once sayi sonra delete yap.
6. Her adımdan sonra doğrulama select yaz.
7. Tum akisi transaction ile tekrar et.

---

## 23) Kapanış

DML komutlari SQL'in operasyonel kalbidir.
Ama guvenli DML; syntax + butunluk + test + rollback disiplininin toplamidir.

Bu disiplini erken oturtursan,
ileride transaction ve concurrency konulari cok daha kolay oturur.

---

## 24) DML komutlari icin "kirmizi cizgi" kurallari

Canli ortam icin pratik kirmizi cizgiler:

1. `UPDATE` ve `DELETE` komutunu `WHERE` olmadan calistirma.
2. `WHERE`te PK veya indexli kolon yoksa iki kez kontrol et.
3. Beklenen etkilenen satir adedini onceden yaz.
4. İşlem sonrası doğrulama sorgusu hazır olmadan çalıştırma.

Bu kurallar basit gorunur ama ciddi veri kaybini engeller.

---

## 25) DML degisiklik kaydi (change log) fikri

Operasyonel sistemlerde su model kullanilabilir:

- kritik update/delete oncesi
- eski degerleri log tablosuna yaz
- sonra asil degisikligi yap

Bu model geri izleme ve denetim icin faydalidir.

---

## 26) Son mini kontrol listesi

Komut calistirmadan once:

- hedef satirlar goruldu mu?
- transaction gerekli mi?
- rollback plani var mi?
- index durumu uygun mu?
- sonuc kontrolu hazir mi?

Bu bes adim, DML tarafinda profesyonel standart olusturur.
