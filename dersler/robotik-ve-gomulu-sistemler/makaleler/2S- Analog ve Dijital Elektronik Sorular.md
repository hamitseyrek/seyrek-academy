# 2S – Analog ve Dijital Elektronik: Sorular

Bu dosya, `2- Analog ve Dijital Elektronik.md` konusuna ait kavram soruları ve uygulama problemlerini içerir.

---

## S1 – Aşağıdaki sistemleri "tamamen analog", "tamamen dijital" veya "karma (hibrit)" olarak sınıflandırın ve kısa gerekçe yazın:

- Eski tip radyo alıcısı (tuning düğmeli)
- Sayısal sıcaklık sensörlü akıllı termostat
- Analog mikrofon + dijital ses kaydedici
- Klasik on/off anahtarlı masa lambası

---

## S2 – Bir sıcaklık sensörünün saniyede 1 kez (1 Hz) okunması ile saniyede 100 kez (100 Hz) okunması arasında veri hacmi ve anlamlılık açısından farkları açıklayın.

---

## S3 – 8 bit ADC (256 seviye) ile 12 bit ADC (4096 seviye) arasındaki farkı, bir oda sıcaklığını ölçerken pratik örnek üzerinden açıklayın.

---

## S4 – 0-5 V aralığı için tasarlanmış bir ADC girişine yanlışlıkla 12 V uygulanırsa neler olabilir? Teknik ve donanımsal açıdan sonuçları tartışın.

---

## S5 – Dijital bir sinyalde gürültünün etkisini, analog sinyale kıyasla neden daha tolere edilebilir buluruz? Örnekle açıklayın.

---

## S6 – 10 bit, 0-5 V ADC ile 1.2 V'luk bir sensör sinyali okunduğunda beklenen dijital değeri hesaplayın.

Aynı sensörü 0-3.3 V referanslı bir ADC'ye bağladığınızda, 1.2 V için yeni dijital değeri bulun.

---

## S7 – 8 bit (0-255) ve 12 bit (0-4095) ADC'lerde, 0-5 V aralığında bit başına düşen gerilim adımını hesaplayın.

Hangi durumda küçük gerilim farklarını daha iyi ayırt edebilirsiniz? Sayısal olarak karşılaştırın.

---

## S8 – 1 kHz'lik bir sinüs sinyalini sağlıklı temsil edebilmek için minimum kaç Hz örnekleme frekansı gerekir (Nyquist kriteri bağlamında)?

Sıcaklık gibi yavaş değişen bir sinyal için Nyquist sınırının neden pratikte sorun olmadığını açıklayın.

---

## S9 – 10 bit, 0-5 V ADC'de +/-1 LSB hata payının Volt cinsinden karşılığını hesaplayın.

Bu hatayı sıcaklık ölçümünde (örneğin 10 mV/C hassasiyetli bir sensör için) yaklaşık kaç C belirsizlik olarak yorumlayabilirsiniz?

---

## S10 – 10 kOhm potansiyometre ile 5 V arasında kurulan bir gerilim bölücüde, orta uç 2.5 V verdiğinde ADC hangi sayıyı okur (10 bit, 0-5 V)?

Potansiyometre %10 yukarı, %10 aşağı oynatıldığında ADC değerlerinin nasıl değişeceğini yaklaşık hesaplayın.

---

## S11 – 5 V seviyeli bir PWM sinyalinde %25, %50 ve %75 duty için ortalama gerilim değerlerini hesaplayın (teorik).

Bu ortalama gerilimlerin LED parlaklığı ile ilişkisini niteliksel olarak yorumlayın.

---

## S12 – 10 Hz, 100 Hz ve 1 kHz PWM frekanslarında bir LED'in verdiği ışığın göz tarafından nasıl algılanacağını (fark edilir titreme, az fark edilir, sürekli gibi) tartışın.

---

## S13 – Girişlerden A = "sensör eşiği aştı", B = "acil durum butonu basılı" olsun. Çıkışı ancak her iki durum da 1 iken 1 olan basit bir dijital kural yazın; hangi kapıyı kullanmanız gerekir?

"Her iki durumda da 0 ise alarm ver, aksi halde sessiz kal" kuralını hangi mantık kapısıyla/kapılarıyla gerçekleştirebilirsiniz?

---

## S14 – İki kapı sensöründen yalnızca biri tetiklendiğinde alarm vermek istiyorsunuz (ikisi birden veya hiçbiri değil). Hangi kapı türü uygundur ve giriş-çıkış ilişkisini tabloyla gösterin.

---

## S15 – Sadece NAND kapıları kullanarak bir NOT ve bir AND kapısını nasıl kurabileceğinizi kavramsal olarak açıklayın (detaylı devre şart değil, temel fikir yeterli).

---

## S16 – Ortam ışığı azaldığında LED şeritleri yakan, ışık yeterince olduğunda kısan bir sistem hayal edin. Bu sistemde:

- Hangi kısım analog, hangi kısım dijital olur?
- ADC, mantık ve PWM nasıl sıralanır?

---

## S17 – Sıcaklık sensörü çıkışı analog, fan hızı PWM ile kontrol edilecek. Sıcaklık arttıkça fan hızının artacağı bir senaryoyu blok şema olarak açıklayın.

---

## S18 – Gürültülü bir sensör sinyalini ADC ile okuduktan sonra sayısal ortamda yumuşatmak için hangi basit yöntemler (örneğin hareketli ortalama) kullanılabilir? Kısaca özetleyin.

---

## S19 – ADC ölçümlerinde GND referansının tutarsız veya gürültülü olması hangi tür hatalara yol açar? Örnek üç durumla açıklayın.

---

## S20 – Depo seviye sensörü (analog), eşik karar mantığı (dijital) ve motor kontrolü (PWM) içeren bir depo dolum sistemi için, uçtan uca sinyal zincirini (sensör -> ADC -> karar -> PWM -> motor) detaylandırın; her aşamada hangi bilgiyi taşıdığınızı (Volt, sayı, mantıksal durum, duty cycle vb.) açıkça belirtin.

