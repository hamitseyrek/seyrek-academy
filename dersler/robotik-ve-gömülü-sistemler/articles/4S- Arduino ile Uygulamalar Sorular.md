# 4S – Arduino ile Uygulamalar: Sorular

Bu dosya, `4- Arduino ile Uygulamalar.md` konusuna ait kavram soruları ve senaryo problemlerini içerir.

---

## S1 – “Butona basılı kaldığı sürece LED yansın” ile “Butona her basıldığında LED durumunu değiştir (toggle)” arasındaki farkı giriş–çıkış davranışı açısından açıklayın.

---

## S2 – PWM kullanarak LED üzerinde en az üç farklı görsel efekt fikri yazın (örneğin nefes alma, yavaş açılıp kapanma, ikili ritim vb.). Her birinin mantığını bir-iki cümleyle özetleyin.

---

## S3 – Potansiyometreden gelen değere göre LED'i bir eşiğin üstünde yakıp altında söndürürken, eşik etrafında sürekli yanıp sönmeyi engellemek için nasıl bir histerezis (üst ve alt eşik) kurgulayabilirsiniz? Sözel olarak açıklayın.

---

## S4 – Üç LED'li bir sistemde, potansiyometre düşükken sadece ilk LED, orta değerlerde iki LED, yüksek değerlerde üç LED'in yanması için bir eşiklendirme stratejisi tasarlayın (sözel, gerekirse tabloyla).

---

## S5 – Bir uygulama beklediğiniz gibi çalışmadığında, seri monitörü nasıl kullanarak problemi daraltabileceğinize dair adım adım bir strateji yazın.

---

## S6 – 0-1023 aralığındaki bir ADC okumasını 0-255 PWM aralığına eşleyen doğrusal ilişkiyi (formül veya mantık) sözel olarak ifade edin.

---

## S7 – "LED'in 1 saniye yanık, 1 saniye sönük kalması" isteniyorsa, `loop()` içinde hangi zamanlama mantığına ihtiyaç duyulur (yalnızca sözel açıklama)?

---

## S8 – Aynı anda hem LED efektleri üretmek hem de buton girişlerini kaçırmadan okumak istiyorsunuz. Sadece `delay()` tabanlı bir tasarımın neden yetersiz olduğunu ve bunun yerine nasıl bir zaman yönetimi yaklaşımı tercih edilmesi gerektiğini açıklayın.

---

## S9 – Potansiyometre yerine gürültülü bir sensör bağlandığında LED parlaklığının sürekli hafif titreştiğini fark ediyorsunuz. Bunu basit kod tarafı çözümleriyle nasıl yumuşatabileceğinizi (örneğin hareketli ortalama, eşik filtreleme) örnekleyin.

---

## S10 – Bir uygulamada, her 100 ms'de bir sensör okuması, her 1 saniyede bir seri çıktı, her 5 saniyede bir de özel bir kontrol yapılması isteniyor. Tüm bunları `loop()` içinde, `delay()` kullanmadan zaman damgaları (örneğin `millis()`) ile nasıl organize edebileceğinizi sözel olarak açıklayın.

