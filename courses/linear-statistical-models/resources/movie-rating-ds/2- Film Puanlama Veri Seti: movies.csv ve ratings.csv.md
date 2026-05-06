# Film Puanlama Veri Seti: `movies.csv` ve `ratings.csv`

Bu veri seti, kullanıcıların filmlere verdiği puanlar üzerinden regresyon ve model değerlendirme süreçlerini çalışmak için uygundur.

Dosyalar, `8- Model Uyumu ve Değerlendirme`, `9- Model Seçimi ve Overfitting` ve `10` numaralı makalelerde ortak veri kaynağı olarak kullanılacak şekilde düzenlenmiştir.

## Dosya Bilgileri

- Veri klasörü: `courses/linear-statistical-models/resources/movie-rating-ds/`
- Dosyalar: `movies.csv`, `ratings.csv`
- Biçim: CSV
- Satır sayısı:
  - `movies.csv`: 9742 veri satırı (+ 1 başlık satırı)
  - `ratings.csv`: 100836 veri satırı (+ 1 başlık satırı)
- İlişki anahtarı: `movieId` (iki dosya bu alan üzerinden birleştirilir)
- Eksik ilişki: `ratings.csv` içindeki tüm `movieId` değerleri `movies.csv` içinde karşılık bulur.

## `movies.csv` sütunları

| Değişken adı | Tür | Açıklama |
|---|---|---|
| `movieId` | int | Film kimliği (birincil anahtar gibi kullanılır) |
| `title` | string | Film adı ve yıl bilgisi (ör. `Toy Story (1995)`) |
| `genres` | string | Film türleri (`|` ile ayrılmış çoklu etiketler) |

## `ratings.csv` sütunları

| Değişken adı | Tür | Açıklama |
|---|---|---|
| `userId` | int | Puan veren kullanıcı kimliği |
| `movieId` | int | Puanlanan film kimliği (`movies.csv` ile bağlantı alanı) |
| `rating` | float | Kullanıcı puanı (0.5 ile 5.0 arasında) |
| `timestamp` | int | Unix zaman damgası (değerlendirmenin zamanı) |

## Veri kümesi özeti

- Kullanıcı sayısı: 610
- Film sayısı: 9742
- Toplam puan kaydı: 100836
- Puan aralığı: 0.5 - 5.0
- Ortalama puan: 3.5016
- Zaman aralığı (UTC): 1996-03-29 ile 2018-09-24

Bu yapı sayesinde hem kullanıcı-film etkileşimleri hem de film meta verisi birlikte analiz edilebilir.

## Modelleme açısından kullanım notları

- Ana hedef değişken çoğu senaryoda `rating` olur.
- `movieId` ve `userId` kimlik alanlarıdır; doğrudan sayısal anlam taşımadıkları için ham haliyle modele verilmemelidir.
- `genres` çok etiketli metin alanıdır; `multi-hot encoding` benzeri bir dönüşümle sayısallaştırılabilir.
- `title` alanından film yılı türetilebilir ve ek özellik olarak kullanılabilir.
- `timestamp` alanı zamansal bölme (`time-based split`) veya drift analizi için değerlidir.

## 8-9-10. makaleler için önerilen akış

1. `movies.csv` ve `ratings.csv` dosyalarını `movieId` ile birleştir.
2. Özellik mühendisliği uygula (`genres` dönüşümü, yıl çıkarımı, gerekirse zaman özellikleri).
3. Eğitim/test ayrımını kur.
4. Modelleri karşılaştır ve uygunluk metriklerini (`MAE`, `MSE`, `RMSE`, `R^2`) raporla.
5. Overfitting riskini train-test farkı ve çapraz doğrulama ile değerlendir.

## Hızlı kullanım

```python
import pandas as pd

movies = pd.read_csv(
    "courses/linear-statistical-models/resources/movie-rating-ds/movies.csv"
)
ratings = pd.read_csv(
    "courses/linear-statistical-models/resources/movie-rating-ds/ratings.csv"
)

df = ratings.merge(movies, on="movieId", how="inner")

print(df.head())
print(df.info())
print(df["rating"].describe())
```
