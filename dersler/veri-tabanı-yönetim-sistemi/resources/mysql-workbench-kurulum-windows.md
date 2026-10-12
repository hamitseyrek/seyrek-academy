# Windows'ta MySQL ve MySQL Workbench Kurulum Rehberi

Bu rehber, Windows ortamında MySQL Server ve MySQL Workbench kurulumunu sıfırdan tamamlamak için hazırlanmıştır. Adımlar, başlangıç seviyesinde bir kurulum akışıyla ilerler.

---

## 1) MySQL'i indir ve kur

1. Resmi indirme sayfasını aç:
  [https://dev.mysql.com/downloads/mysql/](https://dev.mysql.com/downloads/mysql/)
2. İşletim sistemine uygun **Windows MSI Installer (64-bit / 32-bit)** paketini seçip indir.
3. Giriş ekranı çıkarsa **No thanks, just start my download** seçeneğini kullan.
4. İndirilen `.msi` dosyasını çalıştır ve yönetici onayını ver.
5. Kurulum türünde **Developer Default** seç.
  Bu seçenek, MySQL Server ve MySQL Workbench bileşenlerini birlikte kurar.
6. `Next` ile devam et, gerekli yerlerde varsayılan ayarları kabul et.
7. **Accounts and Roles** adımında `root` kullanıcı şifresini belirle ve güvenli bir yere not et.
8. **Apply Configuration -> Execute -> Finish** sırasıyla kurulum adımını tamamla.

---

## 2) Sunucunun çalıştığını kontrol et

1. Windows arama alanına **Hizmetler** yazıp uygulamayı aç.
2. Listede `MySQL80` (veya `MySQL`) servisini bul.
3. Durum alanının **Çalışıyor** olduğundan emin ol.
4. Çalışmıyorsa sağ tık yapıp **Başlat** seçeneğini kullan.

---

## 3) MySQL Workbench kurulumu

- Başlat menüsünden **MySQL Workbench** uygulamasını açmayı dene.
- Kurulu değilse resmi sayfadan indir:  
[https://dev.mysql.com/downloads/workbench/](https://dev.mysql.com/downloads/workbench/)
- Windows için MSI dosyasını indirip standart kurulum adımlarını tamamla.

---

## 4) İlk bağlantıyı oluştur

1. MySQL Workbench'i aç.
2. **MySQL Connections** altında **Local instance MySQL80** bağlantısına tıkla.
3. Şifre ekranında kurulum sırasında belirlenen `root` şifresini gir.
4. Bağlantı başarılıysa:
  - solda **SCHEMAS** paneli,
  - ortada SQL sorgu editörü görünür.

### Yeni bağlantı ekleme (isteğe bağlı)

1. `+` (Add Connection) butonuna tıkla.
2. Aşağıdaki alanları doldur:
  - **Connection Name:** `Yerel MySQL`
  - **Hostname:** `localhost`
  - **Port:** `3306`
  - **Username:** `root`
  - **Password:** root şifren
3. **Store in Vault -> OK** ile bağlantıyı kaydet.

---

## 5) Örnek veritabanı içe aktarma (isteğe bağlı)

1. Workbench menüsünden **Server -> Data Import** ekranını aç.
2. **Import from Self-Contained File** seçeneğini işaretle.
3. Bir `.sql` dosyası seç (ör. `sakila` veya `world`).
4. Gerekli dosyalar için resmi kaynak:
  [https://dev.mysql.com/doc/index-other.html](https://dev.mysql.com/doc/index-other.html)
5. **Default Target Schema -> New** ile hedef şema adını gir (`sakila` / `world`).
6. **Start Import** ile içe aktarmayı başlat.

---

## Sorun giderme

- **Bağlanamıyorum:** `root` şifresini yeniden kontrol et ve `MySQL80` servisinin çalıştığını doğrula.
- **Servis başlamıyor:** Bilgisayarı yeniden başlat; sorun sürerse MySQL'i kaldırıp temiz kurulum yap.
- **Şifre unutuldu:** En hızlı yol, yeniden kurulum yapıp yeni bir `root` şifresi belirlemektir.

---

## Hızlı özet

1. MySQL Installer'ı indir, kur ve `root` şifresini belirle.
2. Windows Hizmetler ekranından MySQL servisinin çalıştığını kontrol et.
3. MySQL Workbench'i aç (gerekirse ayrı indirip kur).
4. `localhost:3306`, `root` ve şifre ile bağlantı kur.
5. İstenirse `sakila/world` gibi örnek veritabanlarını `Data Import` ile yükle.

