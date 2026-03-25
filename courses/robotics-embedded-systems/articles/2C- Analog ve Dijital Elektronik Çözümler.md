# 2C – Analog ve Dijital Elektronik: Çözümler ve Açıklamalar

Bu dosya, `2- Analog ve Dijital Elektronik.md` içinde 8. bölümde yer alan **S21–S40** numaralı sorular için özet çözümler ve açıklamalar içerir.

---

## S21 – Analog vs Dijital Örnekler

**21.1) Örnek sınıflandırma**  
- Eski tip radyo alıcısı (tuning düğmeli) → Ağırlıklı analog (sürekli frekans ayarı, analog RF ve ses işleme).  
- Sayısal sıcaklık sensörlü akıllı termostat → Karma; sensör tarafı çoğu zaman analog, iç işlem dijital, gösterge ve kontrol dijital.  
- Analog mikrofon + dijital ses kaydedici → Karma; mikrofon çıkışı analog, ADC sonrası işleme ve kayıt dijital.  
- Klasik on/off anahtarlı masa lambası → Dijital benzeri davranış (sadece açık/kapalı), ancak güç tarafı AC analog dalga içerir.  

---

## S22 – Örnekleme Frekansı

**22.1)**  
- 1 Hz okuma → Az veri, yavaş değişen sıcaklık için çoğu durumda yeterli; ani pikler kaçabilir.  
- 100 Hz okuma → Çok daha fazla veri, gerekmedikçe israf; sıcaklık gibi yavaş sinyaller için anlamlı ek bilgi sağlamaz, sadece gereksiz veri üretir.  

Pratikte sinyalin gerçek değişim hızı, örnekleme hızını belirler.

---

## S23 – Çözünürlük Algısı

**23.1)** 0–5 V aralığı için:  
- 8 bit: \(V_{lsb} ≈ 5V / 255 ≈ 19.6 mV\)  
- 12 bit: \(V_{lsb} ≈ 5V / 4095 ≈ 1.22 mV\)  

10 mV/°C hassasiyetli bir sıcaklık sensöründe:  
- 8 bit ADC → yaklaşık 2 °C mertebesinde bir adım büyüklüğü.  
- 12 bit ADC → yaklaşık 0.1–0.2 °C mertebesinde adım büyüklüğü.  

Dolayısıyla 12 bit ADC ile sıcaklıktaki küçük değişimleri daha iyi ayırt etmek mümkündür.

---

## S24 – ADC Giriş Aralığı Dışına Çıkmak

**24.1)**  
- Giriş 0–5 V için tasarlanmışsa, 12 V uygulanması giriş pininde ve hatta tüm mikrodenetleyicide hasara yol açabilir.  
- Bazı tasarımlarda koruma dirençleri ve kelepçe diyotları varsa, akım bu yollardan akar ve aşırı ısınma/bozulma riski oluşur.  
- En iyi ihtimalle ölçüm doygunluğa gider (her zaman maksimum değeri okur), en kötü ihtimalle donanım kalıcı olarak zarar görür.

---

## S25 – Dijital Sinyallerde Gürültü

**25.1)**  
- Dijitalde tek ihtiyacımız olan, sinyalin 0 veya 1 eşiğini geçip geçmediğini bilmek; küçük gürültüler bu eşiği değiştirmiyorsa yanlış yorum oluşmaz.  
- Analogta ise sinyalin tam genlik değeri önemli olduğundan, küçük gürültüler bile ölçüm sonucunu bozar.  

Bu nedenle dijital seviyeler, belli bir tolerans aralığında gürültüye daha dayanıklıdır.

---

## S26 – 10 Bit ADC Ölçekleme

**26.1)** 10 bit, 0–5 V:  

```text
V_lsb ≈ 5V / 1023 ≈ 4.89 mV
1.2V ≈ 1.2V / 0.00489V ≈ 245 seviye
```

Yaklaşık dijital değer: **245**.

**26.2)** 0–3.3 V, 10 bit:  

```text
V_lsb ≈ 3.3V / 1023 ≈ 3.23 mV
1.2V ≈ 1.2V / 0.00323V ≈ 372 seviye
```

Yaklaşık dijital değer: **372**.

---

## S27 – Bit Artışının Etkisi

