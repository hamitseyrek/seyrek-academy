# SQL Temelleri: SELECT

Veri depolamak tek başına yeterli değildir. Asıl değer, doğru soruları doğru şekilde sorabildiğin anda ortaya çıkar. SQL'in en temel parçası olan `SELECT`, tablolardaki veriyi çekmek, filtrelemek, sıralamak ve anlamlı hale getirmek için kullanılır.

Bu yazıda tüm örnekler, `veritabanı/kaynaklar/university_sample.sql` dosyasindan import edilen aynı veri yapisi üzerinden ilerler.

---

## MySQL Workbench ile örnek veritabanı import etme

1. MySQL Workbench'i aç ve bir baglantiya giriş yap.
2. Ust menuden `File > Open SQL Script...` seç.
3. `veritabanı/kaynaklar/university_sample.sql` dosyasını aç.
4. Script penceresinde tüm sorguları çalıştır (yildirim simgesi).
5. Sol taraftaki `SCHEMAS` panelinde `university_sample` veritabanını gör.
6. Yeni bir sorgu sekmesinde şu komutu çalıştır:

```sql
USE university_sample;
```

Kontrol için:

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

Tüm satır ve tüm sütunları çekmek için:

```sql
SELECT * FROM student;
```

Buradaki `*`, "tüm sutunlar" demektir. İlk bakis ve hizli kontrol için kullanislidir.

---

## Gereken sütunları seçmek

Cogu durumda tüm sutunlara ihtiyaç yoktur:

```sql
SELECT student_no, first_name, last_name
FROM student;
```

Bu yaklaşım:
- gereksiz veri tasimazini azaltır,
- çıktıyı okunabilir hale getirir.

---

## DISTINCT ile tekrar eden değerleri tekillestirmek

Hangi `department_id` degerlerinin olduğunu görmek için:

```sql
SELECT DISTINCT department_id
FROM student;
```

`DISTINCT`, aynı değerleri tek satıra indirir.

---

## Alias (AS) ile daha anlasilir basliklar

Teknik alan adlarını daha okunur hale getirmek için:

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

ID değeri belirli bir seviyenin üzerinde olanlar:

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

## AND ve OR ile çoklu kosullar

Department'i 1 olan ve not ortalaması 3.00'dan büyük olanlar:

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

Adi A ile başlayan ogrenciler:

```sql
SELECT *
FROM student
WHERE first_name LIKE 'A%';
```

Icerisinde `me` geçen adlar:

```sql
SELECT *
FROM student
WHERE first_name LIKE '%me%';
```

---

## ORDER BY ile sıralama

Isim ve soyisime göre alfabetik:

```sql
SELECT student_no, first_name, last_name
FROM student
ORDER BY first_name ASC, last_name ASC;
```

Not ortalamasına göre yüksekten düşüğe:

```sql
SELECT student_no, first_name, gpa
FROM student
ORDER BY gpa DESC;
```

---

## LIMIT ile sonuç sayisini kisitlamak

İlk 3 kaydı görmek için:

```sql
SELECT *
FROM student
LIMIT 3;
```

---

## Tüm yapiyi bir araya getiren örnek

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
- başlıkları düzenlersin,
- filtre uygularsin,
- sıralarsın,
- sonucu sinirlarsin.

---

## Kısa pratik listesi

Şu istekleri aynı veritabanı üzerinden SQL'e cevir:

1. `course` tablosundaki tüm ders kodlari ve adlarını getir.
2. `student` tablosunda 2023 kayitli olanları listele.
3. `department_id` değerlerini tekil olarak getir.
4. `gpa` değeri 3.20 ve üstü olanları yüksekten düşüğe sırala.
5. Adi `E` ile başlayan ogrencilerden ilk 2 kaydı getir.

---

## Son soz

`SELECT`, SQL'in yalnızca baslangic komutu değil; veriyle kurdugun iletisimin merkezidir.  
`university_sample` üzerinde bu temel kalıpları oturttuğunda, veriyi çekme, filtreleme ve sıralama tarafinda güçlü bir temel kurmus olursun.
