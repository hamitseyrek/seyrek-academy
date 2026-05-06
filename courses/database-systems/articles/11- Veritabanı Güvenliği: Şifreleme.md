# Veritabanı Güvenliği: Şifreleme

Veritabanı güvenliği, yalnızca kullanıcı adı ve parola kontrolünden ibaret değildir.  
Bir saldırgan sisteme eriştiğinde asıl hedef çoğu zaman verinin kendisidir.  
Bu nedenle güvenliğin temel sorusu şudur: **Veri ele geçirilirse okunabilir mi?**

Şifreleme bu soruya verilen en kritik teknik yanıttır.  
Bu makalede konu adım adım ve sade bir dille ele alınır; anlatım MySQL Workbench üzerinde çalıştırılabilir örneklerle desteklenir.

> Not: Kod örnekleri MySQL 8+ sürümüne göre hazırlanmıştır.

## 1. Neden şifreleme gerekir?

Veri güvenliğinde iki farklı risk vardır:

- **Veri kaybı:** Veri silinir, bozulur veya erişilemez hale gelir.
- **Veri sızıntısı:** Veri yetkisiz kişiler tarafından görülür.

Şifreleme özellikle veri sızıntısı riskine karşı koruma sağlar.  
Çünkü veritabanı dosyası ele geçirilse bile, veriyi okumak için gereken **anahtar** (şifreli veriyi tekrar okunur hale getiren gizli bilgi) yoksa içerik anlamlı hale gelemez.

Kısa benzetme:
- Erişim kontrolü kapı kilididir.
- Şifreleme kasadır.

Kapı aşılırsa kasa ikinci savunma katmanını oluşturur.

## 2. Güvenliğin üç temel hedefi

### 2.1 Gizlilik (Confidentiality)

Verinin yalnızca yetkili kişiler tarafından görülebilmesidir.  
Şifrelemenin birincil amacı gizliliktir.

### 2.2 Bütünlük (Integrity)

Verinin izinsiz değiştirilmediğinden emin olmaktır.  
Önemli nokta: **Şifreleme tek başına bütünlük garantisi vermez.**

Burada `HMAC` devreye girer.  
`HMAC` (Hash-based Message Authentication Code), veri ile gizli anahtar birlikte kullanılarak üretilen doğrulama etiketidir.  
Etiket doğrulanmıyorsa veri değiştirilmiş kabul edilir.

### 2.3 Erişilebilirlik (Availability)

Yetkili kişinin veriye ihtiyaç duyduğunda erişebilmesidir.  
Anahtar kaybolursa veri fiziksel olarak durur, ancak açılamadığı için pratikte kullanılamaz.

## 3. Workbench ortamını hazırlama

Önce örnekleri çalıştıracağımız ortamı oluşturalım.

```sql
-- Eski deneme veritabanını temizle
DROP DATABASE IF EXISTS security_lab;

-- Yeni veritabanı oluştur
CREATE DATABASE security_lab;

-- Bu veritabanında çalış
USE security_lab;

-- Parola doğrulama örnekleri için kullanıcı tablosu
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash CHAR(64) NOT NULL,
    salt CHAR(32) NOT NULL
);

-- Hassas alan şifreleme örnekleri için müşteri tablosu
CREATE TABLE customer_secure (
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    national_id_enc VARBINARY(255) NOT NULL,
    note VARCHAR(255)
);
```

## 4. Parola neden hash ile saklanır?

Parola saklamada amaç, parolayı geri okumak değildir.  
Amaç, kullanıcının doğru parola girip girmediğini doğrulamaktır.  
Bu yüzden parola için **hash** kullanılır.

`Hash`, bir veriden üretilen tek yönlü sabit uzunluklu çıktıdır.  
Buradaki "çıktı", verinin kendisi değil; veriyi temsil eden matematiksel parmak izidir.

Bu makalede `SHA2(..., 256)` kullanıyoruz:

