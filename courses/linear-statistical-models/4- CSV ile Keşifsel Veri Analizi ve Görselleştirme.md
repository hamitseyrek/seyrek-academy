# CSV ile Keşifsel Veri Analizi ve Görselleştirme

Python temelleri, `pandas` ile veri tabanına dönüşünce bambaşka bir güce ulaşır: veri okuyabilir, temizleyebilir, özetleyebilir ve grafiklerden çıkarım yapabilirsiniz. Bu makale; fonksiyonlar, NumPy ve CSV/`pandas` akışı üzerinden keşifsel veri analizi (EDA) kurar; ardından histogram–boxplot–scatter–barplot gibi grafiklerin nasıl yorumlanacağını pratikleştirir.

---

## İçerik başlıkları

- Fonksiyonlar ve NumPy ile sayısal akış kurmak
- `pandas` ile CSV okuma ve temel kontrol: `shape`, `head`, `info`, `isnull`
- Eksik değer yönetimi (median doldurma)
- Türetilmiş sütunlar: `np.where` ve `apply`
- Sıralama, filtreleme ve `groupby` ile özet istatistik
- Görselleştirme: histogram, boxplot, scatter, barplot
- Grafik okuma rehberi ve sık hatalar
- Mini uygulama: risk grubu üretmek
- Sık karşılaşılan hatalar ve hızlı çözümler
- Bir sonraki adıma geçiş (tahmin fikrine köprü)

---

## 1. Sayısal iskelet: fonksiyonlar ve NumPy

Fonksiyonlar tekrar eden işleri tek bir isim altında toplar. Örneğin ortalama hesabını bir fonksiyon haline getirmek, sonraki adımlarda aynı işlemi veri üzerinde yeniden kullanmayı kolaylaştırır.

```python
def average(numbers):
    total = sum(numbers)
    count = len(numbers)
    return total / count

scores = [60, 70, 80, 90]
average(scores)
```

NumPy ile hızlı dizi tabanlı istatistik:

```python
import numpy as np

scores_array = np.array(scores)
scores_array.mean(), scores_array.std()
```

Basit bir zaman serisi/alışkanlık dizisi:

```python
weekly_hours = np.array([4, 6, 8, 10, 12, 5, 7, 9])

print("Ortalama:", weekly_hours.mean())
print("Standart sapma:", weekly_hours.std())
print("En az:", weekly_hours.min())
print("En çok:", weekly_hours.max())
```

---

## 2. CSV dosyası: tabloyu içeri alma

Bu tür veriyle çalışırken tipik akış şudur:

1. CSV oku
2. İlk bakış (ilk satırlar, sütun adları)
3. Veri tipi ve eksik değer kontrolü
4. Özet istatistik (dağılım hakkında ilk sinyaller)

Örnek okuma:

```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

df = pd.read_csv("data/student_performance.csv")

print(df.head())
print(df.shape)       # (satır, sütun)
print(df.columns)
df.info()
df.describe()
```

Kontrol listesi:

- `shape`: tablonun büyüklüğü (satır/sütun)
- `head()`: değerler beklenen gibi mi?
- `info()`: tipler ve eksik değer sinyali
- `describe()`: sayısal kolonlarda ortalama–std–min–max ve çeyrekler

---

## 3. Eksik değer (missing) yönetimi

Eksik değerler genellikle `NaN` olarak görünür:

```python
df.isnull().sum()
```

Eksik satırları görmek:

```python
df[df.isnull().any(axis=1)]
```

Bu makalede kullanılan basit yaklaşım: sayısal kolonlarda medyanla doldurma.

```python
numeric_columns = [
    "quiz_score",
    "attendance_rate",
    "sleep_hours",
    "steps",
    "project_score",
]

for col in numeric_columns:
    df[col] = df[col].fillna(df[col].median())

df.isnull().sum()
```

Neden medyan?

- Aykırı değerlerden ortalamaya göre daha az etkilenir
- İlk aşama veri temizliğinde daha “güvenli” bir başlangıçtır

---

## 4. Türetilmiş sütunlar: veriyle düşünmek

Keşif analizinde bazen ham kolonlar tek başına yetmez; bazı durumları etiketlemek düşünmeyi hızlandırır.

Örneğin proje notuna göre durum etiketi:

```python
df["success_status"] = np.where(
    df["project_score"] >= 70,
    "High",
    "Needs Improvement",
)

df[["student_id", "project_score", "success_status"]].head()
```

Çalışma seviyesini saatten türetmek için `if` mantığını fonksiyonla paketleyin:

```python
def study_level(hours):
    if hours < 5:
        return "Low"
    elif hours < 10:
        return "Medium"
    else:
        return "High"

df["study_level"] = df["weekly_study_hours"].apply(study_level)
df[["weekly_study_hours", "study_level"]].head()
```

---

## 5. Özet analiz: sıralama, filtre ve `groupby`

Sıralama ve filtreleme, “hangi gruplar daha farklı?” sorusunu somutlaştırır.

En yüksek proje puanları:

```python
df.sort_values("project_score", ascending=False).head(10)
```

Haftalık çalışma saati 10 ve üzeri olanlar:

```python
df[df["weekly_study_hours"] >= 10].head()
```

