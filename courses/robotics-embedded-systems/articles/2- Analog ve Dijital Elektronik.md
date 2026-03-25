# Analog ve Dijital Elektronik: Sinyaller, ADC/DAC ve Mantık

**Bu metin, analog ve dijital sinyal kavramlarını, örnekleme (sampling), ADC/DAC mantığını, temel mantık kapılarını ve PWM yaklaşımını tek çerçevede toplar. Amaç, gömülü sistemlerde sıkça karşılaşılan “bu sinyal analog mu, dijital mi, nasıl sayıya dönüyor ve tekrar analog hale geliyor?” sorularına uygulama odaklı ama ders planı dışı, metin tabanlı bir referans sunmaktır.**

---

## İçerik başlıkları

- Analog ve dijital sinyal tanımları, günlük hayattan örnekler  
- Örnekleme (sampling), çözünürlük (resolution) ve örnekleme frekansı (sampling rate)  
- ADC (Analog-Dijital Dönüştürücü): 10 bit ADC ve 0–1023 aralığı  
- DAC (Dijital-Analog Dönüştürücü) kavramı ve gömülü sistemlerde karşılığı  
- Temel mantık kapıları: AND, OR, NOT, NAND, NOR, XOR  
- PWM (Pulse Width Modulation) ve duty cycle kavramı  
- Gömülü sistemlerde analog okuma, dijital karar ve PWM çıkışı ilişkisi  
- Kavram soruları ve uygulama problemleri  

---

## 1. Analog ve Dijital Sinyaller

### 1.1. Tanımlar

- **Analog sinyal**: Zamanla sürekli değişen ve iki değer arasında teorik olarak sonsuz ara değer alabilen sinyaldir. Örnekler: sıcaklık, ses dalgası, ışık şiddeti, analog mikrofon çıkışı.  
- **Dijital sinyal**: Ayrık (discrete) seviyelerden oluşan sinyaldir. En yaygın haliyle **ikili (binary)** sinyal; yalnızca 0 ve 1 seviyeleri kullanılır.  

Bu iki tanım, gömülü sistemlerde sensör tarafı (genellikle analog) ve mikrodenetleyici içi temsil (dijital) arasında köprü kurarken temel rol oynar.

### 1.2. Günlük Hayattan Örnekler

Analog davranışa örnek:  
- Eski tip ses potansiyometresi (döndürdükçe sesin sürekli artıp azalması)  
- Cıvalı termometrede sıcaklık sütununun yükselip alçalması  
- Dimmer anahtarı ile lambanın parlaklığının ayarlanması  

Dijital davranışa örnek:  
- On/off ışık anahtarı  
- Klavye tuşları (basıldı/basılmadı)  
- Basit bir rölenin açık/kapalı durumu  

Bu örnekler, “hangi dünyada çalışıyoruz?” sorusunu pratikle ilişkilendirmek için kullanılabilir.

---

## 2. Örnekleme (Sampling) ve Çözünürlük

Gerçek dünya büyük ölçüde **analog** davranır; mikrodenetleyici ise içeride sayılarla (dijital) çalışır. Aradaki köprü:

- **Örnekleme (sampling)**  
- **Kuantalama (quantization)**  

olarak özetlenebilir.

### 2.1. Örnekleme

Örnekleme, analog bir sinyalin belirli zaman aralıklarında “fotoğrafını çekmek” gibidir:

- Saniyede alınan örnek sayısına **örnekleme frekansı** (sampling frequency, \(f_s\)) denir.  
- Birimi genellikle Hz (örnek/saniye).  

Ses dünyasından tipik bir değer:  
- 44.1 kHz → saniyede 44.100 örnek; CD kalitesine yakın ses için yaygın bir değerdir.  

Gömülü sistem bağlamında:  
- Sıcaklık sensörü okurken saniyede 10 örnek (10 Hz) çoğu zaman yeterlidir.  
- Titreşim veya ses gibi hızlı sinyaller için daha yüksek örnekleme gerekebilir.

