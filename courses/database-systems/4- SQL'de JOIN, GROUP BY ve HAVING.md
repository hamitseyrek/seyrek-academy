# SQL'de JOIN, GROUP BY ve HAVING

Bu makale, `3- SQL Temelleri: SELECT.md` dosyasının doğrudan devamıdır.
Odak noktasi:

- birden fazla tablodan veri birlestirme (`JOIN`)
- veriyi ozetleme (`GROUP BY`)
- gruplanmis sonucu filtreleme (`HAVING`)

Tum ornekler `veritabanı/kaynaklar/retail_ops_sample.sql` verisi uzerindedir.

---

## 1) Tablo alias'i (`so`, `c`, `p`) neden kullanilir?

Asagidaki ifade bir kisaltma degil, tablo takma adidir:

```sql
FROM sales_order so
JOIN customer c ON c.id = so.customer_id
```

Burada:

- `so` = `sales_order`
- `c` = `customer`

### Alias kullanmanin faydasi

- Uzun adlari tekrar tekrar yazmazsin
- JOIN'li sorgular daha okunur olur
- Ayni isimli kolonlarda belirsizlik azalir (`status` gibi)

### Alias kullanma kurallari (onerilen standart)

1. Her tabloda tutarli ol: `sales_order` her yerde `so` olsun.
2. Anlamsiz tek harflerden kacin: `a`, `b`, `x` yerine `so`, `soi`, `pr`.
3. Cok tablo varsa alias listeni sorgu ustunde yorumla notu olarak yazabilirsin.
4. Takim standardi varsa ona uy.

---

## 3) JOIN'e gecis: tek tablodan coklu tabloya

### 3.1 Tek tablo

```sql
SELECT order_no, customer_id, status, total_amount
FROM sales_order
ORDER BY order_date DESC;
```

Bu sorgu siparisleri getirir ama musteri adini vermez.
`customer_id` sayisal bir anahtar oldugu icin tek basina is tarafinda yeterince okunur olmaz.

### 3.2 Ilk JOIN: siparis + musteri

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

Bu sorgu ne yapiyor?

- `sales_order` tablosunu temel aliyor.
- `customer` tablosuyla `customer_id` uzerinden eslestirme yapiyor.
- Siparis numarasi, tarih, musteri adi, durum ve tutari tek satirda gosteriyor.
- Sonuclari en yeni siparis ustte olacak sekilde siraliyor.

Satir satir semantik:

- `SELECT ...`: ciktiya alinacak kolonlari tanimlar.
- `FROM sales_order so`: ana veri kaynagi siparis tablosudur.
- `JOIN customer c ON c.id = so.customer_id`: siparisi musteriyle iliski anahtari uzerinden eslestirir.
- `ORDER BY so.order_date DESC`: ciktiyi tarihe gore en yeniden eskiye siralar.

### 3.3 LEFT JOIN ile odeme durumunu ekleme

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

`LEFT JOIN` secimi, odemesi henuz olusmayan siparisleri listede tutar.
Bu nedenle `payment_status` bazen `NULL` gelebilir; bu bir hata degil, odeme kaydinin henuz olusmadigi anlamina gelir.

---

## 4) JOIN turleri

### INNER JOIN

Iki tabloda da eslesen satirlari getirir.

```sql
SELECT so.order_no, c.full_name
FROM sales_order so
INNER JOIN customer c ON c.id = so.customer_id;
```

Burada yalnizca iki tabloda da eslesme olan satirlar doner.

### LEFT JOIN

Soldaki tum satirlari getirir, eslesmeyen sag kolonlar `NULL` olur.

```sql
SELECT so.order_no, p.status
FROM sales_order so
LEFT JOIN payment p ON p.order_id = so.id;
```

Bu sorgu, odemesi olmayan siparisleri de gormek istedigin durumlarda kullanilir.

### RIGHT JOIN

MySQL'de desteklenir, ama pratikte daha okunur oldugu icin
tablolari yer degistirip `LEFT JOIN` kullanmak daha yaygindir.

