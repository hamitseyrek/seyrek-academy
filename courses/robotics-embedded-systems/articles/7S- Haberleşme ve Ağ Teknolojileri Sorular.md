# 7S – Haberleşme ve Ağ Teknolojileri: Sorular

Bu dosya, `7- Haberleşme ve Ağ Teknolojileri.md` içeriğine göre güncellenmiş soru setini içerir. Çözümler `7C- Haberleşme ve Ağ Teknolojileri Çözümler.md` dosyasındadır.

---

## S1 – UART iletişiminde iki cihaz farklı baud rate (`9600` ve `115200`) ile çalışıyorsa bozuk karakter oluşmasının teknik nedeni nedir, nasıl doğrulanır?
- İlk kontrol adımlarını yazın.

## S2 – UART için verilen `[0xAA][LEN][CMD][DATA...][CRC8]` çerçevesinde her alanın görevi nedir?
- `LEN` ve `CRC8` neden kritik kabul edilir?

## S3 – `Serial Monitor` kullanarak bir kontrol algoritmasının doğru çalıştığını nasıl doğrularsınız?
- En az üç örnek izleme çıktısı verin (ör. sensör, koşul sonucu, hata kodu).

## S4 – SPI iletişiminde `CS`, `SCLK`, `MOSI`, `MISO` hatlarının rolünü bir “okuma işlemi” akışıyla açıklayın.
- Neden işlem sınırı `CS` hattıyla belirlenir?

## S5 – Aynı projede bir TFT ekran güncellemesi ve birden fazla çevre birimi varsa SPI seçiminde hangi avantaj ve dezavantaj birlikte değerlendirilmelidir?
- Pin maliyeti ve hız açısından yorumlayın.

## S6 – I2C’de `SDA` ve `SCL` hatlarının görevini ve `7-bit ADDRESS + R/W + ACK/NACK` yapısının iletişim güvenilirliğine katkısını açıklayın.

## S7 – I2C’de pull-up direnci neden zorunludur?
- “Open-drain” yapıyı ve hattın lojik 1’e nasıl döndüğünü kısa teknik dille anlatın.

## S8 – I2C bus kapasitansı ve kablo uzunluğu arttığında ne tür sorunlar oluşur?
- Bu durumda hangi üç tasarım önlemi uygulanabilir?

## S9 – Protokol seçimi için aşağıdaki ihtiyaçları eşleştirin ve gerekçe yazın: hızlı debug, yüksek hızlı kart içi veri, çoklu sensör ve az pin.

## S10 – İki tekerlekli denge robotu senaryosunda IMU, motor sürücü ve hata loglama için neden farklı protokoller seçmek daha doğru bir mühendislik yaklaşımıdır?

## S11 – Haberleşme hatalarında fiziksel nedenler (ortak GND eksikliği, voltaj uyumsuzluğu, gürültü) yazılım tarafında nasıl semptom verir?
- En az üç belirti yazın.

## S12 – Güvenilirlik için `timeout`, `retry` ve “geçersiz pakette güvenli durum” birlikte nasıl kurgulanmalıdır?
- Yanlış kurguda oluşabilecek riskleri de belirtin.

## S13 – Bluetooth seri komut yapısında `<STX><CMD><SEP><VALUE><ETX><CRC>` çerçevesi, tek karakter komutlara göre neden daha güvenlidir?

## S14 – RF iletişimin “ham taşıma” yaklaşımı ne demektir?
- Garaj kumandası, kablosuz zil veya uzaktan tetikleme örneklerinden biriyle açıklayın.

## S15 – HTTP ve MQTT seçiminde mesaj yapısı açısından temel fark nedir?
- Sık telemetri ve yönetim komutu senaryoları için uygun eşleşme yapın.

## S16 – Katmanlı bir sistemde (`UART/SPI/I2C` + kablosuz + IoT servisleri) test sırası nasıl olmalıdır ve neden?

