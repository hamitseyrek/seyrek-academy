# İlişkisel Veritabanı Temelleri

Veritabanına neden ihtiyaç olduğunu netleştirdikten sonra sıra, bu yapının teknik iskeletini anlamaya gelir.  
İlişkisel modelin gücü, veriyi tablolarda tutarken tablolar arasındaki bağlantıları da kurabilmesidir.

Bu yazıda tablo mantığından PK/FK'ye, ilişki türlerinden basit şema okumaya kadar temel taşları birlikte netleştireceğiz.

---

## İlişkisel modelin çekirdeği

İlişkisel modeli tek cümlede özetlersek:

```text
İlişkisel model = Tablolar + Iliskiler
```

Temel kavramlar:

- **Tablo**: Benzer kayıtları tutan yapı
- **Sütun (alan)**: Bilgi turu (ad, tarih, puan gibi)
- **Satır (kayıt / tuple)**: Tek bir varliga ait alanların toplamı
- **Relation**: Teorik dilde tablonun kendisi

---

## Alan (domain) ve veri tipi

Her sütun rastgele veri kabul etmez; bir "alan kuralı" vardır.  
Buna domain mantığı denir.

Örnek:

```text
student
id               -> INT
student_no       -> VARCHAR
first_name       -> VARCHAR
gpa              -> DECIMAL
registration_year-> INT
```

Buradaki mantik şu:
- `gpa` alanına metin yazılmaz,
- `registration_year` alanına geçersiz biçim girilmez,
- her alan kendi türüne uygun veri alır.

Bu kural seti veri kalitesinin ilk katmanıdır.

---

## Primary Key (PK): satırı tekil tanimlama

Bir tablodaki her satırı benzersiz tanımlayan alana **Primary Key** denir.

Örnek:

```text
student
id (PK), student_no, first_name, last_name, ...
```

PK kuralları:
- Benzersiz olmalı
- `NULL` olmamali
- Satiri tek başına tanımlayabilmeli

Neden kritik?  
Çünkü PK olmadan iki satırın aynı kayıt olup olmadığını güvenli şekilde ayırt edemezsin.

---

## Foreign Key (FK): tabloları birbirine bağlama

Bir tablodaki alanın, başka tablodaki PK'yi göstermesine **Foreign Key** denir.

Örnek:

```text
student.department_id -> department.id
```

Bu bag sayesinde:
- "Bu öğrenci hangi bolume ait?" sorusu netleşir,
- Geçersiz referanslar engellenir,
- Veride bütünlük korunur.

---

## İlişki türleri: 1-1, 1-N, N-N

### 1-1 (bire bir)
Bir kayıt en fazla bir kayitla eşleşir.  
Örnek: öğrenci ve öğrenci kimlik kartı bilgisi.

### 1-N (bire çok)
Bir kayıt birden fazla kayitla ilişkili olabilir.  
Örnek: bir bölümde birden fazla öğrenci olabilir.

### N-N (çoka çok)
Iki tarafta da çoklu ilişki vardır.  
Örnek: öğrenci birden fazla ders alır, bir dersi birden fazla öğrenci alır.

Bu türde ara tablo gerekir:

```text
student <-> enrollment <-> course
```

---

## Aynı şema üzerinden dusunmek: university_sample

3. yazidaki gibi aynı veri yapisini kullanmak için `veritabanı/kaynaklar/university_sample.sql` dosyasını MySQL Workbench ile import edebilirsin.

Kısa akis:

1. `File > Open SQL Script...`
2. `university_sample.sql` dosyasını aç
3. Scripti çalıştır
4. `USE university_sample;`

Kontrol sorguları:

```sql
SHOW TABLES;
DESCRIBE student;
DESCRIBE department;
```

Bu sayede kavramları soyut değil, gerçek tablolar üzerinde görürsün.

---

## Basit şema okuma pratiği

Şu ilişkiyi okudugunda ne anlarsın?

```text
department (id PK)
   ^
   |
student (department_id FK)
```

Cevap:
- Her `student` kaydı bir `department` kaydına bağlıdır.
- Bir `department` kaydına birden fazla `student` bağlanabilir.
- Bu, klasik bir **1-N** ilişkidir.

---

## Sık yapılan hatalar

- PK ve FK farkını karıştırmak
- N-N ilişkiyi ara tablo kurmadan modellemeye çalışmak
- Veri tiplerini gelişigüzel seçmek
- Sütun adlarını anlamsız kısaltmalarla doldurmak

İyi bir modelleme için pratik kural:
- önce varlıkları (tabloları) bul,
- sonra alanlari yaz,
- sonra PK seç,
- en son ilişkileri FK ile kur.

---

## Sonuç

İlişkisel model, SQL yazmadan önce oturmasi gereken zihinsel çerçevedir.  
Tablo, alan, kayıt, PK ve FK mantığı net olduğunda, `SELECT`, `JOIN` ve diğer sorgular mekanik bir ezber olmaktan çıkar.
