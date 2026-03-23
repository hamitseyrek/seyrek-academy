# Basit Doğrusal Regresyon ile Tahmin

Keşifsel analizde iki değişken arasında bir ilişki sinyali görmek sık olur. Basit doğrusal regresyon, bu sinyali tek bir tahmin kuralına dönüştürmeyi hedefler: tek bir girdiyle (bağımsız değişken) bir çıktıyı (bağımlı değişken) öngörmek.

Bu makalede hedef değişken `quality_score` (kalite skoru) ve girdi değişkeni `runtime_hours` (makine çalışma süresi).

---

## Model fikri

Doğrusal model şu formülle yazılır:

\( y = \beta_0 + \beta_1 x + \varepsilon \)

- \(x\): `runtime_hours`
- \(y\): `quality_score`
- \(\beta_0\): sabit terim (doğrunun y-kesişimi)
- \(\beta_1\): eğim (x 1 birim artınca y’nin ortalama değişimi)
- \(\varepsilon\): rastgele hata/oynaklık

Bu model, veriyi “tek bir doğru” ile özetlemeye çalışır.

---

## En küçük kareler: çizgi nasıl seçilir?

Her veri noktasının doğrunun üzerinde/altında bir sapması vardır. Basit regresyon, bu sapmaların karelerinin toplamını en aza indirecek \( \beta_0 \) ve \( \beta_1 \) değerlerini arar.

Pratikte bunun anlamı şudur:

- Noktalar tek bir doğruya tam oturmaz
- Model, “en iyi” ortalama davranışı temsil eden doğrunun katsayılarını bulur

---

## Örnek akış: `factory_quality_regression.csv`

Önce veriyi yükleyelim:

```python
import pandas as pd
import numpy as np

df = pd.read_csv("data/factory_quality_regression.csv")
```

Eksik değerler varsa, sayısal kolonlarda medyanla doldurmak pratik bir başlangıçtır:

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

Tek değişken için model kurma:

```python
from sklearn.linear_model import LinearRegression
from sklearn.metrics import r2_score, mean_squared_error

X = df[["runtime_hours"]]   # 2D format şart
y = df["quality_score"]

model = LinearRegression()
model.fit(X, y)

y_pred = model.predict(X)

print("beta1 (eğim):", float(model.coef_[0]))
print("beta0 (sabit):", float(model.intercept_))
print("R2:", float(r2_score(y, y_pred)))
print("RMSE:", float(mean_squared_error(y, y_pred, squared=False)))
```

R2 ve RMSE’yi birlikte düşünmek daha anlamlıdır:
- R2: “varyansın ne kadarını açıklıyor?”
- RMSE: “tahminlerin tipik hatası kaç puan?”

---

## Doğruyu görselleştirme

```python
import matplotlib.pyplot as plt
import seaborn as sns

x_min = df["runtime_hours"].min()
x_max = df["runtime_hours"].max()
x_grid = np.linspace(x_min, x_max, 100).reshape(-1, 1)
y_grid = model.predict(x_grid)

plt.figure(figsize=(7, 5))
sns.scatterplot(data=df, x="runtime_hours", y="quality_score", alpha=0.7)
plt.plot(x_grid, y_grid, color="red", linewidth=2)
plt.title("Doğrusal Regresyon Doğrusu")
plt.xlabel("runtime_hours")
plt.ylabel("quality_score")
plt.show()
```

Yorum:
- Noktalar genişse hata/oynaklık yüksektir
- Doğru, gözlenen dağılımı “tek çizgi”ye indirger

