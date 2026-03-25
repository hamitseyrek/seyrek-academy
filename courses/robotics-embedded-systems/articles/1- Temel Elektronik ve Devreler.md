# Temel Elektronik ve Devreler

**Bu metin, voltaj–akım–direnç ilişkisini, temel devre davranışını ve basit devre bileşenlerini özetleyen, ileride kullanılacak uygulamalara zemin oluşturacak bir referans notudur. Günlük hayat benzetmeleri ve basit devre örnekleri üzerinden, formülleri ezberlemekten çok kavramsal çerçeveyi netleştirmeyi amaçlar.**

---

## İçerik başlıkları

- Elektrik ve elektronik ayrımı, temel kavramlar  
- Voltaj, akım, direnç ve güç arasındaki ilişkiler  
- Ohm Kanunu ve pratik devre hesapları  
- Temel elektronik bileşenler ve devre örnekleri  
- Seri–paralel devreler, LED ve direnç seçimi  
- Breadboard mantığı ve bağlantı yapısı  
- Multimetre ile temel ölçümler  
- Temel bilgilerin devre tasarımı ve koruma açısından önemi  

---

## 1. Elektrik mi, Elektronik mi?

Günlük dilde çoğu zaman birbirine karışan iki terim:

- **Elektrik**: Enerjinin iletimi ve güç tarafı (priz, hatlar, sigorta, kablo kesiti vb.)  
- **Elektronik**: Sinyallerin işlenmesi, kontrol ve karar verme devreleri (kartlar, sensörler, mikrodenetleyiciler)  

Gömülü sistemler, bu iki alanın **kesişiminde** yer alır:

- Bir yanda güç kaynağı, kablolama, güvenli besleme (elektrik tarafı)  
- Diğer yanda sensörler, mikrodenetleyici, yazılım (elektronik ve bilgisayar tarafı)  

---

## 2. Voltaj, Akım, Direnç: Su Borusu Benzetmesi

Elektriksel büyüklükler soyut görünebilir; bu nedenle çoğu zaman **su borusu** benzetmesi kullanılır.

- **Voltaj (V)** → Su deposunun yüksekliği / basınç  
- **Akım (I)** → Borudan geçen su miktarı (debi)  
- **Direnç (R)** → Borunun dar olması, içindeki engeller  

Su depolu benzetme:

- Depo ne kadar yüksekteyse → basınç (voltaj) o kadar fazla  
- Boru ne kadar genişse → daha çok su akar (akım artar)  
- Boru ne kadar dar / tıkalıysa → akış zorlaşır (direnç artar, akım azalır)  

Elektrik tarafında:

- Pil / güç kaynağı → voltaj kaynağı  
- Tel / devre elemanları → akımın aktığı yol  
- Direnç, lamba, LED vb. → akımı sınırlayan/enerjiyi “tüketen” elemanlar  

Bu üç kavram arasındaki temel ilişkiyi **Ohm Kanunu** toparlar.

---

## 3. Ohm Kanunu: V = I × R

Ohm Kanunu’nu tahtaya genelde şu şekilde yazarız:

```text
V = I × R

V: Voltaj (Volt)
I: Akım (Amper)
R: Direnç (Ohm, Ω)
```

Buradan üç pratik soru türetmek işimizi kolaylaştırır:

- Voltaj ve direnç biliniyorsa → **akım**: `I = V / R`  
- Voltaj ve akım biliniyorsa → **direnç**: `R = V / I`  
- Akım ve direnç biliniyorsa → **voltaj**: `V = I × R`  

### 3.1. Neden önemli?

- LED yakarken yanlış direnç seçerseniz, **akım fazla** olur; LED’i yakabilirsiniz.  
- Mikrodenetleyici pinlerinin çoğu **maksimum 20 mA** civarında akım kaldırır; üzerindeki yükü hesaplarken Ohm Kanunu olmadan ilerlemek risklidir.  
- Güç hesabı (`P = V × I`) ile birleştiğinde, bir bileşenin ne kadar ısınacağını, kablonun ne kadar akım taşıyabileceğini öngörebilirsiniz.  