**27.1)** 0–5 V için:  
- 8 bit: \(V_{lsb,8} ≈ 5V / 255 ≈ 19.6 mV\)  
- 12 bit: \(V_{lsb,12} ≈ 5V / 4095 ≈ 1.22 mV\)  

**27.2)** 12 bit ADC, 8 bite göre yaklaşık \(19.6 / 1.22 ≈ 16\) kat daha ince gerilim adımı sağlar; küçük farkları daha iyi ayırt eder.

---

## S28 – Örnekleme ve Nyquist

**28.1)** Nyquist kriteri: \(f_s ≥ 2 × f_{max}\).  
- 1 kHz sinyal için minimum örnekleme: **2 kHz**.  
- Pratikte biraz daha yüksek (ör. 4–8 kHz) seçilir.  

**28.2)** Sıcaklık gibi yavaş sinyallerde temel frekans çok düşüktür (saniyede birkaç değişim bile nadirdir); saniyede 1–10 örnek bile Nyquist şartının çok üzerindedir. Bu nedenle aliasing tipik olarak problem olmaz.

---

## S29 – ADC Ölçüm Hatası

**29.1)** 10 bit, 0–5 V:  

```text
V_lsb ≈ 5V / 1023 ≈ 4.89 mV
±1 LSB ≈ ±4.89 mV
```

**29.2)** 10 mV/°C sensör için:  

```text
4.89 mV ≈ 0.489 °C
```

Yaklaşık ±0.5 °C belirsizlik anlamına gelir.

---

## S30 – Potansiyometre ve Gerilim Bölücü

**30.1)** 0–5 V, 10 bit ADC için:  
- 2.5 V → tam orta nokta:  

```text
değer ≈ 1023 × (2.5 / 5) ≈ 511–512
```

**30.2)** %10 yukarı/aşağı:  
- 2.5 V’un %10’u ≈ 0.25 V → 2.25 V ve 2.75 V aralığı.  

```text
2.25V → ≈ 1023 × (2.25 / 5) ≈ 461
2.75V → ≈ 1023 × (2.75 / 5) ≈ 563
```

Yani ADC değeri yaklaşık 460–560 bandında değişir.

---

## S31 – PWM ile Ortalama Gerilim

**31.1)** 5 V için:

```text
%25 duty → V_ort = 0.25 × 5V = 1.25V
%50 duty → V_ort = 0.5 × 5V = 2.5V
%75 duty → V_ort = 0.75 × 5V = 3.75V
```

**31.2)** LED parlaklığı, ortalama güce kabaca orantılıdır; dolayısıyla duty arttıkça LED daha parlak görünür.

---

## S32 – PWM Frekansı ve Algı

**32.1)**  
- 10 Hz: Gözle fark edilir yanıp sönme (titreme).  
- 100 Hz: Çoğu durumda rahatsız edici değildir, hafif titreme bazı kişilerce algılanabilir.  
- 1 kHz: İnsan gözü için sürekli ışık gibi görünür; LED parlaklık kontrolü için yaygın ve konforlu bir aralıktır.

---

## S33 – Basit Mantık Tasarımı

**33.1)**  
- “Her ikisi de 1 ise çıkış 1” → **AND (VE)** kapısı: `Çıkış = A AND B`.  

**33.2)**  
- “Her ikisi de 0 ise alarm ver, aksi halde sessiz” → Girişler 0 iken çıkış 1 olmalı; bu, `NOR` davranışına benzer:  
  - `Çıkış = NOT (A OR B)` şeklinde ifade edilebilir.  

---

## S34 – XOR Kullanımı

**34.1)**  
- “Yalnızca biri tetiklendiğinde” → XOR:  

```text
A  B  |  Çıkış (A XOR B)
0  0  |  0
0  1  |  1
1  0  |  1
1  1  |  0
```

Bu tablo, iki kapı sensöründen sadece birinin durumu değiştiğinde alarm vermek için uygundur.

---

## S35 – NAND ile Evrensellik

**35.1)**  
- NOT A: A girişli bir NAND kapısının her iki girişine A bağlanır:

```text
NOT A = A NAND A
```