Hem yüksek proje hem yüksek devam oranı koşulu:

```python
df[
    (df["project_score"] >= 75) & (df["attendance_rate"] >= 85)
].head()
```

Şube bazında ortalamalar (`groupby`):

```python
df.groupby("section")[["quiz_score", "project_score", "attendance_rate"]].mean()
```

Çalışma seviyesi bazında ortalama proje puanı:

```python
df.groupby("study_level")["project_score"].mean().sort_values(ascending=False)
```

Durum dağılımı:

```python
df["success_status"].value_counts()
```

---

## 6. Görselleştirme: grafik çizmek değil, okumak

EDA’da grafiklerin amacı “güzel görünmek” değil; veriyi yorumlanabilir hale getirmektir. Aşağıdaki kontrol listeleri yorum için doğrudan kullanılabilir.

### 6.1. Histogram: proje puanı dağılımı

```python
plt.figure(figsize=(8, 4))
sns.histplot(df["project_score"], bins=10, kde=True)
plt.title("Proje Notu Dağılımı")
plt.xlabel("Proje Notu")
plt.ylabel("Frekans")
plt.show()
```

Yorum ipuçları:

- Dağılım tek tepe mi, iki tepe mi?
- Kuyruk (sağa/sola) uzuyor mu?
- Hangi aralıkta yığılma var?

### 6.2. Boxplot: şubelere göre karşılaştırma

```python
plt.figure(figsize=(8, 4))
sns.boxplot(data=df, x="section", y="project_score")
plt.title("Şube Bazında Proje Notu Dağılımı")
plt.show()
```

Yorum ipuçları:

- Medyan çizgisi hangi şubede daha yüksek?
- Dağılım geniş mi (kutunun boyu)?
- Aykırı değer var mı?

### 6.3. Scatter: çalışma saati ve proje puanı ilişkisi

```python
plt.figure(figsize=(8, 5))
sns.scatterplot(
    data=df,
    x="weekly_study_hours",
    y="project_score",
    hue="section",
)
plt.title("Çalışma Saati ve Proje Notu İlişkisi")
plt.show()
```

Önemli not:

- Scatter bir **ilişki sinyali** verir; doğrudan “neden-sonuç” kanıtı değildir.

### 6.4. Barplot: çalışma seviyesine göre ortalama

```python
plt.figure(figsize=(8, 4))
sns.barplot(
    data=df,
    x="study_level",
    y="project_score",
    estimator=np.mean,
    errorbar=None,
)
plt.title("Çalışma Seviyesine Göre Ortalama Proje Notu")
plt.show()
```

Sık yapılan hata:

- Bar yüksekliğini “kesin fark var” gibi yorumlamak yerine, dağılım fikri için boxplot gibi tamamlayıcı grafiklerle birlikte düşünmek daha doğrudur.

---

## 7. Mini uygulama: risk grubu üretmek

Hedef: düşük devam oranı + düşük çalışma kombinasyonunu bir etikete dönüştürmek.

```python
df["risk_group"] = np.where(
    (df["attendance_rate"] < 70) & (df["weekly_study_hours"] < 6),
    "High Risk",
    "Follow Up",
)

df["risk_group"].value_counts()
```

Risk grubuna göre ortalama proje puanı:

```python
risk_ort = df.groupby("risk_group")["project_score"].mean().reset_index()
risk_ort
```

Grafik:

```python
plt.figure(figsize=(7, 4))
sns.barplot(data=risk_ort, x="risk_group", y="project_score")
plt.title("Risk Grubuna Göre Ortalama Proje Notu")
plt.xlabel("Risk Grubu")
plt.ylabel("Ortalama Proje Notu")
plt.show()
```

---

## 8. Sık karşılaşılan hatalar ve hızlı çözümler

`pandas`/`matplotlib` tarafında sık görülen durumlar:

### 8.1. `FileNotFoundError`

Çözüm:

- Dosya yolunu kontrol edin (`data/...` doğru mu?).
- Notebook konumu ile göreli yol uyumlu mu?

### 8.2. `NameError: name 'df' is not defined`

Çözüm:

- `df = pd.read_csv(...)` satırı çalıştırılmadan aşağıdaki işlemler yapılmış olabilir.
- En üstten tekrar çalıştırmak problemi çözer.

### 8.3. `KeyError: 'proje_notu'` benzeri sütun adı hataları

Çözüm:

```python
print(df.columns)
```

ve doğru sütun adını kullanın (büyük/küçük harf farkı dahil).

### 8.4. Grafik görünmüyor

Çözüm:

- Hücre çalışmış mı?
- `plt.show()` çağrısı var mı?

---

## 9. İleriye geçiş: tahmin fikrine köprü

Bu makalede yapılan şey temelde şudur:

- Veri okunur
- Temizlenir
- Özetlenir
- İlişkiler grafiklerle incelenir

Bir sonraki adımda bu ilişkileri **tahmin kurallarına** çevirmek istenir. Bunun için çoğu zaman:

- “Çıktı” tarafına gidecek değişken belirlenir
- “Girdi” tarafına aday değişkenler seçilir

Bu çerçeve, lineer modelleme mantığını kurmak için doğrudan temel sağlar.

