# Veri Tipleri ve Veri Analizi

Bu doküman, elinizdeki veriye bakarak “ne ölçtük, hangi sütun neyi temsil ediyor ve hangi analiz soruları anlamlı?” sorularını kurmayı öğretmek için hazırlanmış bir referans notudur. Özellikle robotik/sensör dünyasında sık karşılaşılan ölçüm kayıtlarından hareketle, veri tiplerini ve değişken rollerini netleştirir; doğrusal modelleme fikrine sağlam bir zemin oluşturur.

---

## 1. Veri mi? Gözlem mi? Değişken mi?

Veri kavramı tek başına “sayılardan oluşan bir dosya” gibi görünse de, aslında anlamı bağlama göre ortaya çıkar. Bu nedenle önce dört temel terimi oturtmak gerekir:

- **Veri**: İncelediğiniz olguya ait sayısal veya kategorik kayıtların bütünü.
- **Gözlem (kayıt)**: Veri setinde bir satır; tek bir birime ait ölçümü/etiketi temsil eder.
- **Değişken (özellik)**: Veri setinde bir sütun; her gözlem için aynı türden bilgiyi taşır.
- **Ölçüm**: Bir değişken için verilen tek bir değer.

Önemli ipucu: Aynı dosya farklı sorulara göre farklı anlam kazanabilir. Bu yüzden “satır birimleri” ile “sütunların rolleri” her zaman birlikte düşünülür.

---

## 2. Nitel mi Nicel mi? Sürekli mi Kesikli mi?

Veriyi sınıflandırmanın amacı, hangi tür işlemlerin (toplama/ortalama gibi) gerçekten anlamlı olacağını önceden tahmin edebilmektir. En sık kullanılan iki eksen şunlardır:

### 2.1. Nitel (kategorik) veri

Sayıyla ifade edilse bile, kategori anlamı taşıyorsa nitel sayılır. Bu tür veride aritmetik işlemler her zaman anlamlı değildir.

Örnekler:

- Engel durumu: “Evet / Hayır”
- Renk: “Kırmızı / Yeşil / Mavi”
- Hata kodu: “A1 / B2 / C3”

### 2.2. Nicel (sayısal) veri

Nicel veride sayılarla yapılan işlemler genellikle anlamlıdır.

Örnekler:

- Mesafe (cm)
- Motor hızı (rpm)
- Sıcaklık (°C)

### 2.3. Sürekli veri

Teorik olarak iki değer arasında “ara değerlerin tamamını” kapsar gibi düşünülür.

Örnek: Sıcaklık, mesafe, zaman.

### 2.4. Kesikli veri

Belirli adımlarla artar ve pratikte sayılabilir değerler alır.

Örnek: Robot kolunun parça sayısı, hata sayısı, müşteri sayısı.

---

## 3. Bağımlı ve Bağımsız Değişken: Modelleme Zemini

Doğrusal modelleme fikri basit bir cümleye dönüşebilir:

> “Bir çıktıyı açıklamak/öngörmek istiyorum; bununla ilişkili olabileceğini düşündüğüm girdiler var.”

Bu durumda:

- **Bağımlı değişken (çıktı)**: Tahmin etmeye veya açıklamaya çalıştığınız değişken.
- **Bağımsız değişken (girdi)**: Çıktıyı etkileyebileceğini düşündüğünüz değişkenler.

Bir regresyon deneyi yapmadan önce, elinizdeki dosyada bu rolleri etiketlemek gerekir. Çünkü hangi sütunun “çıktı” olacağı, modelin hedefini belirler; hangi sütunların “girdi” olacağı ise modelin yapısını şekillendirir.

---

## 4. Tek Veri Seti Üzerinden Düşünme (Robot Örneği)

Aşağıdaki gibi bir tablo düşünün:

| Gözlem | Robot ID | Görev Türü    | Engel Mesafesi (cm) | Robot Hızı (m/s) | Durma Süresi (ms) |
|-------:|-----------|---------------|---------------------:|-------------------:|-------------------:|
| 1      | 1         | Taşıma        | 80                  | 1.2                | 600                |
| 2      | 1         | Taşıma        | 50                  | 1.2                | 750                |
| 3      | 2         | Denetim       | 100                 | 0.8                | 550                |
| 4      | 2         | Denetim       | 40                  | 1.0                | 820                |
| 5      | 3         | Montaj        | 120                 | 0.6                | 500                |

