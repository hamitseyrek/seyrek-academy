# Python ile Veri Temizleme ve Anomali Tespiti: Sensör Verisi Üzerinde Uygulama

Önceki makalede veri temizliğinin neden yalnızca boş hücreleri doldurmak veya uç değerleri silmek olmadığını gördük. Bu uygulamada aynı yaklaşımı `sensor_telemetry.csv` veri setine taşıyoruz. Dosyada 17 kayıt bulunuyor; aralarında tam tekrar, eksik ölçümler, sayıya çevrilemeyen metin, sensör sınırlarını aşan değerler ve sıra dışı bir titreşim ölçümü var.

Bu uygulamanın amacı veriyi kusursuz göstermek değil, sorunları görünür kılmak ve her dönüşümün izini korumaktır. Ham sütunları saklayacağız; temizlenmiş ve analizde kullanılacak değerleri ayrı sütunlarda oluşturacağız.

## 1. Kütüphaneleri Yükleme ve Veriyi Okuma

Çalışmayı depo kök dizininden başlattığımızı varsayıyoruz. CSV dosyasının yolu `dersler/veri-analitigi/kaynaklar/sensor_telemetry.csv` şeklindedir.

```python
import pandas as pd

file_path = "dersler/veri-analitigi/kaynaklar/sensor_telemetry.csv"
raw = pd.read_csv(file_path)

print(f"Satır sayısı: {len(raw)}")
print(f"Sütunlar: {list(raw.columns)}")
raw.head()
```

Çıktıda 17 satır ve altı sütun görürüz: `recorded_at`, `device_id`, `temperature_c`, `humidity_pct`, `vibration_mm_s` ve `status`. Bu aşamada veriyi değiştirmedik; ilk okunan tabloyu `raw` değişkeninde koruyoruz.

## 2. Veri Tiplerini, Eksikleri ve Tam Tekrarları İnceleme

Bir hücrenin dolu görünmesi, içeriğinin doğru türde olduğunu göstermez. Örneğin `temperature_c` sütunundaki `twenty-three` metni tabloda doludur ama sayısal sıcaklık olarak kullanılamaz. Önce türleri, eksik değerleri ve tüm sütunları aynı olan tekrarları sayalım.

```python
print(raw.dtypes)
print("\nEksik değer sayıları:")
print(raw.isna().sum())
print("\nTam tekrarlanan satır sayısı:", raw.duplicated().sum())
```

Pandas başlangıçta sıcaklık sütununu metin olarak okuyabilir; çünkü aynı sütunda sayılarla birlikte `twenty-three` gibi bir metin vardır. Ayrıca `humidity_pct` ve `vibration_mm_s` sütunlarında birer gerçek boş hücre, tabloda da bir tam tekrarlanan satır bulunur. Bunları ayrı sorunlar olarak ele alacağız.

## 3. Çalışma Kopyasını Oluşturma ve Tam Tekrarı Ayırma

Ham tabloyu değiştirmeden bir çalışma kopyası oluşturuyoruz. Yalnızca bütün alanları birebir aynı olan satırın ikinci kopyasını çıkarıyoruz. Aynı cihaz ve zamana ait ama ölçümü farklı satırlar olsaydı, bunları bu kuralla silmezdik.

```python
data = raw.copy()
data = data.drop_duplicates().copy()

print(f"Ham satır: {len(raw)}")
print(f"Tam tekrarlar ayrıldıktan sonra: {len(data)}")
```

Satır sayısı 17’den 16’ya iner. Bu fark, yalnızca tam tekrarlanan bir satırın çıkarılmasından kaynaklanır. Ham `raw` tablosu hâlâ 17 satırla ilk halini korur.

## 4. Tarih ve Sayı Alanlarını Güvenli Biçimde Dönüştürme

Metni sayıya veya tarihe çevirirken dönüşemeyen değerleri gizlememeliyiz. `errors="coerce"` geçersiz girdileri `NaN` ya da `NaT` yapar; bu nedenle dönüşümden önce ham sütunları koruyor, ardından hangi girdilerin dönüşemediğini ayrıca işaretliyoruz.