### 2.2. Çözünürlük (Resolution)

Örnekleme, “ne sıklıkla ölçtüğümüzü” anlatırken, **çözünürlük**, “her ölçümde kaç farklı seviye ayırt edebildiğimizi” tanımlar.

- Bir ADC, örneği **N bit** ile temsil ediyorsa, ayırt edilebilir seviye sayısı \(2^N\) dir.  
- Örneğin 10 bit için: \(2^{10} = 1024\) seviye (0–1023).  

5 V referanslı 10 bit ADC için, bit başına gerilim yaklaşık:

```text
V_lsb ≈ 5V / 1023 ≈ 4.9 mV
```

Bu, analog girişte 4.9 mV’luk değişimlerin dijital karşılığının ancak bir seviye değiştireceği anlamına gelir.

---

## 3. ADC (Analog-Dijital Dönüştürücü)

### 3.1. Temel Blok Şeması

Bir ADC kabaca şu dönüşümü yapar:

```text
Analog Giriş (V_in) → [Örnekleme + Kuantalama] → Dijital Değer (0…2^N−1)
```

Gömülü sistemlerde tipik senaryo:

- Giriş aralığı: 0–5 V veya 0–3.3 V  
- Çözünürlük: 8 bit, 10 bit, 12 bit vb.  

### 3.2. 10 Bit ADC Örneği (0–5 V)

10 bit ADC → 0–1023 aralığı.  
Örnekler:

- Giriş 0 V iken → dijital değer ≈ 0  
- Giriş 2.5 V iken → dijital değer ≈ 512  
- Giriş 5 V iken → dijital değer ≈ 1023  

Dijital değerden gerilimi tahmin etmek için:

```text
V_in ≈ (okunan_değer / 1023) × V_ref
```

Örneğin okunan değer 256, V_ref = 5 V:

```text
V_in ≈ 256 × (5 / 1023) ≈ 1.25V (yaklaşık)
```

Bu ilişki, potansiyometre, ışık sensörü, sıcaklık sensörü gibi elemanlardan alınan analog sinyallerin anlamlandırılmasında sürekli kullanılır.

### 3.3. ADC Hatası ve Sınırlamaları

Gerçekte:

- Her seviye aralığı ±0.5 LSB belirsizlik içerir.  
- Gürültü, referans voltaj kararlılığı ve giriş empedansı gibi faktörler ölçüm doğruluğunu etkiler.  

Bu nedenle ADC okuması, “mutlak gerçek” değil, yeterince iyi bir **yaklaşım** olarak düşünülmelidir.

---

## 4. DAC (Dijital-Analog Dönüştürücü) ve PWM Bağlantısı

### 4.1. DAC Nedir?

DAC, ADC’nin tersini yapar:

```text
Dijital Değer (0…2^N−1) → Analog Gerilim veya Akım
```

- Örneğin 8 bit DAC, 0–255 aralığındaki sayıları 0–V_ref aralığında bir analog gerilime dönüştürür.  
- Gerçek DAC kullanan kartlarda, ses üretimi, hassas referanslar veya analog kontrol sinyalleri doğrudan üretilebilir.

### 4.2. Arduino Tarafında Durum

Birçok giriş seviyesi kartta (örneğin Arduino Uno):

- Donanımsal DAC yoktur.  
- Bunun yerine, **PWM (Pulse Width Modulation)** kullanılarak “ortalamada analog gibi davranan” bir sinyal üretilir.  

Bu yüzden Arduino tarafında `analogWrite()` fonksiyonu gerçekte analog bir gerilim değil, PWM sinyali üretir.

---

## 5. PWM (Pulse Width Modulation) ve Duty Cycle

PWM, belirli bir periyotta sinyali çok hızlı şekilde **1 (yüksek)** ve **0 (düşük)** seviyeleri arasında değiştirerek, ortalama güç veya gerilimi ayarlama yöntemidir.