---

## 5) JOIN'de sik hatalar

### 5.1 Yanlis ON kosulu

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

Neden dogru?

- `payment.id` ile `sales_order.id` farkli varliklarin PK alanlaridir.
- Iliski `payment.order_id -> sales_order.id` oldugu icin `ON` kosulu bu sekilde kurulmalidir.

### 5.2 Belirsiz kolon kullanimi

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

Bu adlandirma, ayni isimli iki kolonu (`status`) karistirmadan okumayi saglar.

---

## 6) GROUP BY: satirdan ozet bilgiye gecis

`GROUP BY`, satir satir veriyi ozet bilgiye cevirir.

### 6.1 Kategori bazli ciro

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

Bu sorgu ne yapiyor?

- Siparis kalemlerini urun ve kategoriyle bagliyor.
- Her kategori icin toplam adet ve toplam ciro hesapliyor.
- En yuksek ciroyu ustte gosterecek sekilde siraliyor.

Satir satir semantik:

- `SELECT cat.name AS category_name`: kategori adini ciktiya "category_name" olarak verir.
- `SUM(soi.quantity) AS total_units`: her grup icin toplam satilan adet hesaplar.
- `ROUND(SUM(soi.line_total), 2) AS gross_revenue`: her grup icin toplam ciroyu iki ondalikla verir.
- `FROM sales_order_item soi`: hesaplamanin taban satirlari siparis kalemleridir.
- `JOIN product pr ...`: her kalemi ilgili urunle eslestirir.
- `JOIN category cat ...`: urunden kategoriye gecis yapar.
- `GROUP BY cat.id, cat.name`: toplamlarin kategori bazinda alinacagini tanimlar.
- `ORDER BY gross_revenue DESC`: ciroya gore buyukten kucuge siralar.

Neden `GROUP BY` gerekli?

- Sorguda hem aggregate (`SUM`) hem de aggregate olmayan kolon (`cat.name`) var.
- Bu nedenle aggregate olmayan kolonlarin gruplama anahtarina alinmasi gerekir.
- `GROUP BY` kaldirilirsa cogu SQL motorunda hata alirsin.

### 6.2 Musteri bazli siparis ozeti

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

Burada her satir bir musteriyi temsil eder; ayni musteriye ait tum siparisler tek satira ozetlenir.

---

## 7) HAVING: gruplanmis sonucu filtreleme

`WHERE` satirlari gruplanmadan once filtreler.
`HAVING` gruplanmis sonuca kosul uygular.

### 7.1 Cirosu 10000 ustu kategoriler

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

`HAVING` filtresi, grup olustuktan sonra calistigi icin kategori bazli toplamlara kosul koyabiliriz.

### 7.2 En az 2 siparisi olan musteriler

```sql
SELECT c.full_name,
       COUNT(so.id) AS order_count
FROM customer c
JOIN sales_order so ON so.customer_id = c.id
GROUP BY c.id, c.full_name
HAVING COUNT(so.id) >= 2
ORDER BY order_count DESC;
```

Bu sorgu, en az iki siparis veren musterileri bulmak icin ideal kaliptir.

---

## 8) WHERE ve HAVING birlikte

Gercek hayatta ikisi birlikte kullanilir:

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

- `WHERE`: iptal siparisleri cikar
- `GROUP BY`: sehir bazli ozetle
- `HAVING`: esigi asmayan gruplari ele

---

## Sonuc

`JOIN` veriyi birlestirir.
`GROUP BY` veriyi ozetler.
`HAVING` ozet sonuca karar kosulu uygular.

Bu uc yapinin birlikte kullanimi,
raporlama ve operasyon analizi icin SQL'in omurgasini olusturur.

---

## 10) JOIN karar agaci: hangi durumda hangi JOIN?

Sorguyu yazmadan once su soruyu sor:
"Soldaki kayitlarin hepsini korumam gerekiyor mu?"

