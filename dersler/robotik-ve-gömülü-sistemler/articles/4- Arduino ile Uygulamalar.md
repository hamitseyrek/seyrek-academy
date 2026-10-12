# Arduino ile Uygulamalar: Devre, Kod ve Gömülü Düşünceyi Birleştirmek

**Bu metin, önceki notlarda ele alınan temel elektronik, analog–dijital kavramlar ve Arduino programlama iskeletini; birkaç tipik uygulama senaryosu üzerinden bir araya getirir. Odak, “hangi bileşen nerede, hangi sinyal nasıl işleniyor ve kod tarafında bunun karşılığı ne?” sorularını kavramsal düzeyde netleştirmektir.**

---

## İçerik başlıkları

- Gömülü uygulama perspektifinin kısa özeti  
- Uygulama 1: LED ve buton ile temel I/O davranışı  
- Uygulama 2: PWM ile LED parlaklık kontrolü  
- Uygulama 3: Potansiyometre ile analog okuma ve PWM’i birleştirmek  
- Uygulama 4 (fikrî çerçeve): Basit sensör–karar–aktüatör zinciri  
- Uygulama tasarlarken dikkat edilecek genel prensipler  
- Kavram soruları ve senaryo problemleri  

---

## 1. Uygulama Perspektifinin Özeti

Önceki notların birleştiği nokta:

```text
Donanım (devre) + Yazılım (kod) + Zamanlama (loop)
```

Her uygulamada şu sorular tekrar eder:

1. Hangi **girdiler** var? (Buton, sensör, potansiyometre vb.)  
2. Hangi **kararlar** verilecek? (Eşikler, durumlar, zamanlayıcılar.)  
3. Hangi **çıktılar** üretilecek? (LED, motor, röle, ses, seri mesaj vb.)  
4. Bu üçü, **sonsuz döngü** içinde nasıl bir akışla birbirine bağlanacak?  

Bu not, ayrıntılı satır satır kod vermek yerine, her uygulamanın mantıksal iskeletini ve devre–kod ilişkisini vurgular.

---

## 2. Uygulama 1 – LED ve Buton ile Temel I/O

### 2.1. Devre Fikri

- Bir LED, Arduino’nun PWM destekli veya normal dijital pinlerinden birine seri direnç ile bağlanır.  
- Bir buton, uygun bir pull-up veya pull-down düzeniyle dijital giriş pinine bağlanır.  

Amaç:  
- Butona basıldığında LED’in yanması, bırakıldığında sönmesi.  

### 2.2. Giriş–Çıkış İlişkisi

Basit tablo:

```text
Buton  |  LED
0      |  0
1      |  1
```

- Giriş: `digitalRead(BUTTON_PIN)`  
- Çıkış: `digitalWrite(LED_PIN, HIGH/LOW)`  
- Kural: `LED = BUTON`

### 2.3. Gömülü Döngü Açısından Bakış

`loop()` seviyesinde düşünce:

- Her döngüde butonun mevcut durumu okunur.  
- Buton durumuna göre LED’in yeni durumu belirlenir.  
- Gerekirse, butondaki hızlı salınımları filtrelemek için basit “debounce” mantığı eklenir.  

Bu uygulama, dijital giriş ve çıkış arasındaki en temel ilişkiyi kurar.

---

## 3. Uygulama 2 – PWM ile LED Parlaklık Kontrolü

### 3.1. Devre Fikri

- LED, PWM destekli bir dijital pine (örneğin `D9`) seri direnç ile bağlanır.  
- GND hattı ortak referans olarak kullanılır.  

Amaç:  
- LED’in parlaklığını zaman içinde yavaşça artırıp azaltmak (nefes efekti veya fade).  

### 3.2. Mantık İskeleti

PWM seviyesini temsil eden bir değişken (örneğin 0–255 arası) hayal edin:

- 0 → LED tamamen sönük  
- 255 → LED maksimum parlaklık  

`loop()` içinde:

1. PWM değeri belirli bir adımda artırılır.  
2. Belirli bir eşik aşıldığında (255), yön ters çevrilir ve PWM değeri azaltılmaya başlanır.  
3. Her adımda `analogWrite(LED_PIN, pwmDeger);` ile çıkış güncellenir.  

Bu yapı, zaman içinde sürekli tekrarlanan bir parlaklık dalgası oluşturur.

### 3.3. Gömülü Düşünceyle İlişki