```python
for column in ["temperature_c", "humidity_pct", "vibration_mm_s"]:
    data[f"{column}_raw"] = data[column]
    data[column] = pd.to_numeric(data[column], errors="coerce")
    data[f"{column}_parse_failed"] = (
        data[column].isna() & data[f"{column}_raw"].notna()
    )

data["recorded_at_raw"] = data["recorded_at"]
data["recorded_at"] = pd.to_datetime(
    data["recorded_at"], errors="coerce", utc=True
)

data["recorded_at_parse_failed"] = (
    data["recorded_at"].isna() & data["recorded_at_raw"].notna()
)

print("Sayıya çevrilemeyen sıcaklık:", int(data["temperature_c_parse_failed"].sum()))
print("Tarihe çevrilemeyen zaman:", int(data["recorded_at_parse_failed"].sum()))
```

Sayıya dönüşmeyen sıcaklık metni ve `not-a-time` tarih girdisi ayrı ayrı görünür hâle gelir. Saat dilimi içeren tarihler UTC’ye çevrilir; `recorded_at_raw` sütununda ise kaynağın özgün metni durur.

## 5. Fiziksel Sınırları ve Eksikliği İşaretleme

`150 °C` ve `-45 °C`, bu sensör için belirtilen `-40–85 °C` aralığının dışındadır. `130%` nem de `0–100` aralığını aşar. Bu değerleri ham sütunlardan silmek yerine temiz analiz sütunlarında geçersiz olarak işaretliyoruz.

```python
data["temperature_out_of_range"] = (
    data["temperature_c"].notna()
    & ~data["temperature_c"].between(-40, 85)
)
data["humidity_out_of_range"] = (
    data["humidity_pct"].notna()
    & ~data["humidity_pct"].between(0, 100)
)
data["vibration_negative"] = (
    data["vibration_mm_s"].notna()
    & data["vibration_mm_s"].lt(0)
)

data["temperature_clean"] = data["temperature_c"].mask(
    data["temperature_out_of_range"]
)
data["humidity_clean"] = data["humidity_pct"].mask(
    data["humidity_out_of_range"]
)
data["vibration_clean"] = data["vibration_mm_s"].mask(
    data["vibration_negative"]
)

data["humidity_was_missing"] = data["humidity_pct_raw"].isna()
data["vibration_was_missing"] = data["vibration_mm_s_raw"].isna()

print("Sınır dışı sıcaklık:", int(data["temperature_out_of_range"].sum()))
print("Sınır dışı nem:", int(data["humidity_out_of_range"].sum()))
print("Eksik nem:", int(data["humidity_was_missing"].sum()))
print("Eksik titreşim:", int(data["vibration_was_missing"].sum()))
```

Beklenen sayılar sırasıyla iki sınır dışı sıcaklık, bir sınır dışı nem, bir eksik nem ve bir eksik titreşimdir. Geçersiz veya eksik değerler `*_clean` sütunlarında boş kalır; özgün ölçüm ve kalite bayrakları korunur.

## 6. İstatistiksel Aykırı Değeri Bulma

Fiziksel sınırlar ile istatistiksel aykırılık aynı şey değildir. IQR sınırlarını hesaplarken yalnızca fiziksel olarak geçerli titreşim ölçümlerini kullanıyoruz. Yüksek titreşim değerini otomatik olarak silmiyor; inceleme için bir bayrak ekliyoruz.

```python
valid_vibration = data.loc[
    data["vibration_clean"].notna(), "vibration_clean"
]

q1 = valid_vibration.quantile(0.25)
q3 = valid_vibration.quantile(0.75)
iqr = q3 - q1
lower_bound = q1 - 1.5 * iqr
upper_bound = q3 + 1.5 * iqr

data["vibration_iqr_candidate"] = (
    data["vibration_clean"].notna()
    & ~data["vibration_clean"].between(lower_bound, upper_bound)
)

print(f"Q1: {q1:.2f} | Q3: {q3:.2f} | IQR: {iqr:.2f}")
print(f"İnceleme aralığı: {lower_bound:.2f}–{upper_bound:.2f} mm/s")
print("IQR inceleme adayı:", int(data["vibration_iqr_candidate"].sum()))
```