### 5.1. Duty Cycle

- Bir PWM periyodu içinde, sinyalin **yüksek** olduğu süre, periyodun ne kadarını kaplıyorsa, bu oran **duty cycle** olarak adlandırılır.  
- Yüzde cinsinden ifade edilir:

```text
Duty Cycle (%) = (T_yüksek / T_toplam) × 100
```

Örnekler:

- %25 duty → zamanın çeyreğinde 1, geri kalanında 0  
- %50 duty → zamanın yarısı 1, yarısı 0  
- %75 duty → zamanın %75’i 1, %25’i 0  

Göz veya bazı fiziksel sistemler (örneğin DC motor) bu çok hızlı aç–kapa davranışını ortalama bir etki olarak algılar.

### 5.2. LED Parlaklığı ve PWM

LED parlaklığı PWM ile kontrol edildiğinde:

- Voltaj seviyesi genellikle sabittir (ör. 5 V),  
- Ancak LED’in yanık kaldığı süre oranı değişir.  

Sonuç:

- Düşük duty → LED daha sönük görünür.  
- Yüksek duty → LED daha parlak görünür.  

Bu yöntem, direnç değerini değiştirmeden parlaklık kontrolü sağlar; gömülü sistemlerde yaygın tercih sebebidir.

---

## 6. Temel Mantık Kapıları

Mantık kapıları, dijital sistemlerin en temel yapı taşlarıdır. Her kapı, giriş(ler)e göre bir çıkış üretir; giriş ve çıkışlar 0/1 (veya LOW/HIGH) olarak temsil edilir.

### 6.1. AND, OR, NOT

**AND (VE) kapısı**  
- Çıkış 1 olması için **tüm girişlerin 1** olması gerekir.

Örnek doğruluk tablosu (2 girişli):

```text
A  B  |  Çıkış (A AND B)
0  0  |  0
0  1  |  0
1  0  |  0
1  1  |  1
```

**OR (VEYA) kapısı**  
- Çıkış 1 olması için **en az bir girişin 1** olması yeterlidir.

```text
A  B  |  Çıkış (A OR B)
0  0  |  0
0  1  |  1
1  0  |  1
1  1  |  1
```

**NOT (DEĞİL) kapısı**  
- Tek girişlidir; 0’ı 1, 1’i 0’a çevirir.

```text
A  |  Çıkış (NOT A)
0  |  1
1  |  0
```

### 6.2. NAND, NOR, XOR

**NAND (AND’in tersi)**  
- Önce AND yapılır, sonuç NOT ile terslenir.  
- Tüm girişler 1 iken çıktı 0, diğer tüm durumlarda 1’dir.

**NOR (OR’un tersi)**  
- Önce OR yapılır, sonuç NOT ile terslenir.  
- Tüm girişler 0 iken çıktı 1, diğer tüm durumlarda 0’dır.

**XOR (Özel veya)**  
- Girişler **farklı** ise çıktı 1, **aynı** ise 0’dır.

```text
A  B  |  Çıkış (A XOR B)
0  0  |  0
0  1  |  1
1  0  |  1
1  1  |  0
```

XOR, özellikle hata tespiti, basit şifreleme, toplayıcı devreler gibi yerlerde sık kullanılır.

---

## 7. Gömülü Sistem Perspektifi: Analog Giriş → Dijital Karar → PWM Çıkış

Tipik bir gömülü akış şöyle özetlenebilir:

```text
Analog sensör → ADC → Sayısal işleme (karar) → PWM / Dijital çıkış → Aktüatör
```

Örnek senaryo – Potansiyometre ile LED parlaklık kontrolü:

1. Potansiyometre konumu, ADC ile 0–1023 arası sayıya dönüştürülür.  
2. Bu sayı, PWM aralığına (örneğin 0–255) ölçeklenir.  
3. Ölçeklenen değer, PWM duty cycle olarak kullanılır.  
4. LED, bu duty cycle’a göre daha parlak veya daha sönük yanar.  