### 3.2. Örnekler – LED Devresi ve Direnç Seçimi

**Örnek 1 – 5V ile LED:**

- Besleme: 5V  
- LED ileri gerilim düşümü: yaklaşık 2V  
- Hedef akım: 20 mA = 0.02 A  

Direnç üzerinde düşecek gerilim:

```text
V_R = 5V − 2V = 3V
R = V_R / I = 3V / 0.02A = 150 Ω
```

Uygulamada, 150Ω yerine 180Ω veya 220Ω gibi yaygın standart değerler tercih edilir; akım bir miktar düşer, LED daha güvenli aralıkta çalışır.

**Örnek 2 – 9V pil ile LED:**

- Besleme: 9V  
- LED ileri gerilim düşümü: yaklaşık 2V  
- Hedef akım: 20 mA  

```text
V_R = 9V − 2V = 7V
R = V_R / I = 7V / 0.02A = 350 Ω
```

Standart değerlere yuvarlandığında 330Ω veya 390Ω kullanılabilir; daha büyük değer (390Ω) seçildiğinde akım biraz azalır, LED daha soğuk çalışır.

### 3.3. Güç (P = V × I) ve Bileşen Yükü

Güç hesabı, bir bileşen üzerinde ne kadar enerji harcandığını ve dolayısıyla ne kadar ısınabileceğini anlamak için kullanılır:

```text
P = V × I

P: Güç (Watt)
V: Voltaj (Volt)
I: Akım (Amper)
```

Örnek:

- 5V ile beslenen ve 20 mA akım çeken bir LED devresinde:

```text
P = 5V × 0.02A = 0.1W
```

Bu değer, çoğu küçük LED ve direnç için kabul edilebilirdir; ancak güç yükseldikçe bileşen seçiminde (özellikle dirençlerin Watt değeri) dikkat gereklidir.

**Örnek 3 – Direncin Gücünü Kontrol Etmek:**

12V’luk bir hatta 1kΩ direnç üzerinden akacak akım:

```text
I = V / R = 12V / 1000Ω = 0.012 A = 12 mA
P = V × I = 12V × 0.012A = 0.144 W
```

Teorik olarak 0.25W’lık (¼ Watt) bir direnç yeterlidir; ancak ortam sıcaklığı, toleranslar ve sürekli çalışma koşulları düşünülerek 0.5W’lık direnç seçmek daha güvenli olabilir.

---

## 4. Temel Elektronik Bileşenler

Bu bölüm, ayrıntılı ders planındaki bileşen tanımlarını özetleyerek temel karakteristikleri bir araya toplar.

### 4.1. Direnç (Resistor)

- Görevi: Akımı sınırlamak, gerilim bölmek, bazı devrelerde referans oluşturmak.  
- Sembol: Şemada genellikle zikzak veya dikdörtgen ile gösterilir.  
- Birim: Ohm (Ω).  
- Pratik: LED devrelerinde akımı kontrol etmek için seri direnç kullanılır.

**Renk kodu hatırlatması** (4 bantlı tipler için kısaca):

- İlk iki bant: Sayı hanesi  
- Üçüncü bant: Çarpan  
- Dördüncü bant: Tolerans  

Sık kullanılan renk–sayı eşleştirmesi:

```text
Siyah      = 0
Kahverengi = 1
Kırmızı    = 2
Turuncu    = 3
Sarı       = 4
Yeşil      = 5
Mavi       = 6
Mor        = 7
Gri        = 8
Beyaz      = 9
```

Örnekler:

- Kahverengi (1), siyah (0), kırmızı (×100) → 10 × 100 = 1000Ω = 1kΩ.  
- Kırmızı (2), mor (7), kahverengi (×10) → 27 × 10 = 270Ω.  

### 4.2. Kondansatör (Kapasitör)

- Görevi: Enerji depolamak, filtrelemek, gürültü azaltmak, zaman sabiti oluşturmak.  
- Türler: Elektrolitik (kutuplu), seramik (çoğunlukla kutupsuz).  
- Birim: Farad (F); pratikte µF, nF, pF seviyeleri.  

