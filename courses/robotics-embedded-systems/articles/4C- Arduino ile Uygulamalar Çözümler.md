# 4C – Arduino ile Uygulamalar: Çözümler ve Açıklamalar

Bu dosya, `4S- Arduino ile Uygulamalar Sorular.md` içindeki **S1-S10** numaralı sorular için özet çözümler içerir.

---

## S1 – Butonlu LED Uygulamasında Edge vs Level

**1.1)**  
- “Butona basılı kaldığı sürece LED yansın” → **seviye (level)** tabanlı davranıştır; döngüde sürekli butonun anlık durumu okunur ve doğrudan LED çıkışına yansıtılır (`LED = BUTON`).  
- “Butona her basıldığında LED durumunu değiştir” → **kenar (edge)** tabanlı davranıştır; butonun önceki durumu ile şimdiki durumu karşılaştırılır, sadece `0 → 1` geçişinde (yükselen kenar) LED durumu terslenir (toggle).  

---

## S2 – PWM ile LED Efektleri

**2.1) Örnek efektler**  
- Nefes alma (breathing): PWM değeri yavaşça artar ve azalır; insan nefesine benzer bir parlaklık dalgası oluşturur.  
- Yavaş açılıp kapanma: Bir süre sabit yanar, sonra PWM kademeli olarak sıfıra indirilir; tekrar kademeli olarak artırılır.  
- İkili ritim: İki farklı duty ve süre kombinasyonu ile “kısa–uzun” yanıp sönme deseni oluşturulur (örneğin SOS benzeri bir desen).  

---

## S3 – Potansiyometre ile Histerezis

**3.1)**  
- Tek bir eşik kullanmak yerine iki eşik tanımlanır:  
  - Üst eşik: LED’i yakmak için gereken seviye.  
  - Alt eşik: LED’i söndürmek için gereken seviye.  
- Pot değeri üst eşiği geçtiğinde LED yanar; değer alt eşiğin altına düşene kadar LED yanık kalır. Böylece küçük salınımlar, LED’in sürekli yanıp sönmesine yol açmaz.  

---

## S4 – Çoklu LED Dizisi

**4.1) Örnek eşiklendirme**  
- ADC aralığı 0–1023 varsayılır:  
  - 0–341 → Sadece LED1 yanık.  
  - 342–682 → LED1 ve LED2 yanık.  
  - 683–1023 → LED1, LED2 ve LED3 yanık.  

Bu aralıklar, ihtiyaca göre daha ince veya daha kaba bölümlere ayrılabilir.

---

## S5 – Seri Monitör ile Hata Ayıklama

**5.1) Örnek strateji**  
- Önce, `setup()` içinde basit bir “program başladı” mesajı yazdırarak kartın gerçekten çalıştığını kontrol edin.  
- `loop()` içinde, kritik noktalarda (buton okuması, ADC değeri, hesaplanan PWM gibi) ilgili değerleri `Serial.println(...)` ile yazdırın.  
- Elde edilen çıktıyı inceleyerek, hatanın sensör okumasından mı, karar mantığından mı, yoksa çıkış güncellemesinden mi kaynaklandığını ayırt edin.  
- Gereksiz seri çıktıları adım adım azaltarak, sadece sorunun olduğu bölgeye odaklanın.  

---

## S6 – PWM Değerlerinin Haritalanması

**6.1)**  
- 0–1023 → 0–255 için doğrusal eşleme:  

```text
pwm = (adc_değeri × 255) / 1023
```

veya sözel olarak:  
- ADC değeri 0 ise PWM 0, ADC değeri 1023 ise PWM 255; aradaki değerler bu iki nokta arasında doğrusal oranda ölçeklenir.  

---

## S7 – Zamanlama ve Gözle Görülen Davranış

**7.1)**  
- Zamanın geçtiği bir referans tutulur (örneğin son değişim anı).  
- `loop()` içinde mevcut zaman (`millis()`) ile son değişim anı karşılaştırılır.  
- Fark 1000 ms (1 saniye) veya daha büyükse LED durumu terslenir (yanıksa söner, sönükse yanar) ve son değişim anı güncellenir.  
- Böylece LED’in yanık kalma ve sönük kalma süreleri yaklaşık 1 saniye olur.  

---

## S8 – Çoklu Görev İhtiyacı

**8.1)**  
- Uzun `delay()` çağrıları sırasında `loop()` çalışmadığı için buton/ sensör gibi olaylar kaçırılabilir; sistem tek iş yapıyormuş gibi davranır.  
- Bunun yerine, her görevin kendi zaman damgasına göre ne zaman çalışması gerektiğini kontrol eden bir yapı (örneğin `millis()` ile karşılaştırmalar) kullanılmalıdır.  
- Böylece aynı `loop()` içinde kısa, hızlı kontroller (buton okuma) ve daha seyrek işler (seri çıktı, yavaş güncellemeler) birlikte yönetilebilir.  

---

## S9 – Sensör Gürültüsü ve LED Çıkışı

**9.1)**  
- Hareketli ortalama: PWM değerini hesaplamadan önce son N ADC okumasının ortalamasını alarak ani sıçramaları yumuşatmak.  
- Eşik filtreleme: Belirli bir küçük aralık (örneğin ±2–3 değer) içindeki değişimleri görmezden gelmek; sadece anlamlı farklarda PWM değerini güncellemek.  
- Güncelleme hızını sınırlamak: PWM değerini her okuma yerine belirli aralıklarla (örneğin her 100 ms) güncellemek.  

---

## S10 – Göreli Zamanlama

**10.1)**  
- Her görev için ayrı bir “son çalışma zamanı” değişkeni tutulur (`sonSensörZamanı`, `sonSeriZamanı`, `sonKontrolZamanı`).  
- `loop()` içinde, `millis()` değeri ile bu değişkenler karşılaştırılır:  
  - Eğer `millis() − sonSensörZamanı >= 100 ms` ise sensör okuması yapılır ve `sonSensörZamanı` güncellenir.  
  - Eğer `millis() − sonSeriZamanı >= 1000 ms` ise seri çıktı gönderilir ve `sonSeriZamanı` güncellenir.  
  - Eğer `millis() − sonKontrolZamanı >= 5000 ms` ise özel kontrol yapılır ve `sonKontrolZamanı` güncellenir.  
- Bu sayede, `delay()` kullanmadan, farklı periyotlara sahip görevler tek `loop()` içinde yönetilebilir.  