- LED parlaklığı, aslında analog bir etkiyi (ışık şiddeti) dijital PWM ile üretmenin örneğidir.  
- Sonsuz döngüde, sadece küçük adımlarla duty cycle değiştirilir; geri kalan her şey aynı kalır.  

---

## 4. Uygulama 3 – Potansiyometre ile Analog Okuma + PWM Çıkış

### 4.1. Devre Fikri

- Potansiyometre uçları 5 V ve GND’ye, orta ucu ise A0 gibi bir analog giriş pinine bağlanır.  
- LED, önceki uygulamada olduğu gibi PWM destekli bir dijital pine seri direnç ile bağlanır.  

Amaç:  
- Potansiyometreyi çevirerek LED’in parlaklığını gerçek zamanlı kontrol etmek.  

### 4.2. Sinyal Zinciri

Zincir şu şekilde özetlenebilir:

```text
Potansiyometre (Analog) → ADC (0–1023) → Ölçekleme (0–255) → PWM (LED)
```

Adımlar:

1. `analogRead(A0)` ile 0–1023 aralığında bir değer okunur.  
2. Bu değer, `map(...)` benzeri bir fonksiyonla 0–255 aralığına ölçeklenir.  
3. Ölçeklenen değer, `analogWrite(LED_PIN, pwmDeger);` ile uygulanır.  

### 4.3. Kavramsal Kazanım

- Analog bir girişin dijital temsilini kullanarak oransal bir çıkış üretme fikri pekişir.  
- ADC çözünürlüğü, PWM çözünürlüğü ve gözün algısı arasındaki ilişki sezgisel hale gelir.

---

## 5. Uygulama 4 – Sensör → Karar → Aktüatör Çerçevesi

Bu bölümde detaylı bir devre/kod anlatımı yerine, birçok gerçek projeye uyarlanabilecek bir şablon çerçevesi sunulur.

### 5.1. Genel Şablon

Herhangi bir gömülü uygulama şu dört katmanda düşünülebilir:

1. **Sensör**: Gerçek dünyadan analog veya dijital veri alır.  
2. **Dönüştürme**: ADC veya sayısal giriş üzerinden veriyi uygun formata çevirir.  
3. **Karar/Algoritma**: Eşikler, durum makineleri, basit kurallar veya daha gelişmiş algoritmalar.  
4. **Aktüatör**: LED, motor, röle, ses vb. ile kararı dış dünyaya yansıtır.  

### 5.2. Örnek Senaryo – Basit Sıcaklık Fan Kontrolü

- Sensör: Analog sıcaklık sensörü (NTC veya lineer sensör).  
- Dönüştürme: ADC ile 0–1023 okuma, sıcaklık skalasına dönüştürme.  
- Karar:  
  - Sıcaklık belirli eşiğin altında → fan kapalı.  
  - Eşiğin biraz üstünde → fan düşük hız.  
  - Çok üstünde → fan yüksek hız.  
- Aktüatör: PWM ile MOSFET üzerinden fan motoru.  

Bu yapı, çok farklı uygulamalara (ışık kontrolü, seviye kontrolü, güvenlik uygulamaları) doğrudan uyarlanabilir.

---

## 6. Uygulama Tasarlarken Genel Prensipler

- **Basit başla, genişlet**: Önce tek LED veya tek sensörle çalışan küçük bir iskelet kurup sonra özellik eklemek, karmaşık bir sistemi tek seferde yazmaktan daha güvenilirdir.  
- **Her katmanı ayrı düşün**: Donanım (devre), okuma (ADC/dijital giriş), işleme (karar), çıkış (PWM/dijital çıkış) katmanlarını zihinde ayırmak, hata ayıklamayı kolaylaştırır.  
- **Ölç, sonra yorumla**: Seri monitör veya benzeri araçlarla ara değerleri (ADC okumaları, hesaplanmış PWM değerleri) görmek, “neden böyle davrandı?” sorusunun cevabını bulunabilir kılar.  
- **Kaynakları gözle**: Delay, bellek kullanımı ve gereksiz tekrar hesaplamalar gibi noktalar, gömülü sistemlerde ileride sorun çıkarma potansiyeli taşır.  

---

## 7. Kavram Soruları ve Senaryo Problemleri

Bu konuya ait sorular `4S- Arduino ile Uygulamalar Sorular.md`, ayrıntılı çözümler ise `4C- Arduino ile Uygulamalar Çözümler.md` dosyasında yer alır.