Gömülü devrelerde tipik kullanım alanları:

- Besleme hattı üzerinde **by-pass/decoupling kondansatörleri** (gürültü azaltma).  
- Zamanlayıcı devreler (RC zaman sabiti).  

### 4.3. Diyot ve LED

- Diyot: Akımın yalnızca bir yönde akmasına izin veren eleman.  
- LED (Light Emitting Diode): Işık yayan diyot türü.  
- Temel özellik: İleri yönde belirli bir gerilim düşümü (ör. kırmızı LED için ~1.8–2V).  

LED devrelerinde:

- Seri direnç olmadan doğrudan besleme hattına bağlanmamalıdır.  
- İleri gerilim ve istenen akım, bölüm 3.2’deki hesaplara göre seçilir.

### 4.4. Transistör (Kısaca)

Detaylarına ilerleyen notlarda daha fazla girilmek üzere, kısa çerçeve:

- Anahtar veya yükselteç olarak kullanılabilir.  
- Tipik türler: NPN/PNP BJT, N-kanal/P-kanal MOSFET.  
- Gömülü sistemlerde, mikrodenetleyici pinlerinin doğrudan süremeyeceği yükleri (motor, yüksek akımlı LED şeritleri vb.) kontrol etmek için kullanılır.

---

## 5. Seri ve Paralel Devreler: Akım ve Voltaj Dağılımı

Devrede elemanları **art arda** mı, yoksa **yan yana** mı bağladığınız, akım ve voltajın nasıl dağıldığını belirler.

### 5.1. Seri Bağlantı

- Aynı akım tüm elemanlardan **sırayla** geçer.  
- Toplam direnç, dirençlerin toplamına eşittir:  

```text
R_toplam = R1 + R2 + R3 + ...
```

Sonuç:

- Toplam direnç arttıkça, devreden geçen akım azalır.  

Kısa uygulama senaryosu:

- 5V kaynağa seri olarak iki adet 1kΩ direnç bağlandığında, toplam direnç 2kΩ olur:  

```text
I = V / R_toplam = 5V / 2000Ω = 0.0025A = 2.5 mA
```

Eşit dirençlerde gerilim düşümleri de eşittir; her bir direnç üzerinde yaklaşık 2.5V görülür.

### 5.2. Paralel Bağlantı

- Tüm kollarda **aynı voltaj** vardır.  
- Akım, kollar arasında bölünür.  
- İki direnç için sadeleştirilmiş formül:

```text
1 / R_toplam = 1 / R1 + 1 / R2
```

Sezgisel olarak:

- Paralel bağladıkça, sistem daha “geniş boru”ya benzer; toplam direnç düşer, çekilebilecek akım artar.  

Basit örnek:

- 5V kaynağa paralel olarak iki adet 1kΩ direnç bağlandığında:

```text
1 / R_toplam = 1 / 1000 + 1 / 1000 = 2 / 1000
R_toplam = 500 Ω
I = V / R_toplam = 5V / 500Ω = 0.01A = 10 mA
```

Her koldan 5 mA akar; toplam akım 10 mA’dir.

---

---

## 6. Breadboard Mantığı: Şemadan Gerçek Devreye

Teoride çizilen devre şemasını, pratikte en hızlı kurulan ortam genellikle **breadboard**’dur.  
Sık karşılaşılan sorunlardan biri, breadboard iç bağlantıları bilinmeden devre kurulmasıdır.

Kısa hatırlatma:

- Uzun yatay şeritler (genellikle + ve − ile işaretli) → **besleme rayları**  
- Ortadaki delikler, iki blok halinde dikey veya yatay gruplar şeklinde bağlıdır (modeline göre değişir).  
- Çoğunlukla:
  - Orta bölgede 5’li dikey gruplar,  
  - Ortada bir “boşluk” (entegreleri oturtmak için),  
  - Yanlarda besleme rayları bulunur.  

Pratik açıdan:

- Kağıt üzerinde küçük bir breadboard şeması çizip, hangi deliklerin kendi içinde bağlı olduğunu işaretlemek, devre kurulumunda yaşanan karışıklığı azaltır.  
- Devre şemasındaki her düğümün (node) breadboard üzerinde aynı grup içine alınması, bağlantıların kontrolünü kolaylaştırır.  

