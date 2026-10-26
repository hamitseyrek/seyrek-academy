# 3C – Arduino C/C++ 101: Çözümler ve Açıklamalar

Bu dosya, `3S- Arduino C/C++ 101: Soru Seti` içindeki **S1-S10** numaralı sorular için özet çözümler içerir.

---

## S1 – Veri Tipi Seçimi

**1.1) Örnek seçimler**  
- 0’dan 100’e kadar sayan döngü değişkeni → `int`  
  - Değer aralığı küçük, tam sayı; `int` yeterlidir.  
- 0–255 arası parlaklık değeri → `byte` veya `uint8_t`  
  - Doğrudan 0–255 aralığı; tek baytlık tip bellek ve anlam açısından uygundur.  
- `sensör aktif mi?` bilgisi → `bool`  
  - İki durum (true/false); mantıksal tip en uygunudur.  
- Ondalıklı sıcaklık (23.5 gibi) → `float`  
  - Kayan noktalı temsil gerektirir; tam sayılar yeterli olmaz.  

---

## S2 – Operatörler ve Koşullar

**2.1)**  
- `if (x > 10 && x < 20)` → `x` değeri **10’dan büyük ve 20’den küçük** olduğu sürece koşul true olur (örneğin 11–19 arası değerler).  

**2.2)**  
- `if (y == 0 || y == 255)` → `y` değeri **0 ya da 255** olduğunda koşul true olur; diğer tüm değerlerde false.  

---

## S3 – Kapsam (Scope)

**3.1)**  
- Fonksiyon içinde tanımlanan bir değişken yalnızca o fonksiyonun içinde görünür; fonksiyon bittiğinde bellekten silinir (yerel değişken).  
- Global (dosya başında tanımlanan) değişkenler tüm fonksiyonlardan erişilebilir; farklı fonksiyonların aynı değişken üzerinden haberleşmesine izin verir, fakat kontrol edilmezse beklenmedik yan etkilere de yol açabilir.  

---

## S4 – Döngü Kullanımı

**4.1) Örnek tasvir**  
- Bir sayaç değişkeni `i` 0’dan başlatılır.  
- Koşul kısmında `i < 10` olduğu sürece döngünün devam etmesi belirtilir.  
- Her iterasyonda `i` bir artırılır (`i++`).  
- Döngü gövdesinde, mevcut `i` değeriyle “0 1 2 … 9” şeklinde çıktı üretilecek işlemler yapılır (örneğin seri porta yazdırma).  

---

## S5 – Fonksiyon Amacı

**5.1) Örnek gerekçeler**  
- Tekrarlanan kodu tek yere toplar; değişiklik gerektiğinde yalnızca fonksiyonun içi güncellenir.  
- Okunabilirliği artırır; karmaşık işlemleri isimlendirilmiş bloklar (örneğin `hesaplaSicaklik()`) olarak görmek, kodu takip etmeyi kolaylaştırır.  
- Hata ayıklamayı basitleştirir; fonksiyonlar tek tek test edilebilir ve hatanın hangi blokta olduğu daha rahat bulunur.  

---

## S6 – Eşik Kontrol Fonksiyonu Fikri

**6.1) Örnek tasvir**  
- Fonksiyon imzası mantıksal olarak şu şekildedir: “ADC değeri ve eşik değeri alır, boolean döndürür”.  
- İç mantık:  
  - Eğer `adcDegeri > esikDegeri` ise `true` döndür.  
  - Aksi halde `false` döndür.  
- İsimlendirme örneği: `bool esigiGectiMi(int adcDegeri, int esikDegeri)` gibi.  

---

## S7 – Dizide Ortalama Hesabı

**7.1) Örnek adımlar**  
- Bir toplam değişkeni sıfırla (örneğin `toplam = 0`).  
- `for` döngüsü ile indeksleri 0’dan 9’a kadar dolaş.  
- Her adımda `toplam`a `readings[i]` değerini ekle.  
- Döngü bittikten sonra, `toplam`ı eleman sayısına (10) bölerek ortalamayı elde et (`ortalama = toplam / 10`).  

---

## S8 – Çok Koşullu Karar

**8.1) Örnek yapı**  
- Eğer `deger < altEsik` ise → düşük durum.  
- Aksi halde ve `deger < ustEsik` ise → orta durum.  
- Aksi halde (yani `deger >= ustEsik`) → yüksek durum.  

Bu, `if / else if / else` yapısı ile kodlanacak üç durumlu bir karar mekanizmasını sözel olarak ifade eder.

---

## S9 – Sayaç ile Zamanlama

**9.1) Örnek strateji**  
- Global veya statik bir sayaç değişkeni tanımlanır (örneğin `int sayac = 0;`).  
- `loop()` içinde her döngüde sayaç bir artırılır.  
- Eğer `sayac % 100 == 0` ise, yani sayaç 100’ün katına ulaştıysa, seri çıktı tetiklenir.  
- Sayaç çok büyümesin diye gerektiğinde sıfırlanabilir (`sayac = 0;` veya mod alma ile sınırlandırma).  

---

## S10 – Dizi ile LED Dizisi Kontrolü Fikri

**10.1) Örnek açıklama**  
- LED pinleri bir dizide tutulur: `{2, 3, 4}`.  
- Bir `for` döngüsü ile dizinin başından sonuna kadar gidilir.  
- Her iterasyonda, ilgili pin çıkış olarak ayarlanır ve sırayla `HIGH` yapılır (LED yanar), kısa bir gecikmeden sonra `LOW` yapılır (söner).  
- Döngü bittikten sonra, sıra tekrar başa alınarak desen sürekli tekrarlanır.  

Bu yapı, tek bir kod bloğu ile çok sayıda benzer çıkışın kontrol edilmesine imkân verir.  