- `SHA` (Secure Hash Algorithm), hash algoritmaları ailesidir.
- `SHA-256`, bu ailenin 256 bitlik çıktı üreten sürümüdür.
- Girdi küçük değişse bile hash çıktısı tamamen değişir.
- Hash çıktısından orijinal metni geri elde etmek pratikte mümkün değildir.

### 4.1 Hash + salt ile kullanıcı kaydetme

`Salt`, her kullanıcı için üretilen rastgele ek veridir.  
Aynı parolayı kullanan iki kullanıcıda aynı hash çıktısının oluşmasını engeller.

```sql
USE security_lab;

-- Alice için rastgele salt üret
SET @salt_alice = REPLACE(UUID(), '-', '');

-- password_hash = SHA2(parola + salt, 256)
INSERT INTO users (username, password_hash, salt)
VALUES (
    'alice',
    SHA2(CONCAT('P@ssw0rd!', @salt_alice), 256),
    @salt_alice
);

-- Kaydı kontrol et
SELECT id, username, password_hash, salt
FROM users
WHERE username = 'alice';
```

### 4.2 Giriş doğrulama mantığı

Kullanıcının girdiği parola, veritabanında saklı `salt` ile tekrar hashlenir.  
Üretilen değer saklı hash ile eşitse giriş başarılıdır.

```sql
-- Doğru parola denemesi
SET @input_password = 'P@ssw0rd!';

SELECT
    username,
    CASE
        WHEN password_hash = SHA2(CONCAT(@input_password, salt), 256)
        THEN 'GIRIS_BASARILI'
        ELSE 'GIRIS_HATALI'
    END AS login_result
FROM users
WHERE username = 'alice';
```

Yanlış parola denemesi:

```sql
SET @input_password = 'yanlis-parola';

SELECT
    username,
    CASE
        WHEN password_hash = SHA2(CONCAT(@input_password, salt), 256)
        THEN 'GIRIS_BASARILI'
        ELSE 'GIRIS_HATALI'
    END AS login_result
FROM users
WHERE username = 'alice';
```

## 5. Salt etkisini görme

Aynı parolayı kullanan ikinci bir kullanıcı ekleyelim.

```sql
-- Bob için farklı salt üret
SET @salt_bob = REPLACE(UUID(), '-', '');

-- Bob aynı parolayı kullansın
INSERT INTO users (username, password_hash, salt)
VALUES (
    'bob',
    SHA2(CONCAT('P@ssw0rd!', @salt_bob), 256),
    @salt_bob
);

-- Salt farklı olduğu için hash de farklı olacaktır
SELECT username, salt, password_hash
FROM users
WHERE username IN ('alice', 'bob');
```

## 6. Geri okunacak veride şifreleme

Parola geri okunmaz, ama bazı veriler iş akışında geri okunmalıdır.  
Örneğin kimlik numarası doğrulama süreçlerinde gerekebilir.

Bu tür alanlarda `AES` kullanılabilir:

- `AES` (Advanced Encryption Standard), simetrik şifreleme algoritmasıdır.
- **Simetrik** demek, şifreleme ve çözme için aynı anahtarın kullanılmasıdır.
- `AES_ENCRYPT` düz metni şifreler.
- `AES_DECRYPT` doğru anahtarla veriyi geri açar.

### 6.1 Veriyi şifreleyerek kaydetme

```sql
USE security_lab;

-- Demo anahtarı (gerçek projede anahtar kod içine yazılmaz)
SET @enc_key = 'demo-key-32-char-example-123456';

INSERT INTO customer_secure (full_name, national_id_enc, note)
VALUES (
    'Ayse Demir',
    AES_ENCRYPT('12345678901', @enc_key),
    'Musteri notu'
);

-- Şifreli değeri ham biçimde görmek için HEX kullan
SELECT
    id,
    full_name,
    HEX(national_id_enc) AS encrypted_national_id
FROM customer_secure;
```

### 6.2 Doğru anahtarla geri çözme

```sql
SET @enc_key = 'demo-key-32-char-example-123456';

SELECT
    id,
    full_name,
    CAST(AES_DECRYPT(national_id_enc, @enc_key) AS CHAR(11)) AS national_id_plain
FROM customer_secure;
```