### 6.1. Tipik İlk Devre: LED Yakma

Basit bir breadboard kurulumu örneği:

- 5V ve GND hatları, breadboard’un besleme raylarına taşınır.  
- Bir LED’in anot ucu (uzun bacak) bir satıra, katot ucu (kısa bacak) komşu satıra yerleştirilir.  
- Anot tarafındaki satıra, 220Ω–330Ω aralığında bir direnç seri bağlanır ve direncin diğer ucu 5V rayına bağlanır.  
- Katot tarafındaki satır, GND rayına bağlanır.

Bu yapı, en temel seri devreyi somutlaştırır:

```text
5V → Direnç → LED → GND
```

Direnç değeri çok düşük seçilirse akım artar ve LED zarar görebilir; çok büyük seçilirse LED sönük görünür. Bu nedenle direnç seçimi, bölüm 3’teki hesaplarla birlikte düşünülmelidir.

---

---

## 7. Multimetre ile Ölçüm: Voltaj, Akım, Direnç

Multimetre, elektronikçinin “stetoskopu” gibidir; devrede ne olup bittiğini anlamanın en pratik yolu.

Temel üç mod:

- **Voltmetre (V)** – İki nokta arasındaki **potansiyel farkı** ölçer.  
- **Ampermetre (A)** – Üzerinden geçen **akımı** ölçer (devreye seri bağlanır, bu yüzden dikkatli olunmalıdır).  
- **Ohmmetre (Ω)** – Direnç ölçer (devre enerjisizken kullanılmalı).  

Pratik uyarılar:

- Akım ölçümlerinde prob konumu ve bağlantı şeması dikkatle kontrol edilmelidir; yanlış bağlantı kısa devreye yol açabilir.  
- Direnç ölçümleri, devre enerjisizken ve ilgili eleman devreden izole edilmişken daha doğru sonuç verir.  
- Voltaj ölçümlerinde, referans noktasının genellikle **GND** olduğu varsayılır; farklı referans noktaları ölçüm sonuçlarını değiştirir.  

---

---

## 8. Neden Temel Elektronik Bilgisi Gerekli?

- Gömülü sistemler, **donanım ve yazılımın birlikte çalıştığı** sistemlerdir; yazılım hatasız olsa bile yanlış beslenen, hatalı topraklanmış veya uygun direnç seçilmemiş bir devre kararsız çalışabilir.  
- Sensör çıkışlarının ve besleme hatlarının doğru yorumlanması, referans voltajları ve bağlantı topolojisinin doğru kurulmasına bağlıdır.  
- Mikrodenetleyici pinlerinin akım ve gerilim sınırlarına uyulması, LED, motor gibi elemanların zarar görmemesi için bu temel ilişkilerin doğru uygulanması zorunludur.  

Bu not, ayrıntılı ders planındaki ilk haftanın teorik omurgasını daha kısa ve yoğun bir yapıda toplar; sonraki notlarda analog–dijital sinyaller, ADC/DAC ve mikrodenetleyici temelleriyle birlikte kullanılmak üzere referans olarak tasarlanmıştır.

---

## 9. Kavram Soruları ve Uygulama Problemleri

Bu bölümdeki sorular, metindeki kavramların gerçekten yerleşip yerleşmediğini görmek için hazırlanmıştır. Her soru, ilgili bölüm numarasıyla birlikte anılır; ayrıntılı çözümler ve örnek hesaplamalar `1C- Temel Elektronik ve Devreler Çözümler.md` dosyasındadır.

### 9.1. Temel Kavram Soruları (S1–S5)

**S1 – Elektrik / Elektronik Ayrımı**  
1.1) Bir evdeki şu elemanları “daha çok elektrik tarafı” veya “daha çok elektronik tarafı” diye sınıflandırın:  
- Sigorta kutusu  
- LED ampul (iç devresiyle birlikte)  
- Modem  
- Priz uzatma kablosu  
- Çamaşır makinesi kontrol kartı  