- AND:  
  - Önce AND yapılıp sonra NOT alınırsa NAND elde edilir; tam tersine, iki NAND kapısı kullanarak AND üretilebilir.  
  - Örneğin `(A NAND B)` ifadesini tekrar NAND’den geçirerek `NOT(NAND)` uygulanır, bu da AND ile eşdeğerdir.  

Bu fikir, NAND’ın “evrensel kapı” olduğunu gösterir; diğer kapılar NAND kombinasyonlarıyla kurulabilir.

---

## S36 – Işık Sensörü ile Aydınlatma Kontrolü

**36.1)** Örnek blok şema:  
- LDR (ışığa duyarlı direnç) + gerilim bölücü → analog gerilim üretir.  
- Bu gerilim ADC ile sayıya dönüştürülür.  
- Mikrodenetleyici, bu sayıyı belirli eşiklerle karşılaştırarak “karanlık / aydınlık” kararını verir (dijital mantık).  
- Çıkışta PWM kullanılarak LED şerit parlaklığı ayarlanır; duty cycle ışık seviyesine ters orantılı seçilebilir.

---

## S37 – Sıcaklık Kontrollü Fan

**37.1)** Örnek akış:  
- Sıcaklık sensörü (NTC, analog sensör veya analog çıkışlı IC) → analog gerilim.  
- ADC → sıcaklık değeri sayıya dönüştürülür.  
- Yazılımda belirli eşiklere göre PWM duty hesaplanır (örn. düşük sıcaklıkta düşük duty, yüksek sıcaklıkta yüksek duty).  
- PWM çıkışı fan sürücü devresine (transistör/MOSFET) uygulanır; fan hızı sıcaklığa göre değişir.

---

## S38 – Basit Dijital Filtreleme Fikri

**38.1)** Örnek yöntemler:  
- **Hareketli ortalama (moving average)**: Son N ölçümün ortalamasını almak.  
- **Basit düşük geçiren filtre**: `y[n] = α·x[n] + (1−α)·y[n−1]` şeklinde birinci dereceden filtre.  
- Ani sıçramaları sınırlamak için “clamp” veya eşik tabanlı filtreler.  

Bu yöntemler, gürültüyü azaltırken sinyal gecikmesini bir miktar artırır.

---

## S39 – ADC Ölçümlerinde Toprak Referansı

**39.1)** Örnek hatalar:  
- GND noktaları arasında potansiyel fark oluşması (ground loop) → ADC girişindeki gerçek gerilimin yanlış algılanması.  
- Yüksek akımlı yolların ADC referans hattını gürültülendirmesi → ölçümlerde rastgele dalgalanmalar.  
- Yetersiz topraklama bağlantıları → referans noktasının stabil olmaması, özellikle hassas düşük seviye ölçümlerde belirgin hata.  

Çözüm olarak tek nokta topraklama, ayrı analog/dijital toprak düzeni ve dikkatli hat yerleşimi kullanılır.

---

## S40 – Gömülü Sistemde Sinyal Zincirini Tasarlama

**40.1)** Örnek zincir:  

1. **Sensör**: Depo seviye sensörü analog bir gerilim üretir (ör. 0–5 V arası; 0 V boş, 5 V dolu).  
2. **ADC**: Bu gerilim, 10 bit ADC tarafından 0–1023 arası sayıya dönüştürülür.  
3. **Karar mantığı**: Yazılım, bu sayıyı eşiklerle karşılaştırır:  
   - Değer düşük eşik altındaysa → “depo boş”, motoru çalıştır.  
   - Değer üst eşik üzerindeyse → “depo dolu”, motoru durdur.  
   - Aradaki bölge için histerezis tanımlanabilir.  
4. **PWM üretimi** (opsiyonel): Motor hızını ayarlamak gerekiyorsa, depo seviyesi veya dolma hızı bilgisine göre bir PWM duty cycle hesaplanır.  
5. **Sürücü devresi**: PWM sinyali, güç katında bir MOSFET veya sürücü entegresi aracılığıyla motoru kontrol eder.  

Bilgi türleri:  
- Sensör çıkışı → Volt cinsinden analog bilgi.  
- ADC çıkışı → Sayı (tam sayı).  
- Karar mantığı → Mantıksal durumlar (boş/doluluk, alarm seviyeleri).  
- PWM → Duty cycle yüzdesi ve belirli bir frekansta dijital dalga formu.  