### 6.3 Yanlış anahtarla çözme denemesi

```sql
SET @wrong_key = 'wrong-key';

SELECT
    id,
    full_name,
    AES_DECRYPT(national_id_enc, @wrong_key) AS wrong_result
FROM customer_secure;
```

Beklenen durum: yanlış anahtarda anlamlı sonuç alınmaz.

## 7. Bütünlük kontrolü: veri değişti mi?

Bu bölüm, bütünlük fikrini Workbench üzerinde görünür hale getirir.  
Gerçek sistemde bu amaçla HMAC tercih edilir.

```sql
USE security_lab;

-- Mesaj ve doğrulama alanı
CREATE TABLE IF NOT EXISTS message_store (
    id INT PRIMARY KEY AUTO_INCREMENT,
    payload TEXT NOT NULL,
    checksum CHAR(64) NOT NULL
);

-- Orijinal mesaj
SET @payload = 'odeme=1250;para_birimi=TRY';

-- Mesaj + gizli değer ile checksum üret
INSERT INTO message_store (payload, checksum)
VALUES (@payload, SHA2(CONCAT(@payload, 'app-secret-demo'), 256));

-- İlk tutarlılık kontrolü
SELECT
    id,
    payload,
    checksum,
    SHA2(CONCAT(payload, 'app-secret-demo'), 256) AS recalculated_checksum,
    CASE
        WHEN checksum = SHA2(CONCAT(payload, 'app-secret-demo'), 256) THEN 'TUTARLI'
        ELSE 'DEGISTIRILMIS'
    END AS integrity_status
FROM message_store;
```

Şimdi veriyi değiştirip tekrar kontrol edelim:

```sql
UPDATE message_store
SET payload = 'odeme=50;para_birimi=TRY'
WHERE id = 1;

SELECT
    id,
    payload,
    checksum,
    SHA2(CONCAT(payload, 'app-secret-demo'), 256) AS recalculated_checksum,
    CASE
        WHEN checksum = SHA2(CONCAT(payload, 'app-secret-demo'), 256) THEN 'TUTARLI'
        ELSE 'DEGISTIRILMIS'
    END AS integrity_status
FROM message_store;
```

Beklenen sonuç: `integrity_status` değeri `DEGISTIRILMIS` olur.

## 8. Maskeleme: verinin tamamını göstermemek

Bazı ekranlarda tam veriyi göstermek gereksiz ve risklidir.  
Bu durumda maskeleme uygulanır.

```sql
SET @enc_key = 'demo-key-32-char-example-123456';

SELECT
    id,
    full_name,
    CONCAT('*******', RIGHT(CAST(AES_DECRYPT(national_id_enc, @enc_key) AS CHAR(11)), 4)) AS national_id_masked
FROM customer_secure;
```

Bu sorgu, kimlik numarasının yalnızca son 4 hanesini gösterir.

## 9. Anahtar yönetimi: güvenliğin kırılma noktası

Makaledeki anahtarlar eğitim amaçlıdır.  
Canlı sistemlerde aşağıdaki kurallar zorunlu kabul edilmelidir:

- Anahtar kod içine sabit yazılmaz.
- Anahtar düz metin dosyalarda tutulmaz.
- KMS/HSM gibi güvenli anahtar yönetim servisleri tercih edilir (`KMS`: anahtarları merkezi ve kontrollü yöneten servis; `HSM`: anahtarları fiziksel olarak koruyan özel güvenlik cihazı).
- Anahtarlar düzenli aralıklarla döndürülür (rotation).

## 10. Sonuç

Veritabanı güvenliği için temel karar şudur:

- Parola saklama -> Hash
- Geri okunacak hassas veri -> Şifreleme
- Değişiklik doğrulama -> HMAC / bütünlük kontrolü

Şifreleme tek başına sihirli çözüm değildir.  
Doğru sonuç; doğru teknik, doğru anahtar yönetimi ve doğru operasyon disiplini birlikte kurulduğunda elde edilir.
