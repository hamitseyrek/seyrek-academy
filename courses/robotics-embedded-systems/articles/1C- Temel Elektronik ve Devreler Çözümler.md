# 1C – Temel Elektronik ve Devreler: Çözümler ve Açıklamalar

Bu dosya, `1- Temel Elektronik ve Devreler.md` içindeki 9. bölümde yer alan **S1–S20** numaralı sorular için özet çözümler ve açıklamalar içerir. Hesaplamalarda küçük yuvarlamalar yapılmış olabilir; amaç, kavramsal çerçeveyi netleştirmektir.

---

## S1 – Elektrik / Elektronik Ayrımı

**1.1) Sınıflandırma (örnek yanıt)**  
- Sigorta kutusu → Elektrik  
- LED ampul (iç devresiyle birlikte) → Elektronik (içinde sürücü devre ve LED’ler var)  
- Modem → Elektronik  
- Priz uzatma kablosu → Elektrik  
- Çamaşır makinesi kontrol kartı → Elektronik (kontrol ve sinyal işleme tarafı)  

**1.2) Özet fark**  
- Elektrik, enerjinin iletimi ve güç altyapısı ile ilgilidir (hatlar, kablolar, priz, sigorta).  
- Elektronik, bu enerjiyi sinyale dönüştürüp işleyen, ölçen ve kontrol eden devrelerle (kartlar, entegreler, sensörler, mikrodenetleyiciler) ilgilidir.

---

## S2 – Su Benzetmesi

**2.1)**  
- Deponun yüksekliğini artırmak → Voltaj artar.  
- Boruyu daraltmak → Direnç artar, akım azalır.  
- Boruyu genişletmek → Direnç azalır, akım artar.  

**2.2)**  
“Yüksek voltaj = yüksek akım” ancak direnç sabitse doğrudur (`I = V / R`). Gerçekte:  
- Hat direnci, yük direnci, kablo uzunluğu gibi etkenler akımı sınırlar.  
- Bazı kaynaklar akımı sınırlamak üzere tasarlanır (akım sınırlamalı güç kaynakları).  

---

## S3 – Birim ve Büyüklükler

**3.1)**  
- 220 mA = 0.220 A  
- 4.7 kΩ = 4700 Ω  
- 10 µF = 10 × 10⁻⁶ F  

**3.2)** (örnekler)  
- AA pil ≈ 1.5 V  
- USB portu ≈ 5 V  
- Türkiye’de priz ≈ 220–230 V AC  

---

## S4 – Ohm Kanunu Yorum Soruları

**4.1)** Voltaj sabit, direnç 2 katına çıkarsa:  
`I = V / R` → Akım yarıya düşer.  

**4.2)** Direnç sabit, voltaj 2 katına çıkarsa:  
Akım iki katına çıkar.  

**4.3)** İnce uzun kablo: daha uzun yol ve daha dar kesit → etkin direnç artar (`R = ρ·L / A`). Bu da aynı voltaj altında daha az akım anlamına gelir.

---

## S5 – Güç ve Isınma

**5.1)** Aynı akımı çeken iki dirençten Watt değeri yüksek olan (örneğin 2W) daha az ısınır; çünkü aynı güç, daha büyük bir kapasiteye yayılmıştır.  

**5.2)** Olası nedenler:  
- Regülatör giriş–çıkış voltaj farkı büyük, çekilen akım yüksek.  
- Yetersiz soğutma veya hava akımı.  
- Tasarımda gereğinden yüksek yük bağlanması (akım sınırına yakın çalıştırma).

---

## S6 – Temel Direnç Hesabı

**6.1)**  
- Besleme 5 V, LED ≈ 1.8 V, hedef akım 15 mA = 0.015 A.  
- Direnç üzerindeki gerilim: `V_R = 5 − 1.8 = 3.2 V`.  

```text
R = V_R / I = 3.2V / 0.015A ≈ 213 Ω
```

Pratikte 220 Ω uygundur.

**6.2)** 220 Ω kullanıldığında:  

```text
I ≈ V_R / R = 3.2V / 220Ω ≈ 0.0145A = 14.5 mA
```

Hedefe çok yakındır.

---

## S7 – LED Dizisi ile Güç Analizi

Her LED kolu: 12 V kaynak, 1 kΩ direnç, LED ≈ 2 V.  
Direnç üzerindeki gerilim: `V_R = 12 − 2 = 10 V`.

**7.1)** Kol başına akım:

```text
I_kol = 10V / 1000Ω = 0.01A = 10 mA
```

**7.2)** 10 kol için toplam akım:

