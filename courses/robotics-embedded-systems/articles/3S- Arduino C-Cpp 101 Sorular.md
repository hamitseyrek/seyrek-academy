# 3S – Arduino C/C++ 101: Soru Seti

Bu dosya, `3- Arduino’ya Giriş.md` içeriğini derinleştirmek için hazırlanmış ek çalışma sorularını içerir. Sorular, dil kurallarını gerçekçi küçük durumlar ve sık kullanılan Arduino örnekleri üzerinden yeniden düşünmeyi hedefler. Çözümler `3C- Arduino C/C++ 101: Çözümler ve Açıklamalar` dosyasındadır.

---

## Bölüm 1 – Veri Tipleri ve Operatörler

**S41 – Değişken Günlüğü**  
Arduino’da bir sensörün son durumunu ve en yüksek okumasını tutmak istiyorsunuz:  
- Şu alanlar için hangi veri tiplerini seçerdiniz ve neden?  
  - `sonOkuma` (ADC değeri, 0–1023)  
  - `maksimumOkuma` (ADC değeri, 0–1023)  
  - `sensorAktif` (sensör devrede mi değil mi?)  
  - `kalibrasyonKatsayisi` (ondalıklı çarpan, örn. 1.23)  

**S42 – Operatör Bulmacası**  
Bir değişken için aşağıdaki ifadelerin ne yaptığını sözel olarak açıklayın:  
- `hiz = hiz + 10;`  
- `hiz += 10;`  
- `sayac++;`  
- `if (sayi % 2 == 0)`  

**S43 – Karşılaştırma Hikâyesi**  
Şu durumu sözlü ifade edin:  
- `if (sicaklik > 25 && sicaklik < 30)`  
- `if (butonDurumu == HIGH || acilDurum == true)`  
Hangi gerçek dünya senaryosuna benzetilebilirler? (örneğin klima kontrolü, acil durdurma butonu vb.)

---

## Bölüm 2 – Koşullar ve Döngüler

**S44 – Üç Bölge, Tek Değişken**  
`sicaklik` değişkenine göre üç durum tanımlayın:  
- 20’nin altı → “soğuk”  
- 20–25 arası → “konfor”  
- 25 üstü → “sıcak”  
Bu üç durumu belirlemek için nasıl bir `if / else if / else` yapısı kurardınız? (sözel ifade)  

**S45 – Sayaçla LED Saydırma**  
0’dan 9’a kadar sayıları seri porta yazmak için `for` yerine `while` döngüsü kullanırsanız, sayaç değişkenini nasıl başlatır, nasıl günceller ve hangi koşulla döngüden çıkarsınız?  

**S46 – Döngüde Gizli Hata**  
Aşağıdaki sözel tanıma göre neyin yanlış olabileceğini tartışın:  
- “Bir `while` döngüsü içinde `i` değişkenini artırmayı unuttum.”  
Bu durum, gömülü bir sistemde nasıl bir davranışa yol açabilir?

---

## Bölüm 3 – Fonksiyonlar ve Kapsam

**S47 – Fonksiyon Tasarlama Oyunu**  
ADC’den gelen değeri Volt cinsine çeviren bir fonksiyon hayal edin:  
- Giriş parametresi ne olmalı?  
- Çıkış (dönüş değeri) hangi tipte olmalı?  
- Fonksiyonun ismini ve sözel imzasını (örneğin “ADC değeri alır, Volt döndürür”) tanımlayın.  

**S48 – Global mi Yerel mi?**  
Aşağıdaki değişkenler için **global** mi yoksa **fonksiyon içinde yerel** mi tanımlamanın daha mantıklı olduğunu tartışın ve nedenini yazın:  
- ADC eşik değeri  
- En son okunan sensör değeri  
- Seri port üzerinden bir defaya mahsus gösterilecek başlangıç mesajı  

**S49 – Yardımcı Fonksiyonlara Bölmek**  
Bir projede şu adımlar var: sensör oku → ölçekle → eşik kontrolü yap → LED güncelle.  
Bu adımları tek bir uzun `loop()` içinde yazmak yerine, hangi iki–üç yardımcı fonksiyona bölebilirsiniz? Fonksiyonların isimlerini ve kabaca görevlerini tanımlayın.

---

## Bölüm 4 – Diziler ve Küçük Senaryolar

**S50 – Ölçüm Serisi**  
10 elemanlı bir `readings` dizisinde son 10 sensör okumasını tutuyorsunuz:  
- Yeni bir okuma geldiğinde diziyi nasıl güncellersiniz? (Öneri: en eski değeri düşürüp en yeni değeri eklemek.)  
- Bu yapıyı, “hareketli ortalama” fikriyle nasıl ilişkilendirebilirsiniz?  

**S51 – LED Dizisi ile Yürüyen Işık**  
`int ledPins[4] = {2, 3, 4, 5};` şeklinde bir dizi düşünün.  
- “Yürüyen ışık” (sırasıyla LED1, LED2, LED3, LED4 yanıyor) efektini üretmek için dizi ve `for` döngüsünü nasıl kullanırdınız? Mantığı sözel olarak açıklayın.  

**S52 – Dizide Minimum Değeri Bulmak**  
`int readings[10]` içindeki en küçük değeri bulmak için:  
- Hangi değişkenlerle başlarsınız?  
- `for` döngüsü içinde hangi koşulla mevcut minimumu güncellersiniz?  

---

## Bölüm 5 – Yaratıcı Mini Senaryolar

**S53 – Sanal Termostat Kararı**  
Bir `float` türünde `sicaklik` değişkeniniz var. Aşağıdaki davranışı C/C++ koşullarıyla nasıl tarif ederdiniz (sözel):  
- 18°C altındaysa: “Isıtıcıyı aç”  
- 18–24°C arası: “Hiçbir şey yapma”  
- 24°C üstündeyse: “Soğutucuyu aç”  

**S54 – Zamanlanmış Mesaj**  
Her 100. döngüde bir, seri porta “sistem çalışıyor” mesajını yazmak istiyorsunuz:  
- Hangi değişkeni hangi başlangıç değeriyle tanımlarsınız?  
- Hangi aritmetik veya mod operatörünü kullanarak 100’ün katlarını tespit edersiniz?  

**S55 – Basit Menü Fikri**  
Bir `int komut` değişkeni var ve 1, 2, 3 değerleri için farklı fonksiyonlar çalıştırmak istiyorsunuz (`start()`, `stop()`, `reset()` gibi).  
- Bu durumu `if/else` yapısı ile mi, yoksa `switch-case` ile mi ifade etmeyi tercih ederdiniz? Nedenini yazın.  

---

## Not

Bu soru seti, dil yapılarının üzerine düşünmeyi amaçlar; çözümler doğrudan kod yerine çoğunlukla **mantık ve tasarım düşüncesi** üzerinden verilmiştir. Ayrıntılı cevaplar ve örnek taslaklar için `3C- Arduino C/C++ 101: Çözümler ve Açıklamalar.md` dosyasına bakılabilir.

