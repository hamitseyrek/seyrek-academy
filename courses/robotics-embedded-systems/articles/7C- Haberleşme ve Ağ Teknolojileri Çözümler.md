# 7C – Haberleşme ve Ağ Teknolojileri: Çözümler ve Açıklamalar

Bu dosya, `7S- Haberleşme ve Ağ Teknolojileri Sorular.md` içinde yer alan **S1–S16** numaralı sorular için özet çözümler içerir.

---

## S1 – UART baud uyuşmazlığı

- Farklı baud rate, bit sürelerini farklılaştırır; alıcı bit sınırlarını yanlış örnekler ve karakterler bozulur.
- Doğrulama adımları:
  1. Her iki uçta baud rate, parity ve stop bit ayarlarını aynı yapma
  2. `TX-RX` çapraz bağlantısı ve ortak `GND` kontrolü
  3. Sabit test paketi gönderip tekrar üretilebilir hata gözlemi

---

## S2 – UART çerçeve alanları

- `[0xAA][LEN][CMD][DATA...][CRC8]` içinde:
  - `0xAA`: başlangıç imzası
  - `LEN`: payload uzunluğu
  - `CMD`: komut tipi
  - `DATA`: komut verisi
  - `CRC8`: bozulma kontrolü
- `LEN`, parser’ın doğru byte sayısını okumasını sağlar.
- `CRC8`, paket bozulmasını yakalayarak yanlış veriyle işlem yapılmasını engeller.

---

## S3 – Serial Monitor ile doğrulama

- `Serial.print(...)` ile şu çıktılar takip edilir:
  - Ham sensör değeri (`adc=742`)
  - Karar çıktısı (`state=BALANCE_ON`)
  - Hata/uyarı kodu (`err=I2C_TIMEOUT`)
- Koşul tetikleme anları zaman damgasıyla yazdırılırsa mantık hatası daha hızlı bulunur.

---

## S4 – SPI okuma akışı

- `CS` aktif edilerek hedef slave seçilir.
- `SCLK` darbeleri ile bit zamanlaması belirlenir.
- Komut/adres `MOSI` üzerinden gider.
- Cevap verisi `MISO` üzerinden geri gelir.
- `CS` pasif olduğunda işlem sınırı kapanır ve paket/işlem biter.

---

## S5 – SPI hız/pin dengesi

- Avantaj: Yüksek veri hızı ve deterministik zamanlama.
- Dezavantaj: Her slave için ayrı `CS` gerektiğinden pin maliyeti artar.
- Tasarımda, hız gereksinimi ile pin bütçesi birlikte değerlendirilmelidir.

---

## S6 – I2C adresleme ve ACK/NACK

- `SDA` veri hattı, `SCL` saat hattıdır.
- `ADDRESS + R/W` ile hedef cihaz ve yön seçilir.
- `ACK`, byte’ın alındığını doğrular; `NACK` iletişimin sonlandığını veya reddi gösterir.
- Bu yapı, yanlış adrese yazma/okuma riskini azaltır.

---

## S7 – Pull-up ve open-drain mantığı

- I2C open-drain yapıda olduğundan cihazlar hattı yalnızca lojik 0’a çekebilir.
- Hattın tekrar lojik 1’e dönmesi için `pull-up` direnç gerekir.
- Pull-up olmazsa hat “boşta” kararsız kalır ve iletişim güvenilir çalışmaz.

---

## S8 – Bus kapasitansı etkisi

- Kapasitans arttıkça sinyal kenarları yavaşlar, yüksek hızda bit hatası artar.
- Kablo uzadıkça parazit ve zayıflama etkisi büyür.
- Önlemler:
  1. Daha kısa/temiz kablolama
  2. Uygun pull-up değeri seçimi
  3. Gerekirse bus frekansını düşürme

---

## S9 – Protokol eşleştirme

- Hızlı debug -> `UART` (terminalde hızlı gözlem)
- Yüksek hızlı kart içi veri -> `SPI` (senkron, yüksek throughput)
- Çoklu sensör + az pin -> `I2C` (adresli çoklu cihaz)

---

## S10 – Denge robotunda karma protokol

- IMU verisi için `I2C`: çoklu sensör ve pin verimi.
- Motor sürücü ayarı için `SPI`: daha hızlı ve deterministik aktarım.
- Hata loglama için `UART`: debug/teşhis kolaylığı.
- Tek protokole zorlamak performans, pin ve bakım maliyetini olumsuz etkiler.

---

## S11 – Fiziksel hata semptomları

- Ortak GND eksikliğinde rastgele karakter/parazit veri görülebilir.
- 5V-3.3V uyumsuzluğunda veri hatası veya donanım hasarı oluşabilir.
- Gürültüde CRC hataları, paket kaybı ve aralıklı kopmalar artar.

---

## S12 – Timeout/Retry/Güvenli durum

- `timeout`: yanıt gelmezse işlemi sonlandırır.
- `retry`: sınırlı sayıda tekrar dener.
- Hâlâ başarısızsa güvenli moda geçilir (ör. motor durdurma).
- Yanlış kurguda aşırı retry, ağ yükü ve kilitlenme benzeri davranış üretir.

---

## S13 – Bluetooth çerçeve güvenliği

- `<STX><CMD><SEP><VALUE><ETX><CRC>` ile başlangıç/bitiş sınırı nettir.
- `CMD` ve `VALUE` ayrımı parser’ı güvenilir yapar.
- `CRC` bozuk komutun uygulanmasını engeller.
- Tek karakter komutlara göre yanlış tetiklenme riski düşer.

---

## S14 – RF ham taşıma yaklaşımı

- RF modülde çoğu zaman yalnız taşıma vardır; üst mesaj kuralını uygulama tanımlar.
- Örnek: Garaj kumandasında kod paketi gönderilir, alıcı eşleşirse röle tetiklenir.
- Bu nedenle çerçeveleme, doğrulama ve güvenlik alanları ayrıca tasarlanmalıdır.

---

## S15 – HTTP ve MQTT mesaj farkı

- HTTP: İstek-cevap ve header tabanlı yapı; yönetim/konfigürasyon çağrılarında uygundur.
- MQTT: Topic + payload + QoS; sık telemetri ve çoklu tüketicide daha verimlidir.
- Tipik eşleşme: telemetri -> MQTT, yönetim komutu/REST entegrasyonu -> HTTP.

---

## S16 – Katmanlı test sırası

- Önerilen sıra:
  1. Kart içi haberleşme (`UART/SPI/I2C`) ve cihaz sürüş testleri
  2. Kablosuz katman (`WiFi/Bluetooth/RF`) bağlantı dayanıklılığı
  3. IoT servisleri (`HTTP/MQTT`) ve uçtan uca entegrasyon
- Tüm katmanları aynı anda debug etmenin sorunu:
  - Hatanın kaynağı izole edilemez
  - Tanı süresi uzar
  - Geçici çözümler kalıcı mimari hataya dönüşebilir