```text
I_toplam = 10 × 10 mA = 100 mA
```

**7.3)**  
- Direnç başına güç:

```text
P_direnç = V_R × I_kol = 10V × 0.01A = 0.1W
```

- Tüm dirençlerde toplam güç: `10 × 0.1W = 1W`.

---

## S8 – Gerilim Bölücü

**8.1)** 12 V → ≈ 5 V için en basit çözüm: `R1` ve `R2` oranını ayarlamak.  
Örnek: `R1 = 7.5 kΩ`, `R2 = 5 kΩ`:

```text
V_out = 12V × (R2 / (R1 + R2))
      = 12V × (5000 / (7500 + 5000))
      = 12V × (5000 / 12500)
      ≈ 4.8V
```

**8.2)** Çıkışa 10 kΩ yük bağlandığında, `R2` ile paralel olur:  

```text
R_eq = (5000 × 10000) / (5000 + 10000) ≈ 3333 Ω
V_out_yeni ≈ 12V × (3333 / (7500 + 3333)) ≈ 3.8V civarı
```

Yük eklenince çıkış belirgin şekilde düşer; bu nedenle gerilim bölücü yüksek akım çeken yükler için uygun değildir.

---

## S9 – Farklı Kaynaklarla Aynı Devre

LED ileri gerilimi 2 V varsayılır.

**9.1)** 5 V besleme, 330 Ω:

```text
V_R = 5V − 2V = 3V
I = 3V / 330Ω ≈ 0.0091A = 9.1 mA
```

**9.2)** 9 V besleme, aynı devre:

```text
V_R = 9V − 2V = 7V
I = 7V / 330Ω ≈ 0.0212A = 21.2 mA
```

**9.3)** 21 mA, birçok LED için sınır civarındadır; uzun süreli çalışmada LED’in ısınması ve ömrünün kısalması mümkündür. Dirençte harcanan güç de artar:

```text
P ≈ V_R × I ≈ 7V × 0.0212A ≈ 0.15W
```

0.25W’lık direnç kullanılmalıdır.

---

## S10 – Direnç Değerini Artırmanın Etkisi

LED ≈ 2 V varsayılır.

**10.1)** 220 Ω:

```text
V_R = 9V − 2V = 7V
I = 7V / 220Ω ≈ 31.8 mA
```

Bu akım birçok standart LED için yüksek kabul edilir.

**10.2)** 1 kΩ:

```text
I = 7V / 1000Ω = 7 mA
```

LED daha sönük ama güvenli tarafta çalışır.

**10.3)** 10 kΩ:

```text
I = 7V / 10000Ω = 0.7 mA
```

Karanlık ortamda hafif bir parlama görülebilir; aydınlık ortamda çoğu durumda fark edilmez.

---

## S11 – İki LED Seri Devre

**11.1)** 9 V, 1 kΩ, iki LED (2 V + 2 V):

```text
V_R = 9V − 2V − 2V = 5V
I = 5V / 1000Ω = 5 mA
```

**11.2)** Tek LED’li, 1 kΩ dirençli devrede:

```text
V_R = 9V − 2V = 7V
I ≈ 7 mA
```

İki LED seri bağlandığında akım daha düşük, dolayısıyla her LED tek LED’li devreye göre daha sönüktür.

---

## S12 – İki LED Paralel Devre

Her kolda: 9 V, 1 kΩ ve tek LED:

```text
V_R = 9V − 2V = 7V
I_kol = 7V / 1000Ω = 7 mA
```

**12.1)** Toplam akım:

```text
I_toplam = 2 × 7 mA = 14 mA
```

**12.2)** Paralel devrede her LED tek başına çalışıyormuş gibi tam parlak yanar; seri devreye göre parlaklık daha yüksektir, fakat toplam akım da daha fazladır.

---

## S13 – Üç Dirençli Karışık Devre

Paralel kısım: iki adet 2 kΩ:

```text
1 / R_par = 1 / 2000 + 1 / 2000 = 2 / 2000
R_par = 1000 Ω
```

**13.1)** Paralel eşdeğer: 1 kΩ.  
**13.2)** Toplam direnç:

```text
R_toplam = 1kΩ (seri) + 1kΩ (paralel) = 2kΩ
```

**13.3)** Toplam akım:

```text
I = 12V / 2000Ω = 6 mA
```

Paralel kısım girişindeki gerilim:

```text
V_par = I × R_par = 6 mA × 1000Ω = 6V
```

Her bir 2 kΩ üzerindeki akım:

```text
I_2k = V_par / 2000Ω = 6V / 2000Ω = 3 mA
```

---

