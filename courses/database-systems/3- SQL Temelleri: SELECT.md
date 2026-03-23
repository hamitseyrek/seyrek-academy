# SQL Temelleri: SELECT

Veri depolamak tek başına yeterli değildir. Asıl değer, doğru soruları doğru şekilde sorabildiğin anda ortaya çıkar. SQL'in en temel parçası olan `SELECT`, tablolardaki veriyi çekmek, filtrelemek, sıralamak ve anlamlı hale getirmek için kullanılır.

Bu yazida tum ornekler, `veritabanı/kaynaklar/university_sample.sql` dosyasindan import edilen ayni veri yapisi uzerinden ilerler.

---

## MySQL Workbench ile ornek veritabani import etme

1. MySQL Workbench'i ac ve bir baglantiya giris yap.
2. Ust menuden `File > Open SQL Script...` sec.
3. `veritabanı/kaynaklar/university_sample.sql` dosyasini ac.
4. Script penceresinde tum sorgulari calistir (yildirim simgesi).
5. Sol taraftaki `SCHEMAS` panelinde `university_sample` veritabanini gor.
6. Yeni bir sorgu sekmesinde su komutu calistir:

```sql
USE university_sample;
```

Kontrol icin:

```sql
SHOW TABLES;
```

Beklenen tablo listesi:
- `department`
- `student`
- `course`
- `enrollment`

---

## SELECT'in en temel hali

Tum satir ve tum sutunlari cekmek icin:

```sql
SELECT * FROM student;
```

Buradaki `*`, "tum sutunlar" demektir. Ilk bakis ve hizli kontrol icin kullanislidir.

---

## Gereken sutunlari secmek

Cogu durumda tum sutunlara ihtiyac yoktur:

```sql
SELECT student_no, first_name, last_name
FROM student;
```

Bu yaklasim:
- gereksiz veri tasimazini azaltir,
- ciktiyi okunabilir hale getirir.

---

## DISTINCT ile tekrar eden degerleri tekillestirmek

Hangi `department_id` degerlerinin oldugunu gormek icin:

```sql
SELECT DISTINCT department_id
FROM student;
```

`DISTINCT`, ayni degerleri tek satira indirir.

---

## Alias (AS) ile daha anlasilir basliklar

Teknik alan adlarini daha okunur hale getirmek icin:

```sql
SELECT student_no AS student_number,
       first_name AS name,
       last_name AS surname
FROM student;
```

---

## WHERE ile filtreleme

Belirli bir department icindeki ogrenciler:

```sql
SELECT *
FROM student
WHERE department_id = 1;
```

ID degeri belirli bir seviyenin uzerinde olanlar:

```sql
SELECT *
FROM student
WHERE id > 5;
```

Belirli bir aralik:

```sql
SELECT *
FROM student
WHERE registration_year BETWEEN 2022 AND 2023;
```

---

## AND ve OR ile coklu kosullar

Department'i 1 olan ve not ortalamasi 3.00'dan buyuk olanlar:

```sql
SELECT *
FROM student
WHERE department_id = 1
  AND gpa > 3.00;
```

Department'i 1 veya 2 olanlar:

```sql
SELECT *
FROM student
WHERE department_id = 1
   OR department_id = 2;
```

---

## LIKE ile metin deseni aramak

Adi A ile baslayan ogrenciler:

```sql
SELECT *
FROM student
WHERE first_name LIKE 'A%';
```

Icerisinde `me` gecen adlar:

```sql
SELECT *
FROM student
WHERE first_name LIKE '%me%';
```

---

## ORDER BY ile siralama

Isim ve soyisime gore alfabetik:

```sql
SELECT student_no, first_name, last_name
FROM student
ORDER BY first_name ASC, last_name ASC;
```

Not ortalamasina gore yuksekten dusuge:

```sql
SELECT student_no, first_name, gpa
FROM student
ORDER BY gpa DESC;
```

---

## LIMIT ile sonuc sayisini kisitlamak

Ilk 3 kaydi gormek icin:

```sql
SELECT *
FROM student
LIMIT 3;
```

---

## Tum yapiyi bir araya getiren ornek

```sql
SELECT student_no AS student_number,
       first_name AS name,
       last_name AS surname,
       gpa
FROM student
WHERE department_id = 1
  AND gpa >= 3.00
ORDER BY gpa DESC
LIMIT 5;
```

Bu tek sorgu ile:
- alan secersin,
- basliklari duzenlersin,
- filtre uygularsin,
- siralarsin,
- sonucu sinirlarsin.

---

## Kisa pratik listesi

Su istekleri ayni veritabani uzerinden SQL'e cevir:

1. `course` tablosundaki tum ders kodlari ve adlarini getir.
2. `student` tablosunda 2023 kayitli olanlari listele.
3. `department_id` degerlerini tekil olarak getir.
4. `gpa` degeri 3.20 ve ustu olanlari yuksekten dusuge sirala.
5. Adi `E` ile baslayan ogrencilerden ilk 2 kaydi getir.

---

## Son soz

`SELECT`, SQL'in yalnizca baslangic komutu degil; veriyle kurdugun iletisimin merkezidir.  
`university_sample` uzerinde bu temel kaliplari oturttugunda, veriyi cekme, filtreleme ve siralama tarafinda guclu bir temel kurmus olursun.
