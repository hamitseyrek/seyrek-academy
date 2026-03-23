# Görselleştirme: Matplotlib ve Seaborn ile EDA

4. dosyadaki `df` üzerinden (CSV okuma, eksik değer doldurma, türetilmiş sütunlar, özet istatistikler) grafiklerle devam etmek en doğal akıştır. Grafiklerin amacı burada “süs” değil; dağılımı, karşılaştırmayı ve ilişkileri **okuyup yorumlamak**tır.

---

## Matplotlib ve seaborn nedir?

Bu dosyada iki kütüphane birlikte kullanılır:

- `matplotlib.pyplot` (`plt`): Grafik çizmeyi sağlayan temel motor. `plt.figure`, `plt.title`, `plt.xlabel`, `plt.ylabel`, `plt.show` gibi komutlar genellikle burada olur.
- `seaborn` (`sns`): Dağılım ve istatistik odaklı, daha yüksek seviye grafikler sunar. Örneğin `sns.histplot`, `sns.boxplot`, `sns.scatterplot`, `sns.barplot` gibi fonksiyonlar seaborn tarafındadır.

Bu nedenle genelde şu desen görülür:

1. `plt.figure(...)` ile tuvali/figürü ayarla
2. `sns.*plot(...)` ile grafiği çiz
3. `plt.title/labels` ile metinleri ekle
4. `plt.show()` ile çıktıyı ekranda göster

---

## 2. Görselleştirme başlangıcı: import ve temel not

`df` değişkeni bu dosyada yeniden kurulabilir ya da 4. dosyadaki kod çalıştırılarak elde edilebilir. Bu makalede `df` hazır kabul edilmiştir.

```python
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
```

Bu kısaltmaların anlamı:
- `numpy` (`np`): sayısal hesaplar ve `np.mean` gibi özet fonksiyonlar için
- `matplotlib.pyplot` (`plt`): figür ve eksen metinleri için
- `seaborn` (`sns`): istatistik odaklı grafik fonksiyonları için

Grafiklerin görünmesi için çoğu zaman en sonda `plt.show()` çağrısı gerekir.

---

## 3. Histogram: kalite skoru dağılımını okumak

Histogram, bir sayısal değişkenin hangi aralıklarda yoğunlaştığını gösterir.

Koddaki ana parçalar:

- `plt.figure(figsize=(...))`: grafiğin boyutunu ayarlar.
- `sns.histplot(..., bins=10)`: değerleri 10 parçaya (aralığa) bölüp frekans/yoğunluk çizer.
- `kde=True`: histogramun üstüne yaklaşık bir “yoğunluk eğrisi” ekler (böylece dağılım daha yumuşak görülür).
- `plt.title/plt.xlabel/plt.ylabel`: başlık ve eksen etiketleri.
- `plt.show()`: grafiği ekranda gösterir.

```python
plt.figure(figsize=(8, 4))
sns.histplot(df["quality_score"], bins=10, kde=True)
plt.title("Kalite Skoru Dağılımı")
plt.xlabel("Kalite Skoru")
plt.ylabel("Frekans")
plt.show()
```

Yorum ipuçları:

- Dağılım tek tepe mi, iki tepe mi?
- Sağ/sol kuyruğa doğru uzama var mı?
- Notlar hangi aralıkta daha yoğun?

---

## 4. Boxplot: hatlar arasında karşılaştırma

Boxplot, gruplar arasında dağılımı hızlıca kıyaslamak için çok kullanışlıdır. Temel parçaları:

- Kutu: alt çeyrek (Q1) ile üst çeyrek (Q3) arasını gösterir.
- İçteki çizgi: medyandır.
- Bıyıklar: tipik aralığı temsil eder.
- Nokta/ayrı değerler: aykırı değer sinyali verebilir.

```python
plt.figure(figsize=(8, 4))
sns.boxplot(data=df, x="line", y="quality_score")
plt.title("Hat Bazında Kalite Skoru Dağılımı")
plt.show()
```

Yorum ipuçları:

- Hangi hatta medyan daha yüksek?
- Kutu genişliği fazla mı (dağılım geniş mi)?
- Aykırı değerler var mı?

---

## 5. Scatter: çalışma süresi ve kalite skoru ilişkisinin sinyali

Scatter grafiği iki sayısal değişkenin “birlikte nasıl değiştiğini” gösterir.

Koddaki kritik parametreler:

- `x`: yatay eksende gösterilecek değişken (`runtime_hours`)
- `y`: dikey eksende gösterilecek değişken (`quality_score`)
- `hue="line"`: noktaları hatlara göre renkler (karşılaştırmayı kolaylaştırır)

```python
plt.figure(figsize=(8, 5))
sns.scatterplot(
    data=df,
    x="runtime_hours",
    y="quality_score",
    hue="line",
)
plt.title("Çalışma Süresi ve Kalite Skoru İlişkisi")
plt.show()
```

Önemli not:

- Scatter, ilişki sinyali verir. Bu tek başına “neden-sonuç kanıtı” değildir.

---

## 6. Barplot: çalışma seviyesine göre özet karşılaştırma

Barplot, her kategori için bir özet istatistiği çizmenin hızlı yoludur. Burada kullanılanlar:

- `x="operation_level"`: kategoriler
- `y="quality_score"`: özetlenecek sayısal değişken
- `estimator=np.mean`: her kategori için ortalamayı al
- `errorbar=None`: hata çubuğunu kapat (özellikle yorum yükünü azaltmak için)

```python
plt.figure(figsize=(8, 4))
sns.barplot(
    data=df,
    x="operation_level",
    y="quality_score",
    estimator=np.mean,
    errorbar=None,
)
plt.title("Çalışma Seviyesine Göre Ortalama Kalite Skoru")
plt.show()
```

Sık yapılan hata:

- “Bar yükseklikleri farklı, o zaman kesin fark var” demek yerine, dağılımı görmek için boxplot ile birlikte değerlendirmek daha doğru olur.

---

## 7. Risk grubu özeti: bar grafik

4. dosyada şu değişkenler hazır olmalıdır:

- `risk_group`: her satır için risk etiketi
- `risk_ort`: `risk_group` bazında ortalama kalite skoru

Grafiğin amacı: grupların ortalama puanlarını tek bakışta kıyaslamak.

```python
plt.figure(figsize=(7, 4))
sns.barplot(data=risk_ort, x="risk_group", y="quality_score")
plt.title("Risk Grubuna Göre Ortalama Kalite Skoru")
plt.xlabel("Risk Grubu")
plt.ylabel("Ortalama Kalite Skoru")
plt.show()
```

---

## 8. Sık karşılaşılan hatalar ve hızlı çözümler

### 8.1. `FileNotFoundError`

- Dosya yolunu kontrol edin (`data/...` doğru mu?).
- Notebook konumu ile göreli yol uyumlu mu?

### 8.2. `NameError: name 'df' is not defined`

- `df = pd.read_csv(...)` satırı çalıştırılmadan aşağıdaki işlemlere geçilmiş olabilir.
- En üstten tekrar çalıştırmak çoğu zaman sorunu çözer.

### 8.3. `KeyError: 'quality_score'` benzeri sütun adı hataları

Grafikte kullandığınız kolon adları yanlış yazılmış olabilir.

```python
print(df.columns)
```

Doğru sütun adını kullanın (büyük/küçük harf farkı dahil).

### 8.4. Grafik görünmüyor

- İlgili hücre gerçekten çalıştı mı?
- Kodun sonunda `plt.show()` var mı?

 