Bu zincir, ikinci haftanın analog/dijital temellerini, ilerideki mikrodenetleyici ve Arduino uygulamalarıyla bağlayan temel omurgadır.

---

## 8. Kavram Soruları ve Uygulama Problemleri

Bu bölümdeki sorular, analog/dijital ayrımı, örnekleme–çözünürlük, ADC/DAC ve PWM–mantık kapıları konularını pekiştirmek için hazırlanmıştır. Ayrıntılı çözümler `2C- Analog ve Dijital Elektronik Çözümler.md` dosyasındadır.

### 8.1. Temel Kavram Soruları (S21–S25)

**S21 – Analog vs Dijital Örnekler**  
21.1) Aşağıdaki sistemleri “tamamen analog”, “tamamen dijital” veya “karma (hibrit)” olarak sınıflandırın ve kısa gerekçe yazın:  
- Eski tip radyo alıcısı (tuning düğmeli)  
- Sayısal sıcaklık sensörlü akıllı termostat  
- Analog mikrofon + dijital ses kaydedici  
- Klasik on/off anahtarlı masa lambası  

**S22 – Örnekleme Frekansı**  
22.1) Bir sıcaklık sensörünün saniyede 1 kez (1 Hz) okunması ile saniyede 100 kez (100 Hz) okunması arasında veri hacmi ve anlamlılık açısından farkları açıklayın.  

**S23 – Çözünürlük Algısı**  
23.1) 8 bit ADC (256 seviye) ile 12 bit ADC (4096 seviye) arasındaki farkı, bir oda sıcaklığını ölçerken pratik örnek üzerinden açıklayın.  

**S24 – ADC Giriş Aralığı Dışına Çıkmak**  
24.1) 0–5 V aralığı için tasarlanmış bir ADC girişine yanlışlıkla 12 V uygulanırsa neler olabilir? Teknik ve donanımsal açıdan sonuçları tartışın.  

**S25 – Dijital Sinyallerde Gürültü**  
25.1) Dijital bir sinyalde gürültünün etkisini, analog sinyale kıyasla neden daha tolere edilebilir buluruz? Örnekle açıklayın.

### 8.2. ADC ve Örnekleme Problemleri (S26–S30)

**S26 – 10 Bit ADC Ölçekleme**  
26.1) 10 bit, 0–5 V ADC ile 1.2 V’luk bir sensör sinyali okunduğunda beklenen dijital değeri hesaplayın.  
26.2) Aynı sensörü 0–3.3 V referanslı bir ADC’ye bağladığınızda, 1.2 V için yeni dijital değeri bulun.

**S27 – Bit Artışının Etkisi**  
27.1) 8 bit (0–255) ve 12 bit (0–4095) ADC’lerde, 0–5 V aralığında bit başına düşen gerilim adımını hesaplayın.  
27.2) Hangi durumda küçük gerilim farklarını daha iyi ayırt edebilirsiniz? Sayısal olarak karşılaştırın.

**S28 – Örnekleme ve Nyquist**  
28.1) 1 kHz’lik bir sinüs sinyalini sağlıklı temsil edebilmek için minimum kaç Hz örnekleme frekansı gerekir (Nyquist kriteri bağlamında)?  
28.2) Sıcaklık gibi yavaş değişen bir sinyal için Nyquist sınırının neden pratikte sorun olmadığını açıklayın.

**S29 – ADC Ölçüm Hatası**  
29.1) 10 bit, 0–5 V ADC’de ±1 LSB hata payının Volt cinsinden karşılığını hesaplayın.  
29.2) Bu hatayı sıcaklık ölçümünde (örneğin 10 mV/°C hassasiyetli bir sensör için) yaklaşık kaç °C belirsizlik olarak yorumlayabilirsiniz?