Bu tablo üzerinde kendinize şu soruları sorun:

- “Her satır neyi temsil ediyor?”  
  → Her satır bir **zaman anındaki robot durumu** gibi düşünülebilir.
- “Sütunlardan hangileri değişken?”  
  → `Robot ID`, `Görev Türü`, `Engel Mesafesi`, `Robot Hızı`, `Durma Süresi`.
- “Model kurulursa hangisi çıktı olur?”  
  → Genellikle `Durma Süresi` bağımlı değişkendir.
- “Çıktıyı etkileyebilecek girdiler hangileri?”  
  → Çoğunlukla `Engel Mesafesi` ve `Robot Hızı` bağımsız değişken adaylarıdır.
- “Kimlik sütunu var mı?”  
  → `Robot ID` model hedefi için “kimlik” olabilir; çoğu durumda doğrudan çıktı/açıklayıcı rolünde kullanılmaz.

Benzer bir etiketleme özeti:

| Değişken             | Veri Tipi (nitel/nicel) | Alt tip (sürekli/kesikli) | Rol (bağımlı/bağımsız/kimlik) |
|----------------------|-------------------------|----------------------------|--------------------------------|
| Robot ID             | —                       | —                          | Kimlik                          |
| Görev Türü           | Nitel                   | Kategorik                  | Genelde bağımsız (kategori)    |
| Engel Mesafesi (cm)  | Nicel                   | Sürekli                     | Bağımsız                         |
| Robot Hızı (m/s)     | Nicel                   | Kesikli (pratikte)         | Bağımsız                         |
| Durma Süresi (ms)    | Nicel                   | Kesikli/sürekli (bağlama bağlı) | Bağımlı                  |

---

## 5. Veriyi İlk Kez Açarken: “Ne Var?” Kontrolü

Bir veri setiyle çalışmaya başlarken amaç “hemen model kurmak” değil; önce tabloyu tanımaktır. İki pratik yol:

### 5.1. Excel’de hızlı kontrol

- Sütun başlıklarını gözden geçirin.
- Filtre/çeşitleme ile belirli bir `Görev Türü`ne göre satırların nasıl dağıldığına bakın.
- Eksik değer var mı, değer aralıkları makul mi kontrol edin.

### 5.2. Python’da hızlı kontrol (pandas)

Bu tarz bir dosya için tipik akış:

```python
import pandas as pd

df = pd.read_csv("robot_durma_suresi.csv")  # dosya adına göre düzenleyin

print(df.head())           # ilk satırlar
print(df.dtypes)          # sütun tipleri
print(df.columns.tolist())
```

Bu üç çıktıyla birlikte şu fikri akılda tutun:

- Satır = gözlem birimi
- Sütun = değişken
- `dtypes` = veri tipleri (nitel/nicel ayrımına ilk sinyal)

---

## 6. Veriden Analiz Sorusu Üretmek

Veri analizi, “veriyi okuyup soru sormak” ile başlar. Aynı tablo üzerinden farklı sorular türetmek mümkündür:

- `Engel Mesafesi` azaldıkça `Durma Süresi` artıyor mu?
- `Görev Türü` bazında `Durma Süresi` ortalaması değişiyor mu?
- `Robot Hızı` yüksek olduğunda durma süresi daha uzun mu?

Burada kritik nokta şudur: Sorunuzun içinde “çıktı” kelimeleri (tahmin, değişim, fark) bir bağımlı değişken seçtirir; “neden/neyle” tarafı da bağımsız değişkenleri çağırır.

---

## 7. Mini Alıştırma (Kısa)

Elinizdeki küçük bir CSV/Excel tabloyu düşünün. Şunları yazılı olarak netleştirin:

- En az 1 bağımlı değişken adayı (neden çıktıdır?).
- En az 2 bağımsız değişken adayı (neden adaydır?).
- Her değişken için nitel/nicel ve mümkünse sürekli/kesikli sınıflaması.

Sonuçta, elinizde bir “modelleme haritası” oluşur: hangi sütun ne işe yarayacak?

---

## Kapanış: Neden Bu Sıralama?

Veri tiplerini ve değişken rollerini doğru etiketlemek, sonraki adımlarda (görselleştirme, model kurma, değerlendirme) hem hataları azaltır hem de “neden bu analizi seçtik?” sorusuna net cevap vermeyi sağlar.

