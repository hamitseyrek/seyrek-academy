# AIC, BIC ve Hangi Değişkenler Kalsın?

Birden fazla regresyon modeli kurulduğunda train ve test `R2` / `RMSE` değerleri bazen birbirine çok yakın olur. O durumda **AIC** ve **BIC** gibi özet kriterler, uyum ile model karmaşıklığını tek tabloda karşılaştırmaya yardım eder.

Bu makalede AIC/BIC için formül ezberlenmez; aşağıdaki Python kodu çalıştırılır ve çıkan tablo yorumlanır. Hangi değişkenlerin modele girmesi gerektiği korelasyon ve otomatik seçim örnekleriyle ele alınır.

## Veri ve bağlam

- Dosya: `courses/linear-statistical-models/resources/student_performance.csv`
- Hedef: `final_exam_score`
- Eğitim–test: %80 / %20, `random_state=42`

Doğrusal regresyon (`LinearRegression`), seçilen sütunlarla not tahmini üretir. Her ek değişken modele bir katsayı (parametre) ekler; bu da yorumu ve overfitting riskini artırabilir.

## AIC ve BIC ne ölçer?

**AIC** (*Akaike Information Criterion*, Akaike bilgi ölçütü) ve **BIC** (*Bayesian Information Criterion*, Bayesçi bilgi ölçütü) iki modeli tek sayıyla kıyaslamak için kullanılır: **veriye uyum** + **kaç değişken kullanıldığı**.

- Train `R2` sadece uyuma bakar; değişken ekledikçe genelde artar.
- AIC/BIC: “Uyum iyi ama çok değişken var” durumunu **cezalandırır**.

**Kural:** Aynı veri setinde **düşük AIC/BIC** daha iyi aday. **BIC**, fazla değişkene AIC’den daha sert ceza verir (daha sade modeli sever).

Seçilen model yine **test `R2` / `RMSE`** ile doğrulanır.

## Dört aday model


| Model | Değişkenler                                                            |
| ----- | ---------------------------------------------------------------------- |
| M1    | `study_hours_per_week`                                                 |
| M2    | `study_hours_per_week`, `attendance_rate`                              |
| M3    | `study_hours_per_week`, `solved_question_count`, `previous_term_score` |
| M4    | Altı değişkenin tamamı                                                 |


## Dört model için AIC ve BIC hesaplama

Aşağıdaki kodu Jupyter Notebook’ta bir **Code** hücresine yapıştırıp çalıştırın (`Shift + Enter`). Ekranda her model için `train_r2`, `aic` ve `bic` sütunlarını içeren bir tablo görünür. **aic** küçükten büyüğe sıralıdır; en üst satır AIC’ye göre öne çıkan modeldir.

```python
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import r2_score

df = pd.read_csv(
    "courses/linear-statistical-models/resources/student_performance.csv"
)

numeric_cols = [
    "study_hours_per_week",
    "attendance_rate",
    "sleep_hours_per_day",
    "solved_question_count",
    "previous_term_score",
    "internet_usage_hours_per_day",
    "final_exam_score",
]
for col in numeric_cols:
    df[col] = df[col].fillna(df[col].median())

y = df["final_exam_score"]
X_all = df.drop(columns=["final_exam_score"])

X_train, X_test, y_train, y_test = train_test_split(
    X_all, y, test_size=0.2, random_state=42
)

candidate_models = {
    "M1": ["study_hours_per_week"],
    "M2": ["study_hours_per_week", "attendance_rate"],
    "M3": [
        "study_hours_per_week",
        "solved_question_count",
        "previous_term_score",
    ],
    "M4": [
        "study_hours_per_week",
        "attendance_rate",
        "sleep_hours_per_day",
        "solved_question_count",
        "previous_term_score",
        "internet_usage_hours_per_day",
    ],
}

rows = []

for name, feature_list in candidate_models.items():
    X_sub = X_train[feature_list]
    model = LinearRegression()
    model.fit(X_sub, y_train)
    pred_train = model.predict(X_sub)

    n = len(y_train)
    k = len(feature_list) + 1  # intercept dahil
    rss = np.sum((y_train - pred_train) ** 2)
    sigma2 = rss / n
    log_l = -0.5 * n * (np.log(2 * np.pi) + np.log(sigma2) + 1)
    aic = 2 * k - 2 * log_l
    bic = k * np.log(n) - 2 * log_l

    rows.append(
        {
            "model": name,
            "n_features": len(feature_list),
            "train_r2": round(float(r2_score(y_train, pred_train)), 4),
            "aic": round(float(aic), 2),
            "bic": round(float(bic), 2),
        }
    )

aic_bic_df = pd.DataFrame(rows).sort_values("aic")
print(aic_bic_df)
```

## Tablo okuma alıştırması

Aşağıdaki sayılar **örnek** değerlerdir; mantık egzersizi içindir:


| model | n_features | train_r2 | AIC  | BIC  |
| ----- | ---------- | -------- | ---- | ---- |
| M4    | 6          | 0.82     | 4100 | 4150 |
| M3    | 3          | 0.79     | 4080 | 4110 |
| M2    | 2          | 0.71     | 4090 | 4120 |
| M1    | 1          | 0.55     | 4200 | 4220 |


Yorum:

- En düşük AIC **M3** → AIC’ye göre tercih M3.
- En düşük BIC de **M3** → BIC, M4’ün getirdiği fazla parametreyi cezalandırır.
- M4’ün train `R2`’si en yüksek olsa bile “en yüksek R2” otomatik seçim kuralı değildir.


## Karar checklist

1. AIC/BIC tablosunda en düşük skorlu adaylar listelenir.
2. Aday test `RMSE` / test `R2` ile doğrulanır.
3. Korelasyon haritasında tekrarlayan bilgi taşıyan çiftler kontrol edilir.
4. İleri seçim çıktısı, elle seçilen liste ile karşılaştırılır.

Nihai karar tek skora bırakılmaz; tablolar birlikte okunur.

## Sonuç

AIC ve BIC, model karşılaştırmasına karmaşıklık cezası ekler. Değişken seçimi, hangi sütunların modele gireceğini sistematikleştirir. Düşük AIC/BIC, iyi test performansı ve düşük korelasyon riski birlikte düşünüldüğünde daha güvenilir bir model seçimi yapılır.