1.2) Kendi cümlelerinizle elektrik ve elektronik arasındaki farkı birer paragrafla özetleyin.

**S2 – Su Benzetmesi**  
2.1) Su deposu–boru benzetmesinde aşağıdaki değişiklikler neyi temsil eder?  
- Deponun yüksekliğini artırmak  
- Boruyu daraltmak  
- Boruyu genişletmek  
2.2) “Yüksek voltaj, yüksek akım demektir.” cümlesi hangi durumlarda yanıltıcı olabilir? Kısa bir açıklama yazın.

**S3 – Birim ve Büyüklükler**  
3.1) Aşağıdaki değerleri temel birimlerine çevirin:  
- 220 mA  
- 4.7 kΩ  
- 10 µF  
3.2) Günlük hayattan en az üç farklı voltaj örneği yazın (örneğin pil, USB, priz vb.) ve yanlarına yaklaşık değerlerini not edin.

**S4 – Ohm Kanunu Yorum Soruları**  
4.1) Bir devrede voltaj sabit, direnç iki katına çıkarılırsa akım ne olur?  
4.2) Aynı devrede direnç sabit, voltaj iki katına çıkarılırsa akım ne olur?  
4.3) Sadece Ohm Kanunu’nu kullanarak “İnce uzun kablonun direnci neden kalın kısa kablodan daha fazladır?” sorusuna sezgisel bir yanıt verin.

**S5 – Güç ve Isınma**  
5.1) Aynı akımı çeken iki dirençten biri 0.25W, diğeri 2W olarak seçilmiştir. Hangisinin daha az ısınması beklenir, neden?  
5.2) Gömülü bir kart üzerindeki regülatörün neden ısınıyor olabileceğine dair üç olası sebep yazın.

### 9.2. Hesaplamalı Ohm Kanunu Problemleri (S6–S10)

**S6 – Temel Direnç Hesabı**  
6.1) 5V ile çalışan bir devrede, 1.8V’luk bir LED’ten 15 mA akmasını istiyorsunuz. Gerekli seri direnç değeri nedir?  
6.2) Aynı devrede hazırda 220Ω bir direnç bulunduğunu varsayın. Tahmini akımı hesaplayın.

**S7 – LED Dizisi ile Güç Analizi**  
Bir panoda 10 adet LED, her biri için ayrı 1kΩ dirençle 12V kaynağa bağlanmıştır.

- 7.1) Her bir LED kolundan geçen akımı hesaplayın.  
- 7.2) Toplam akımı bulun.  
- 7.3) Her bir dirençte harcanan gücü ve tüm dirençlerde toplam gücü hesaplayın.

**S8 – Gerilim Bölücü**  
8.1) 12V’luk bir kaynağı 5V civarına bölmek için basit bir gerilim bölücü tasarlayın. `R1` ve `R2` için pratik iki değer önerin ve çıkış voltajını hesaplayın.  
8.2) Çıkıştan 10 kΩ’luk bir yük bağlandığında voltajın nasıl değişeceğini yaklaşık olarak değerlendirin.

**S9 – Farklı Kaynaklarla Aynı Devre**  
Bir LED devresinde 330Ω seri direnç kullanılıyor.

- 9.1) Besleme 5V iken yaklaşık akımı bulun (LED düşümü 2V alınabilir).  
- 9.2) Aynı devre 9V ile beslenseydi, akım ne olurdu?  
- 9.3) Bu durumda LED’in ve direncin güvenliği açısından neler değişir?

**S10 – Direnç Değerini Artırmanın Etkisi**  
10.1) 9V kaynağa seri 220Ω direnç ve LED bağlı iken akımı hesaplayın (LED düşümü 2V).  
10.2) Direnci 1kΩ yaptığınızda akım ne olur? Parlaklıktaki değişimi niteliksel olarak yorumlayın.  
10.3) Direnci 10kΩ yaptığınızda LED’in görünür olup olmayacağını tartışın.

### 9.3. Seri / Paralel ve Devre Davranışı (S11–S15)

