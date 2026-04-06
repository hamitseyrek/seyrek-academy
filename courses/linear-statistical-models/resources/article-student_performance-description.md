# student_performance.csv Veri Kümesi Açıklaması

Bu veri kümesi, öğrencilerin dönem sonu sınav başarısını etkileyebilecek temel değişkenleri içeren gerçekçi bir eğitim senaryosunu temsil eder.

Dosya, `6- Basit Doğrusal Regresyon ile Tahmin` ve `7- Çoklu Doğrusal Regresyon ile Tahmin` makalelerinde ortak kullanılabilecek şekilde hazırlanmıştır.

## Dosya Bilgileri

- Dosya adı: `student_performance.csv`
- Konum: `courses/linear-statistical-models/resources/`
- Biçim: CSV
- Satır sayısı: 2000 veri satırı (+ 1 başlık satırı)
- Eksik değer: Gerçek veri akışına benzemesi için bazı hücreler bilinçli olarak boş bırakılmıştır (CSV’de boş alan). Makale örneklerinde eksik değer sayımı ve doldurma/alt küme seçimi gösterilir.
- Değerlendirme: `6` ve `7` makale örneklerinde veri **%80 eğitim / %20 test** olarak ayrılır (`train_test_split`, `test_size=0.2`, `random_state=42`).

## Sütunlar

| Değişken adı | Tür | Açıklama |
|---|---|---|
| `study_hours_per_week` | int | Haftalık ders çalışma süresi (saat) |
| `attendance_rate` | int | Derse devam oranı (yüzde) |
| `sleep_hours_per_day` | float | Günlük ortalama uyku süresi (saat) |
| `solved_question_count` | int | Dönem boyunca çözülen toplam soru sayısı |
| `previous_term_score` | int | Önceki dönem notu (0-100) |
| `internet_usage_hours_per_day` | float | Günlük ders dışı internet kullanım süresi (saat) |
| `final_exam_score` | float | Hedef değişken: dönem sonu sınav notu (0-100) |

## Modelleme Mantığı

Veri seti, regresyon yaklaşımını öğretmek için kurgulanmıştır:

- `final_exam_score` hedef değişkendir (bağımlı değişken).
- Diğer sütunlar açıklayıcı değişkenlerdir (bağımsız değişkenler).
- Çalışma süresi, devam oranı, çözülen soru sayısı ve önceki dönem notunun notu artırması beklenir.
- Aşırı internet kullanımının başarıyı azaltıcı etkisi olabileceği varsayılmıştır.
- Gerçek hayattaki doğal dalgalanmayı yansıtmak için küçük rastgelelik (noise) eklenmiştir.

Bu yapı sayesinde hem tek tek değişken etkileri hem de çoklu doğrusal regresyonda ortak etki analizi yapılabilir.

## Hızlı Kullanım

```python
import pandas as pd

df = pd.read_csv("courses/linear-statistical-models/resources/student_performance.csv")
print(df.head())
print(df.info())
print(df.describe())
```