- Evet -> `LEFT JOIN`
- Hayir, yalnizca eslesenler -> `INNER JOIN`

Ikinci soru:
"Eslesmeyen kayitlari tespit etmek istiyor muyum?"

- Evet -> `LEFT JOIN ... WHERE sag_tablo.id IS NULL`

Ornek: odeme kaydi olmayan siparisler:

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

## 11) Ayni sorunun 3 farkli JOIN cozum stili

Soru:
"Her siparis icin musteri, odeme ve kargo durumunu getir."

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
  -- siparis
  so.order_no,
  so.order_date,
  so.status AS order_status,
  -- musteri
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

### Stil 3: Once CTE sonra final secim

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
- Ana sorguyu parcalara ayirarak okunabilirligi artirir.
- Ozellikle uzun JOIN zincirlerinde ilk adimi sade bir "base set" haline getirir.

Bu ornekte CTE ne yapiyor?

- `order_base` adli ilk adimda siparis + musteri bilgisi tek bir ara sonuc olarak uretiliyor.
- Alttaki final sorgu bu ara sonucu kullanip odeme ve kargo kolonlarini ekliyor.
- Boylece tek sorguda her seyi ust uste yazmak yerine, mantik iki asamada okunuyor.

Üç stil de doğru olabilir.
Takim okunabilirligi hangi stilde daha yuksekse onu sec.

---

## 12) GROUP BY'da "granularity" kavrami

Granularity = raporun satir seviyesi.

Ornek:

- `GROUP BY city` -> sehir seviyesi
- `GROUP BY city, segment` -> sehir + segment seviyesi
- `GROUP BY city, segment, status` -> daha detayli seviye

Ayni veri, farkli granularity ile farkli karar bilgisi uretir.

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

## 13) HAVING ile is kurali filtreleri

`HAVING` sadece "buyuk-kucuk" icin degil,
is kurali tabanli raporlarda da kullanilir.

### En az 2 farkli urun alan musteriler

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

### Ortalama sepeti 10000 ustu sehirler

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

Cok tablolu sorgularda en sik problem:
satir carpimi nedeniyle toplamlarin sismesi.

Kontrol adimi:

1. Once ham satir sayisi
2. Sonra grup sonucu
3. Sonra birim test sorgusu

### Ham satir

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

### Rastgele bir siparisi manuel kontrol

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

## 15) Alias sozlugu (makale serisi standardi)

Bu seride su alias'lari sabit tut:

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

Bu standardi korumak, okuma suresini ciddi azaltir.

---

## 16) Pratik: 10 ek JOIN/HAVING gorevi

1. Sehir bazinda `delivered` siparis sayisini getir.
2. Odeme metodu `card` olan siparislerin toplam tutarini hesapla.
3. Kargosu `in_transit` olan siparisleri musteri adiyla listele.
4. Her kategoride en cok satilan urunun SKU bilgisini getir.
5. Her depoda kritik stok adedini say.
6. Segmente gore ortalama siparis tutarini hesapla.
7. En az 2 sehirde satis yapan musterileri bul.
8. Kargo ucreti ortalamanin ustunde olan siparisleri getir.
9. Iptal siparislerin sehir dagilimini cikar.
10. Toplam cirosu 30000 ustu musterileri listele.

---

## 17) Sorgu yazim kalibi (tekrar kullan)

JOIN + GROUP BY sorgusu yazarken su kalip:

1. `FROM` tablosunu belirle
2. `JOIN` iliskilerini birer birer ekle
3. `WHERE` satir filtresini yaz
4. `GROUP BY` granularity sec
5. `HAVING` grup filtresi ekle
6. `ORDER BY` rapor okunurlugu ayarla

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

`JOIN` bilmek tek basina yetmez.
Asil farki su kombinasyon yaratir:

- doğru JOIN
- doğru granularity
- doğru HAVING filtresi
- doğru doğrulama adımı

Bu disiplini kurdugunda,
raporlar sadece calisan degil,
guvenilir hale gelir.