**S11 – İki LED Seri Devre**  
11.1) 9V kaynağa seri 1kΩ direnç ve iki adet LED (her biri 2V düşümlü) bağlandığında, direnç üzerindeki gerilim düşümünü ve devreden geçen akımı hesaplayın.  
11.2) Tek LED’li devreyle karşılaştırarak parlaklık farkını yorumlayın.

**S12 – İki LED Paralel Devre**  
12.1) 9V kaynağa paralel iki LED kolu bağlanıyor, her kolda 1kΩ direnç ve tek LED var. Her koldan geçen akımı ve toplam akımı hesaplayın.  
12.2) Seri devreye göre parlaklık ve toplam akım açısından farklılıkları özetleyin.

**S13 – Üç Dirençli Karışık Devre**  
Bir devrede 12V kaynağa önce 1kΩ direnç seri bağlanıyor; ardından 2kΩ ve 2kΩ dirençler paralel olarak devam ediyor.

- 13.1) Paralel kısımdaki eşdeğer direnci bulun.  
- 13.2) Toplam direnci hesaplayın.  
- 13.3) Devreden geçen toplam akımı ve her bir 2kΩ üzerindeki gerilimi hesaplayın.

**S14 – Gerilim Bölücünün Yüklenmesi**  
14.1) 10V kaynağı 5V civarına bölmek için 10kΩ–10kΩ seri dirençle oluşturduğunuz gerilim bölücünün orta noktasına 10kΩ’luk yük bağlayın. Yeni çıkış voltajını yaklaşık hesaplayın.  
14.2) Bu örnek üzerinden gerilim bölücülerin neden yüksek akım çeken yükleri doğrudan beslemek için uygun olmadığını tartışın.

**S15 – Hata Senaryosu**  
Bir öğrenci LED devresi kurarken, LED’i ters yönde bağlayıp seri direnci de unutuyor.

- 15.1) Bu durumda devrede neler olabileceğini, olası en kötü durumları da içerecek şekilde teknik dille açıklayın.  
- 15.2) Böyle bir hatayı devreyi enerjilendirmeden önce yakalamak için kontrol listesi önerin.

### 9.4. Breadboard ve Multimetre Odaklı Sorular (S16–S20)

**S16 – Breadboard Hata Analizi**  
16.1) Aynı satırdaki deliklerin bağlı olduğu bilgisine göre, aşağıdaki hatalardan hangileri devrenin hiç çalışmamasına, hangileri ise sadece beklenenden farklı davranmasına yol açar?  
- Direncin iki ucu aynı satıra takılmış.  
- LED’in iki ucu farklı satırlarda ama her ikisi de 5V rayına bağlı.  
- GND hattı ile 5V hattı yanlışlıkla jumper ile kısa devre edilmiş.  

**S17 – İlk Devreyi Kurarken Kontrol Listesi**  
17.1) Basit bir LED devresini breadboard üzerinde kurarken adım adım kontrol listesi çıkarın (besleme, polarite, seri direnç, bağlantı noktaları vb.).

**S18 – Multimetre ile Voltaj Ölçümü Senaryosu**  
18.1) 9V pil ve 1kΩ direnç–LED devresinde, aşağıdaki noktalar arasında hangi değerler beklenir?  
- Pil + ile Pil − arası  
- Direnç giriş–çıkış arası  
- LED giriş–çıkış arası  
18.2) Ölçülen değerin beklenenden sapması durumunda hangi tür devre hatalarından şüphelenmek gerekir?

**S19 – Direnç Ölçerken Yapılan Tipik Hata**  
19.1) Multimetre ile devrede takılı durumdaki bir direnci ölçtüğünüzde, beklenenden düşük bir değer okuyorsunuz. Bunun devredeki diğer bileşenlerle ilişkisini ve nedenini açıklayın.

**S20 – Güvenli Ölçüm Prensipleri**  
20.1) Özellikle batarya ile çalışan küçük gömülü devrelerde, multimetre ile çalışırken dikkat edilmesi gereken en az beş güvenlik/iyi uygulama maddesi yazın (akım ölçümü, kısa devre riskleri, prob konumu vb.).




