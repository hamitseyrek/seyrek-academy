# Gömülü Sistemlere Giriş: Kavramlar, Örnekler ve Tasarım Çerçevesi

**Gömülü sistemler; belirli bir göreve odaklanmış, genellikle sınırlı kaynaklara sahip, donanım ve yazılımın tek bir bütün olarak tasarlandığı sistemlerdir. Bu metin, günlük hayattaki örneklerden başlayarak gömülü sistem kavramını, tipik mimariyi, temel tasarım kısıtlarını ve ders/seri boyunca kullanılacak terminolojiyi özetler.**

---

## Bu yazıda neler var?

- Gömülü sistem tanımı ve günlük hayattaki örnekler  
- Mikrodenetleyici tabanlı sistemler ile genel amaçlı bilgisayarlar arasındaki farklar  
- Tipik gömülü sistem mimarisi (sensör → işlem → çıkış)  
- Kaynak kısıtları: bellek, işlem gücü, enerji  
- Gerçek zamanlılık ve güvenilirlik kavramları  
- Uygulama alanları: otomotiv, endüstriyel kontrol, IoT, robotik  
- Devam eden notlarda izlenecek teknik eksen  

---

## 1. Gömülü Sistem Nedir?

Özet tanım:

- **Belirli bir göreve** (veya dar bir görev kümesine) odaklıdır.  
- Genellikle **tek bir cihazın içinde** görünür (beyaz eşya, otomotiv ECU, tıbbi cihaz vb.).  
- Donanım (kart, sensörler, aktüatörler) ve yazılım birlikte tasarlanır.  
- Çoğu zaman kullanıcı tarafından “bilgisayar” olarak algılanmaz.  

Gündelik örnekler:

- Çamaşır makinesi, bulaşık makinesi kontrol kartları  
- Asansör kumanda panosu  
- Araçlardaki motor kontrol ünitesi, airbag modülü, ABS/ESP sistemleri  
- Klima, kombi, akıllı termostatlar  
- POS cihazları, yazarkasalar  
- Akıllı kilit, kartlı geçiş sistemleri  
- Basit robot platformları, çizgi izleyen veya engelden kaçan robotlar  

Bu tür sistemlerin ortak özelliği, **sürekli çalışan**, dış dünyadan veri alan ve buna göre karar verip çıkış üreten bir döngü mantığına sahip olmalarıdır.

---

## 2. Gömülü Sistem ile Genel Amaçlı Bilgisayar Arasındaki Farklar

Aşağıdaki tablo, tipik bir masaüstü/laptop bilgisayar ile gömülü sistem arasındaki temel farkları özetler:

| Özellik              | Genel Amaçlı Bilgisayar        | Gömülü Sistem                              |
|----------------------|---------------------------------|--------------------------------------------|
| Amaç                 | Çok amaçlı (ofis, oyun, web…)  | Belirli görev(ler)                         |
| Kullanıcı Arayüzü    | Klavye, fare, tam ekran        | Sınırlı tuş, LED, küçük ekran vb.         |
| Kaynaklar            | Görece bol CPU, RAM, disk      | Sınırlı CPU, RAM, Flash                    |
| Güç Tüketimi         | Genelde şebeke elektriği       | Sıkça batarya veya düşük güç bütçesi       |
| İşletim Sistemi      | Windows, Linux, macOS vb.      | Basit döngü, RTOS veya gömülü OS           |
| Güncelleme Sıklığı   | Sık uygulama/OS güncellemeleri | Göreceli olarak seyrek, kontrollü güncellemeler |

Bu farklar, tasarım sırasında öncelikleri de değiştirir:

- Masaüstü tarafta esneklik ve kullanıcı deneyimi öne çıkarken,  
- Gömülü tarafta **güvenilirlik, zamanlama ve enerji kullanımı** kritik hale gelir.  

---

## 3. Tipik Gömülü Sistem Mimarisi

Birçok gömülü sistem, kabaca aşağıdaki zincire indirgenebilir:

```text
Gerçek Dünya → Sensörler → İşlem Birimi (Mikrodenetleyici) → Çıkış Elemanları → Gerçek Dünya
```

Temel bileşenler:

- **Sensörler**: Sıcaklık, basınç, mesafe, ivme, ışık, ses, manyetik alan vb.  
- **İşlem Birimi**: Mikrodenetleyici veya gömülü işlemci (CPU + bellek + çevre birimleri).  
- **Aktüatörler / Çıkışlar**: Motor, servo, röle, LED, buzzer, ekran vb.  
- **Haberleşme**: UART, I²C, SPI, CAN, Ethernet, kablosuz protokoller (Wi-Fi, BLE, LoRa vb.).  