**S30 – Potansiyometre ve Gerilim Bölücü**  
30.1) 10 kΩ potansiyometre ile 5 V arasında kurulan bir gerilim bölücüde, orta uç 2.5 V verdiğinde ADC hangi sayıyı okur (10 bit, 0–5 V)?  
30.2) Potansiyometre %10 yukarı, %10 aşağı oynatıldığında ADC değerlerinin nasıl değişeceğini yaklaşık hesaplayın.

### 8.3. PWM ve Mantık Kapıları Problemleri (S31–S35)

**S31 – PWM ile Ortalama Gerilim Yaklaşımı**  
31.1) 5 V seviyeli bir PWM sinyalinde %25, %50 ve %75 duty için ortalama gerilim değerlerini hesaplayın (teorik).  
31.2) Bu ortalama gerilimlerin LED parlaklığı ile ilişkisini niteliksel olarak yorumlayın.

**S32 – PWM Frekansı ve Algı**  
32.1) 10 Hz, 100 Hz ve 1 kHz PWM frekanslarında bir LED’in verdiği ışığın göz tarafından nasıl algılanacağını (fark edilir titreme, az fark edilir, sürekli gibi) tartışın.  

**S33 – Basit Mantık Tasarımı**  
33.1) Girişlerden A=“sensör eşiği aştı”, B=“acil durum butonu basılı” olsun. Çıkışı ancak her iki durum da 1 iken 1 olan basit bir dijital kural yazın; hangi kapıyı kullanmanız gerekir?  
33.2) “Her iki durumda da 0 ise alarm ver, aksi halde sessiz kal” kuralını hangi mantık kapısıyla/kapılarıyla gerçekleştirebilirsiniz?

**S34 – XOR Kullanımı**  
34.1) İki kapı sensöründen yalnızca biri tetiklendiğinde alarm vermek istiyorsunuz (ikisi birden veya hiçbiri değil). Hangi kapı türü uygundur ve giriş–çıkış ilişkisini tabloyla gösterin.  

**S35 – NAND ile Evrensellik**  
35.1) Sadece NAND kapıları kullanarak bir NOT ve bir AND kapısını nasıl kurabileceğinizi kavramsal olarak açıklayın (detaylı devre şart değil, temel fikir yeterli).

### 8.4. Uygulama Senaryoları (S36–S40)

**S36 – Işık Sensörü ile Aydınlatma Kontrolü**  
36.1) Ortam ışığı azaldığında LED şeritleri yakan, ışık yeterince olduğunda kısan bir sistem hayal edin. Bu sistemde:  
- Hangi kısım analog, hangi kısım dijital olur?  
- ADC, mantık ve PWM nasıl sıralanır?  

**S37 – Sıcaklık Kontrollü Fan**  
37.1) Sıcaklık sensörü çıkışı analog, fan hızı PWM ile kontrol edilecek. Sıcaklık arttıkça fan hızının artacağı bir senaryoyu blok şema olarak açıklayın.  

**S38 – Basit Dijital Filtreleme Fikri**  
38.1) Gürültülü bir sensör sinyalini ADC ile okuduktan sonra sayısal ortamda yumuşatmak için hangi basit yöntemler (örneğin hareketli ortalama) kullanılabilir? Kısaca özetleyin.  

**S39 – ADC Ölçümlerinde Toprak Referansı**  
39.1) ADC ölçümlerinde GND referansının tutarsız veya gürültülü olması hangi tür hatalara yol açar? Örnek üç durumla açıklayın.  

**S40 – Gömülü Sistemde Sinyal Zincirini Tasarlama**  
40.1) Depo seviye sensörü (analog), eşik karar mantığı (dijital) ve motor kontrolü (PWM) içeren bir depo dolum sistemi için, uçtan uca sinyal zincirini (sensör → ADC → karar → PWM → motor) detaylandırın; her aşamada hangi bilgiyi taşıdığınızı (Volt, sayı, mantıksal durum, duty cycle vb.) açıkça belirtin.