## S14 – Gerilim Bölücünün Yüklenmesi

**14.1)** 10 V kaynak, 10 kΩ–10 kΩ, orta nokta 5 V.  
Yüke (10 kΩ) bağlandığında, alt tarafta 10 kΩ // 10 kΩ = 5 kΩ olur:

```text
V_out = 10V × (R_alt / (R_üst + R_alt))
      = 10V × (5000 / (10000 + 5000))
      ≈ 3.33V
```

**14.2)** Çıkış gerilimi yük akımı arttıkça düşer; bu nedenle gerilim bölücü, referans üretme veya çok küçük akım çeken devreleri besleme için uygundur, yüksek akım çeken yükler için bir “besleme kaynağı” gibi tasarlanmamalıdır.

---

## S15 – Hata Senaryosu

**15.1)**  
- LED ters bağlandığında, ideal durumda akım geçmez; ancak bazı devrelerde ters gerilim LED’in zarar görmesine yol açabilir.  
- Seri direnç olmadığında, kaynağın iç direnci ve kablo/bağlantı direnci dışında akımı sınırlayan eleman yoktur; bu da yüksek akım ve ısınma, hatta kaynağın zarar görmesi anlamına gelir.

**15.2)** Kontrol listesi (örnek):  
- Kaynak voltajı uygun mu?  
- Tüm LED’lerin anot–katot yönleri doğru mu?  
- Her LED için uygun seri direnç var mı?  
- 5V ve GND hatları yanlışlıkla kısa devre edilmiş mi?  
- Breadboard’da aynı satır bağlantıları doğru mu okunmuş?

---

## S16 – Breadboard Hata Analizi

**16.1)**  
- Direncin iki ucu aynı satıra takılmış → Direnç devre dışıdır, kısa devre etkisi; devre beklenenden çok daha fazla akım çekebilir.  
- LED’in iki ucu farklı satırlarda ama her ikisi de 5V rayına bağlı → LED’in iki ucu da aynı potansiyelde, akım akmaz; devre çalışmaz.  
- GND hattı ile 5V hattı jumper ile kısa devre edilmiş → Doğrudan kısa devre, kaynağı aşırı zorlar; sigorta/pil/hat korunmuyorsa hasar oluşabilir.

---

## S17 – İlk Devreyi Kurarken Kontrol Listesi

Örnek cevap:  
- Besleme voltajı, LED ve direnç için uygun mu?  
- 5V ve GND rayları doğru yerleştirilmiş ve karışmamış mı?  
- LED’in uzun bacağı (anot) doğru tarafa, kısa bacağı (katot) doğru tarafa mı bakıyor?  
- Seri direnç gerçekten LED ile kaynak arasına mı bağlı, yoksa devre dışı mı kalmış?  
- Breadboard satır bağlantıları beklenen şekilde mi kullanılmış?  

---

## S18 – Multimetre ile Voltaj Ölçümü Senaryosu

**18.1)** 9 V, 1 kΩ, LED (≈2 V) devresi:  
- Pil + ile Pil − arası → ≈ 9 V  
- Direnç giriş–çıkış arası → ≈ 7 V (9 − 2)  
- LED giriş–çıkış arası → ≈ 2 V  

**18.2)** Beklenenden sapma:  
- 9 V yerine çok daha düşük değer → pil zayıf veya yük altında çökmüş.  
- LED üzerinde ≈ 0 V → LED ters bağlanmış veya açık devre.  
- Direnç üzerinde ≈ 0 V → Direnç devre dışı kalmış (kısa devre).

---

## S19 – Direnç Ölçerken Yapılan Tipik Hata

Devrede takılı direnç, paralel veya seri başka yollar üzerinden ölçülür; multimetrenin gördüğü eşdeğer direnç, tek bir bileşenin değil tüm yolun eşdeğeridir. Özellikle paralel bağlı dirençler varsa, ölçülen değer beklenenden daha düşük çıkar.

---

## S20 – Güvenli Ölçüm Prensipleri

Örnek maddeler:  
- Akım ölçümü yaparken multimetrenin doğru girişine (mA/A soketi) takıldığından emin olun.  
- Akım ölçerken devreye **seri** girildiğini, voltaj ölçerken **paralel** ölçüm yapıldığını unutmayın.  
- Direnç ölçümü yapmadan önce devreyi enerjisiz hale getirin.  
- Prob uçlarının kayıp kısa devre oluşturmaması için elleri ve devreyi sabitleyin.  
- Batarya veya güç kaynağının kısa devreye karşı korumalı olup olmadığını bilmeden hat uçlarını doğrudan bağlamayın.  