Bu mimaride, donanım ve yazılım birlikte tasarlanır; hangi sensörün nasıl okunacağı, verinin nasıl işleneceği ve hangi sürede hangi çıkışın verileceği baştan planlanır.

---

## 4. Kaynak Kısıtları: Bellek, İşlem Gücü, Enerji

Gömülü sistem tasarımında sık karşılaşılan kısıtlar:

- **Bellek**  
  - RAM ve Flash kapasitesi düşüktür.  
  - Veri yapıları, buffer boyutları ve loglama stratejileri bu kısıt düşünülerek seçilir.  
- **İşlem Gücü**  
  - Saat frekansı (clock) görece düşüktür.  
  - Ağır algoritmalar (örneğin büyük yapay zeka modelleri) doğrudan gömülü işlemci üzerinde çalıştırılamayabilir.  
- **Enerji**  
  - Batarya ile çalışan sistemlerde her sensör okuma, her haberleşme paketi ve her hesaplama adımı enerji bütçesini etkiler.  
  - “Energy-aware” tasarım, pil ömrü veya görev süresi için belirleyicidir.  

Bu kısıtlar, ders notlarında ileride geçecek **ADC okuma frekansı, PWM kullanım şekli, haberleşme sıklığı, uyku modları** gibi kavramların arka planını oluşturur.

---

## 5. Gerçek Zamanlılık ve Güvenilirlik

Birçok gömülü sistemde yalnızca doğru sonuç üretmek değil, **doğru sonucu doğru zamanda** üretmek önemlidir.

Örnekler:

- Araç hava yastığı (airbag) sistemi: milisaniye seviyesinde karar vermek zorundadır.  
- Tıbbi cihazlar: belirli süre aralıkları içinde ölçüm ve müdahale yapar.  
- Motor kontrolü, endüstriyel otomasyon: belirli periyotlarda sensör okuma ve çıkış güncelleme gerektirir.  

Bu çerçevede:

- **Gerçek zamanlı sistem (real-time)** kavramı ortaya çıkar.  
- Bazı tasarımlarda basit bir `while(1)` döngüsü yeterliyken, bazılarında **gerçek zamanlı işletim sistemi (RTOS)** kullanılır.  
- Güvenilirlik açısından, hata durumlarında sistemin “güvenli duruma” geçmesi (fail-safe) kritik kabul edilir.  

---

## 6. Uygulama Alanları

Gömülü sistemler birçok sektörde yer alır:

- **Otomotiv**: Motor kontrol, fren sistemleri, sürücü destek sistemleri (ADAS), bilgi-eğlence.  
- **Endüstriyel Otomasyon**: PLC tabanlı kontrol sistemleri, robot kolları, üretim hatları.  
- **Tüketici Elektroniği**: Akıllı saatler, televizyonlar, medya oynatıcılar.  
- **Sağlık**: Tıbbi monitörler, taşınabilir ölçüm cihazları, implant cihazlar.  
- **IoT ve Akıllı Ev**: Sensör düğümleri, akıllı prizler, enerji izleme sistemleri.  
- **Robotik**: Mobil robotlar, insansız hava/deniz/kara araçları, sürü robotik sistemler.  

Bu alanlar, ders kapsamındaki örnek ve projelerin seçilmesinde referans noktası olarak kullanılabilir.

---

## 7. Yazı Serisinin Konumlandırılması

Bu giriş notu sonrasında, seri boyunca aşağıdaki teknik eksen izlenecektir:

- **Temel elektronik ve devreler** (voltaj, akım, direnç, güç, seri/paralel yapılar, breadboard kullanımı).  
- **Analog ve dijital sinyaller, ADC/DAC ve mantık kapıları**.  
- **Mikrodenetleyici ve Arduino’ya giriş**, program yapısı, temel veri tipleri, I/O kullanımı.  
- **Arduino ile uygulamalar**, sensör ve aktüatör örnekleri, basit proje taslakları.  
- İlerleyen notlarda isteğe bağlı olarak: gerçek zamanlılık, haberleşme protokolleri, enerji odaklı tasarım ve robotik uygulama senaryoları.  

Her bir başlık, ayrı bir dosyada ayrıntılandırılacak; bu giriş metni ise kullanılan kavramların çerçevesini ve gömülü sistem bakış açısını özetleyen üst seviye referans olarak konumlandırılacaktır.

