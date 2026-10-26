# factory_quality_regression.csv Veri Kümesi Özeti

Bu dosya; üretim hatlarında “kalite skoru” ile ilişkili olabilecek ölçümleri (çalışma süresi, ekipman kullanılabilirliği, bakım süresi ve sensör uyarı skoru) içeren bir senaryo veri setidir.

Veri; EDA (keşifsel analiz) ve regresyon denemeleri için düzenli bir şablon sağlamak amacıyla, gerçek dünya ölçüm mantığına benzer şekilde kurgulanmıştır. (Bazı alanlarda eksik değerler bilerek bırakılmıştır; çünkü gerçek sistemlerde veri her zaman temiz gelmez.)

## Dosya Bilgileri

- Dosya adı: `factory_quality_regression.csv`
- Konum: `statistics/data/`
- Biçim: CSV

## Sütunlar

| Değişken adı | Tür | Açıklama |
|---|---|---|
| `machine_id` | int | Hattaki makine/hat birimi kimliği |
| `line` | kategori (A/B/C) | Üretim hattı etiketi |
| `runtime_hours` | float | Dönem içindeki makine çalışma süresi (saat) |
| `sensor_alert_score` | float | Sensör uyarı yoğunluğuna dayalı skor (0–100 ölçeği) |
| `uptime_rate` | float | Kullanılabilirlik oranı (yaklaşık yüzde, 0–100) |
| `maintenance_hours` | float | Bakım için ayrılan süre (saat) |
| `cycle_count` | int | Dönem içi çevrim sayısı (yaklaşık) |
| `quality_score` | float | Hedef değişken: kalite skoru (0–100) |

## İlişki fikri

Genelde kalite skoru; çalışma süresi, kullanılabilirlik ve bakım gibi faktörlerden etkilenir. Sensör uyarıları arttıkça kalite düşme eğilimi gösterebilir. Bu veri seti, tek değişkenli ve çoklu doğrusal regresyon örnekleri için bu fikri sayısal olarak temsil eder.

## Hızlı Kullanım

```python
import pandas as pd

df = pd.read_csv("data/factory_quality_regression.csv")
df.head()
df.info()
df.describe()
```