Bu veri setinde `38.0 mm/s` ölçümü IQR sınırlarının dışına çıkar ve inceleme adayı olarak işaretlenir. Bu bayrak, ölçümün yanlış olduğunu kanıtlamaz; gerçek bir mekanik olay olup olmadığını bakım kayıtlarıyla karşılaştırmamız gerektiğini söyler.

## 7. Eksik Nem Değerini Gerekçeli Biçimde Doldurma

Bu küçük örnekte tek bir nem ölçümü eksiktir. Sınır dışı nem değeri temiz ölçümlere katılmadan, geçerli nem ölçümlerinin medyanını hesaplıyoruz. Medyanı yalnızca `humidity_clean` alanında kullanıyoruz; `humidity_was_missing` bayrağı boşluğun başlangıçta var olduğunu koruyor.

```python
humidity_median = data["humidity_clean"].median()
data["humidity_filled"] = data["humidity_clean"].mask(
    data["humidity_was_missing"], humidity_median
)

print(f"Geçerli nem medyanı: %{humidity_median:.2f}")
print("Doldurulan eksik nem:", int(data["humidity_was_missing"].sum()))
```

Geçerli nem medyanı `%46.20` olur. Medyanın kullanılması bu tek örnekte açıklama amacı taşır; uzun süreli veya çok sayıda eksik ölçümde aynı sayıyı gelişigüzel kullanmak doğru olmaz. Doldurma bayrağı sayesinde doldurulmuş değer, gerçek sensör ölçümünden ayırt edilebilir.

## 8. Sonuç Tablosunu ve Kalite Özetini Kontrol Etme

Son görünümde temiz değerleri, ham ölçümleri ve kalite bayraklarını birlikte tutuyoruz. Böylece analize uygun alanları kullanırken her kararın dayandığı ilk kayda geri dönebiliriz.

```python
columns_to_review = [
    "recorded_at_raw",
    "device_id",
    "temperature_c_raw",
    "temperature_clean",
    "temperature_c_parse_failed",
    "temperature_out_of_range",
    "humidity_pct_raw",
    "humidity_filled",
    "humidity_was_missing",
    "humidity_out_of_range",
    "vibration_mm_s_raw",
    "vibration_clean",
    "vibration_iqr_candidate",
]

print(data[columns_to_review].to_string(index=False))
print("\nKalite özeti:")
print({
    "ham_satir": len(raw),
    "tam_tekrar_sonrasi": len(data),
    "gecersiz_zaman": int(data["recorded_at_parse_failed"].sum()),
    "sayi_olmayan_sicaklik": int(data["temperature_c_parse_failed"].sum()),
    "sinir_disi_sicaklik": int(data["temperature_out_of_range"].sum()),
    "sinir_disi_nem": int(data["humidity_out_of_range"].sum()),
    "titreşim_iqr_adayi": int(data["vibration_iqr_candidate"].sum()),
})
```

Sonuçta tam tekrar dışında hiçbir kaydı sessizce silmedik. Sayıya çevrilemeyen sıcaklık, geçersiz tarih, fiziksel sınır dışı ölçümler, eksik değerler ve IQR inceleme adayı ayrı bayraklarla görülebilir. Ham değerler yerinde durur; analiz için kullanılacak değerler ve doldurma kararı ayrı sütunlarda izlenir.

## Sonuç

Bu uygulamada veri temizliğini tek bir “temizle ve devam et” komutuna indirgemedik. Önce veriyi tanıdık, sonra tip dönüşümlerini yaptık, fiziksel sınırları ve istatistiksel sıra dışılığı ayrı değerlendirdik. Gerçek arıza ihtimali taşıyan titreşim ölçümünü silmek yerine işaretledik; eksik nemi ise geçerli ölçümlerin medyanıyla doldurup eksiklik bayrağını koruduk.

Bu yaklaşımın temel ilkesi şudur: Ham kayıt korunur, temizlenmiş değerler açık kurallarla üretilir ve her müdahalenin gerekçesi izlenebilir olur. Temizlik kararı, veriyi kusursuz göstermek için değil, analiz sonucunun neye dayandığını dürüstçe açıklamak için verilir.
