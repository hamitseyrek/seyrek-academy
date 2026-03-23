# Çoklu Doğrusal Regresyon ile Tahmin

Basit doğrusal regresyon tek bir girdiyle çıktı öngörür. Gerçek sistemlerde ise etkileyen pek çok faktör birlikte çalışır: kullanılabilirlik, bakım süresi, üretim hızı gibi.

Çoklu doğrusal regresyon; bu çoklu ilişkileri tek bir doğrusal modelde birleştirir. Bu makale; `quality_score` (kalite skoru) için `runtime_hours` (çalışma süresi), `uptime_rate` (kullanılabilirlik) ve `maintenance_hours` (bakım süresi) değişkenlerini kullanır.

---

## Model fikri

Çoklu doğrusal regresyon şu formülle yazılır:

\( y = \beta_0 + \beta_1 x_1 + \beta_2 x_2 + \dots + \varepsilon \)

Burada yorum için kritik ifade şudur:

- `beta_j` değeri; ilgili \(x_j\) bir birim arttığında **diğer girdiler sabitken** \(y\)’nin ortalama olarak ne kadar değiştiğini özetler.

---

## Örnek akış: `factory_quality_regression.csv`

```python
import pandas as pd
import numpy as np

df = pd.read_csv("data/factory_quality_regression.csv")
```

Eksik değerleri medyanla dolduralım:

```python
numeric_columns = [
    "sensor_alert_score",
    "uptime_rate",
    "maintenance_hours",
    "cycle_count",
    "quality_score",
    "runtime_hours",
]

for col in numeric_columns:
    df[col] = df[col].fillna(df[col].median())
```

Modeli kurmak için girdi ve hedefi ayıralım:

```python
from sklearn.linear_model import LinearRegression
from sklearn.metrics import r2_score, mean_squared_error

features = ["runtime_hours", "uptime_rate", "maintenance_hours"]
X = df[features]
y = df["quality_score"]

model = LinearRegression()
model.fit(X, y)

y_pred = model.predict(X)

print("R2:", float(r2_score(y, y_pred)))
print("RMSE:", float(mean_squared_error(y, y_pred, squared=False)))
```

---

## Katsayılar nasıl okunur?

Katsayıların sayısal karşılığını daha görünür hale getirelim:

```python
import pandas as pd

coef_df = pd.DataFrame({
    "özellik": features,
    "katsayı": model.coef_,
}).sort_values("katsayı", ascending=False)

print("beta0 (sabit):", float(model.intercept_))
coef_df
```

Yorum:
- Katsayısı pozitifse: ilgili özellik artarken kalite skoru ortalama olarak artar (diğerleri sabit kabulüyle).
- Katsayısı negatifse: ilgili özellik artarken kalite skoru ortalama olarak azalır.

Not: `uptime_rate` ve `maintenance_hours` gibi değişkenler birlikte hareket edebilir. Böyle durumlarda “katsayıyı tek başına kesin neden” gibi yorumlamak yerine, keşif grafikleriyle birlikte düşünmek daha sağlıklıdır.

---

## Basit bir tahmin örneği

Elinizde yeni bir durum için ölçümler varsa:

```python
new_row = pd.DataFrame([{
    "runtime_hours": 9.0,
    "uptime_rate": 86.0,
    "maintenance_hours": 6.5,
}])

pred = model.predict(new_row)
print("Tahmin edilen quality_score:", float(pred[0]))
```

---

## Uyarılar ve iyi uygulama notları

Bu makalede model doğrusal olduğu için:
- İlişkilerin doğrusal olmaması durumunda hatalar artabilir
- Aykırı gözlemler katsayıları etkileyebilir

Bu yüzden regresyonu; grafik yorumları, değişken dağılımları ve temel hata ölçüleriyle birlikte ele almak en sağlıklısıdır.

