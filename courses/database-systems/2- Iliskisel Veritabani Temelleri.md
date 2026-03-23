# Iliskisel Veritabani Temelleri

Veritabanina neden ihtiyac oldugunu netlestirdikten sonra sira, bu yapinin teknik iskeletini anlamaya gelir.  
Iliskisel modelin gucu, veriyi tablolarda tutarken tablolar arasindaki baglantilari da kurabilmesidir.

Bu yazida tablo mantigindan PK/FK'ye, iliski turlerinden basit sema okumaya kadar temel taslari birlikte netlestirecegiz.

---

## Iliskisel modelin cekirdegi

Iliskisel modeli tek cumlede ozetlersek:

```text
Iliskisel model = Tablolar + Iliskiler
```

Temel kavramlar:

- **Tablo**: Benzer kayitlari tutan yapi
- **Sutun (alan)**: Bilgi turu (ad, tarih, puan gibi)
- **Satir (kayit / tuple)**: Tek bir varliga ait alanlarin toplami
- **Relation**: Teorik dilde tablonun kendisi

---

## Alan (domain) ve veri tipi

Her sutun rastgele veri kabul etmez; bir "alan kurali" vardir.  
Buna domain mantigi denir.

Ornek:

```text
student
id               -> INT
student_no       -> VARCHAR
first_name       -> VARCHAR
gpa              -> DECIMAL
registration_year-> INT
```

Buradaki mantik su:
- `gpa` alanina metin yazilmaz,
- `registration_year` alanina gecersiz bicim girilmez,
- her alan kendi turune uygun veri alir.

Bu kural seti veri kalitesinin ilk katmanidir.

---

## Primary Key (PK): satiri tekil tanimlama

Bir tablodaki her satiri benzersiz tanimlayan alana **Primary Key** denir.

Ornek:

```text
student
id (PK), student_no, first_name, last_name, ...
```

PK kurallari:
- Benzersiz olmali
- `NULL` olmamali
- Satiri tek basina tanimlayabilmeli

Neden kritik?  
Cunku PK olmadan iki satirin ayni kayit olup olmadigini guvenli sekilde ayirt edemezsin.

---

## Foreign Key (FK): tablolari birbirine baglama

Bir tablodaki alanin, baska tablodaki PK'yi gostermesine **Foreign Key** denir.

Ornek:

```text
student.department_id -> department.id
```

Bu bag sayesinde:
- "Bu ogrenci hangi bolume ait?" sorusu netlesir,
- Gecersiz referanslar engellenir,
- Veride butunluk korunur.

---

## Iliski turleri: 1-1, 1-N, N-N

### 1-1 (bire bir)
Bir kayit en fazla bir kayitla eslesir.  
Ornek: ogrenci ve ogrenci kimlik karti bilgisi.

### 1-N (bire cok)
Bir kayit birden fazla kayitla iliskili olabilir.  
Ornek: bir bolumde birden fazla ogrenci olabilir.

### N-N (coka cok)
Iki tarafta da coklu iliski vardir.  
Ornek: ogrenci birden fazla ders alir, bir dersi birden fazla ogrenci alir.

Bu turde ara tablo gerekir:

```text
student <-> enrollment <-> course
```

---

## Ayni sema uzerinden dusunmek: university_sample

3. yazidaki gibi ayni veri yapisini kullanmak icin `veritabanı/kaynaklar/university_sample.sql` dosyasini MySQL Workbench ile import edebilirsin.

Kisa akis:

1. `File > Open SQL Script...`
2. `university_sample.sql` dosyasini ac
3. Scripti calistir
4. `USE university_sample;`

Kontrol sorgulari:

```sql
SHOW TABLES;
DESCRIBE student;
DESCRIBE department;
```

Bu sayede kavramlari soyut degil, gercek tablolar uzerinde gorursun.

---

## Basit sema okuma pratigi

Su iliskiyi okudugunda ne anlarsin?

```text
department (id PK)
   ^
   |
student (department_id FK)
```

Cevap:
- Her `student` kaydi bir `department` kaydina baglidir.
- Bir `department` kaydina birden fazla `student` baglanabilir.
- Bu, klasik bir **1-N** iliskidir.

---

## Sık yapilan hatalar

- PK ve FK farkini karistirmak
- N-N iliskiyi ara tablo kurmadan modellemeye calismak
- Veri tiplerini gelisiguzel secmek
- Sutun adlarini anlamsiz kisaltmalarla doldurmak

Iyi bir modelleme icin pratik kural:
- once varliklari (tablolari) bul,
- sonra alanlari yaz,
- sonra PK sec,
- en son iliskileri FK ile kur.

---

## Sonuc

Iliskisel model, SQL yazmadan once oturmasi gereken zihinsel cercevedir.  
Tablo, alan, kayit, PK ve FK mantigi net oldugunda, `SELECT`, `JOIN` ve diger sorgular mekanik bir ezber olmaktan cikar.
