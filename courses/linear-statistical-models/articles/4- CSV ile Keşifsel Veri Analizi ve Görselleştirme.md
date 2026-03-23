# CSV ile Keşifsel Veri Analizi ve Görselleştirme

Python temelleri, `pandas` ile veri tabanına dönüşünce bambaşka bir güce ulaşır: veri okuyabilir, temizleyebilir ve özetleyebilirsiniz. Bu makale; fonksiyonlar, NumPy ve CSV/`pandas` akışı üzerinden keşifsel veri analizi (EDA) kurar. Grafik yorumlama ve `matplotlib`/`seaborn` uygulamaları ise bir sonraki dosyada bulunur.

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

df = pd.read_csv("data/factory_quality_regression.csv")

print(df.head())
print(df.shape)       # (satır, sütun)
print(df.columns)
df.info()
df.describe()
```

Bu örnekte:

- `pandas` tabular veriyi `DataFrame` olarak tutar (burada `df` bu yapıdır).
- `df.info()` veri tiplerini ve eksik değer durumunu hızlıca özetler.
- `df.describe()` sayısal sütunlar için temel istatistikleri (ortalama, std, min, max ve çeyrekler) gösterir.

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

`df.isnull()` her hücre için “eksik mi?” bilgisini üretir; `.sum()` ise her sütunda kaç eksik bulunduğunu sayar.

Eksik satırları görmek:

```python
df[df.isnull().any(axis=1)]
```

Bu makalede kullanılan basit yaklaşım: sayısal kolonlarda medyanla doldurma.

```python
numeric_columns = [
    "sensor_alert_score",
    "uptime_rate",
    "maintenance_hours",
    "cycle_count",
    "quality_score",
]

for col in numeric_columns:
    df[col] = df[col].fillna(df[col].median())

df.isnull().sum()
```

Bu kodda `fillna(...)`, ilgili kolondaki eksikleri aynı kolondaki `median()` değeriyle değiştirir.

Neden medyan?

- Aykırı değerlerden ortalamaya göre daha az etkilenir
- İlk aşama veri temizliğinde daha “güvenli” bir başlangıçtır

---

## 4. Türetilmiş sütunlar: veriyle düşünmek

Keşif analizinde bazen ham kolonlar tek başına yetmez; bazı durumları etiketlemek düşünmeyi hızlandırır.

Örneğin kalite skoruna göre durum etiketi:

```python
df["quality_status"] = np.where(
    df["quality_score"] >= 70,
    "Yüksek",
    "Takip",
)

df[["machine_id", "quality_score", "quality_status"]].head()
```

`np.where(koşul, doğru_değer, yanlış_değer)` yapısı koşula göre yeni bir kolon üretir. Koşul sağlanıyorsa “Yüksek”, sağlanmıyorsa “Takip” yazılır.

Çalışma seviyesini saatten türetmek için `if` mantığını fonksiyonla paketleyin:

```python
def operation_level(hours):
    if hours < 5:
        return "Düşük"
    elif hours < 10:
        return "Orta"
    else:
        return "Yüksek"

df["operation_level"] = df["runtime_hours"].apply(operation_level)
df[["runtime_hours", "operation_level"]].head()
```

`apply`, kolondaki her değeri tek tek alır ve `operation_level` fonksiyonundan geçirir.

---

## 5. Özet analiz: sıralama, filtre ve `groupby`

Sıralama ve filtreleme, “hangi gruplar daha farklı?” sorusunu somutlaştırır.

En yüksek kalite skorları:

```python
df.sort_values("quality_score", ascending=False).head(10)
```

`sort_values`, ilgili kolonun değerlerini sıralar; `head(10)` ise en üstteki 10 satırı döndürür.

Çalışma süresi 10 ve üzeri olanlar:

```python
df[df["runtime_hours"] >= 10].head()
```

Bu ifade, boolean koşula göre satırları filtreler.

Yüksek kalite ve yüksek kullanılabilirlik koşulu:

```python
df[
    (df["quality_score"] >= 75) & (df["uptime_rate"] >= 85)
].head()
```

Hat bazında ortalamalar (`groupby`):

```python
df.groupby("line")[["sensor_alert_score", "quality_score", "uptime_rate"]].mean()
```

`groupby`, kolonun değerlerine göre gruplar; ardından `.mean()` seçilen sayısal kolonların her gruptaki ortalamasını hesaplar.

Çalışma seviyesi bazında ortalama kalite skoru:

```python
df.groupby("operation_level")["quality_score"].mean().sort_values(ascending=False)
```

Kalite durum dağılımı:

```python
df["quality_status"].value_counts()
```

`value_counts()`, kategorik etiketlerin frekanslarını (kaç kez geçtiğini) verir.

---

## 6. Mini uygulama: risk grubu üretmek ve özetini çıkarmak

Hedef: düşük kullanılabilirlik + düşük çalışma kombinasyonunu bir kalite risk etiketine dönüştürmek.

```text
df["risk_group"] = np.where(
    (df["uptime_rate"] < 70) & (df["runtime_hours"] < 6),
    "Yüksek Kalite Riski",
    "Takip",
)

df["risk_group"].value_counts()
```

```text
df["risk_group"] = np.where(
    (df["uptime_rate"] < 70) & (df["runtime_hours"] < 6),
    "Yüksek Kalite Riski",
    "Takip",
)

df["risk_group"].value_counts()

risk_ort = df.groupby("risk_group")["quality_score"].mean().reset_index()
risk_ort
```

Burada risk etiketi, iki koşulun `&` ile birlikte sağlanmasına göre atanır.

Risk grubuna göre ortalama kalite skoru:

```python
df["risk_group"] = np.where(
    (df["uptime_rate"] < 70) & (df["runtime_hours"] < 6),
    "Yüksek Kalite Riski",
    "Takip",
)

risk_ort = df.groupby("risk_group")["quality_score"].mean().reset_index()
risk_ort
```

```python
df["risk_group"] = np.where(
    (df["uptime_rate"] < 70) & (df["runtime_hours"] < 6),
    "Yüksek Kalite Riski",
    "Takip",
)
risk_ort = df.groupby("risk_group")["quality_score"].mean().reset_index()
risk_ort
```

```text
df["risk_group"] = np.where(
    (df["uptime_rate"] < 70) & (df["runtime_hours"] < 6),
    "Yüksek Kalite Riski",
    "Takip",
)
risk_ort = df.groupby("risk_group")["quality_score"].mean().reset_index()
risk_ort
```

```text
df["risk_group"] = np.where((df["uptime_rate"] < 70) & (df["runtime_hours"] < 6), "Yüksek Kalite Riski", "Takip")
risk_ort = df.groupby("risk_group")["quality_score"].mean().reset_index()
risk_ort
```

`groupby("risk_group").mean()`, her risk grubunda `quality_score` ortalamasını hesaplar. `reset_index()`, sonucu tekrar tablo formatında görmeyi kolaylaştırır.

Bu özet tabloyu bir sonraki dosyada, grafikle birlikte yorumlayacağız.

