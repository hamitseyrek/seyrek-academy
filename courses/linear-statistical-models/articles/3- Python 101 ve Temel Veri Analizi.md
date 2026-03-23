# Python 101 ve Temel Veri Analizi

Python, veriyi sadece “çalıştırmak” için değil; **anlamlandırmak** için kullanıldığında gerçek değerini gösterir. Bu makale, Jupyter Notebook mantığıyla başlayıp değişkenler–koşullar–listeler–sözlükler üzerinden ilerler; ardından `pandas` ile tablo oluşturmayı ve temel keşif analizini pratik kod parçalarıyla oturtur.

---

## 1. Jupyter Notebook Mantığı: Hücreler ve Kernel

Jupyter Notebook’ta içerik iki tür hücreyle yürür:

- **Markdown** hücreleri: açıklama metni, başlıklar, listeler
- **Code** hücreleri: Python kodu

Kodu çalıştıran arka plandaki Python sürümüne/ortama ise **kernel** denir.

Notebook’ta en çok kullanılan kısayollar:

- `Shift + Enter`: Hücreyi çalıştır, bir sonraki hücreye geç
- `Ctrl + Enter`: Hücreyi çalıştır, aynı hücrede kal
- `Alt + Enter`: Hücreyi çalıştır, altına yeni hücre ekle
- `Esc` → komut modu:
  - `M`: Markdown
  - `Y`: Code

İlk Markdown hücre örneği:

```markdown
# Python 101 ve Temel Veri Analizi

Bu notebook, Python temelleri ve pandas ile başlangıç veri incelemesini içerir.
```

---

## 2. İlk Python Adımları: İfadeler ve Yorumlar

Basit bir Code hücresinde:

```python
2 + 2
10 * 3
100 / 7
```

Yorum satırı için `#` kullanılır:

```python
# Python bu satırı çalıştırmaz.
5 + 5
```

---

## 3. Değişkenler ve Tipler

Python’da değişken ataması:

```python
isim = "Hamit"
yas = 35
konu = "Veri Analizi"

isim, yas, konu
```

İki önemli nokta:

- `=` atama yapar.
- `type(...)` bir ifadenin hangi veri tipinde olduğunu gösterir.

Tipleri kontrol:

```python
type(isim), type(yas)
```

---

## 4. Listeler ve `for` Döngüsü: Verinin “üzerinde gezmek”

Ortalama/maksimum/minimum gibi özetleri hesaplamak için listeler çok pratik bir başlangıçtır:

```python
notlar = [70, 85, 90, 60, 75]

toplam = sum(notlar)
adet = len(notlar)
ortalama = toplam / adet

print("Notlar:", notlar)
print("Ortalama:", ortalama)
print("En yüksek:", max(notlar))
print("En düşük:", min(notlar))
```

Bir liste üzerinde dolaşma:

```python
yaslar = [20, 22, 21, 23, 20]

for y in yaslar:
    print("Yaş:", y)
```

---

## 5. Koşullar: `if`–`elif`–`else` ile karar vermek

Koşullu mantık, veri filtreleme ve sınıflandırmanın temelidir:

```python
ortalama = 72

if ortalama >= 90:
    durum = "AA"
elif ortalama >= 80:
    durum = "BA"
elif ortalama >= 70:
    durum = "BB"
else:
    durum = "Geçer"

print("Ortalama:", ortalama, "→ Not durumu:", durum)
```

Listeyle birlikte kullanım:

```python
notlar = [45, 60, 75, 90, 82]

for n in notlar:
    if n >= 70:
        print(n, "→ Geçti")
    else:
        print(n, "→ Kaldı")
```

---

## 6. Sözlükler: Anahtar–Değer ile yapılandırılmış veri

Sözlük (dictionary), “özellikleri” bir arada tutar:

```python
profil = {
    "ad": "Hamit",
    "yas": 35,
    "bolum": "Robotik ve Yapay Zeka",
    "konular": ["Veri Analizi", "Veri Tabanları"],
}

print(profil["ad"])
print(profil["konular"])
```

Birden çok kaydı liste içinde tutarak tablo benzeri bir iskelet kurulabilir:

```python
kisiler = [
    {"ad": "Ali", "yas": 20, "ortalama": 2.8},
    {"ad": "Ayşe", "yas": 21, "ortalama": 3.2},
    {"ad": "Mehmet", "yas": 19, "ortalama": 2.5},
]

for k in kisiler:
    print(k["ad"], "→ Ortalama:", k["ortalama"])
```

---

## 7. `pandas` ile Tablo: `DataFrame` oluşturma ve temel inceleme

Önce kütüphaneleri içeri al:

```python
import pandas as pd

print("pandas sürüm:", pd.__version__)
```

Sözlük listesi → `DataFrame`:

```python
df = pd.DataFrame(kisiler)
df
```

Temel inceleme adımları:

```python
df.head()      # ilk satırlar
df.info()      # sütun tipleri + eksik değer sinyali
df.describe()  # sayısal sütunlar için özet istatistik
```

Kolon seçimi ve basit istatistik:

```python
df["ortalama"]
df["ortalama"].mean()
df["yas"].max()
```

Yeni bir türetilmiş kolon:

```python
df["durum"] = df["ortalama"].apply(lambda x: "Geçti" if x >= 2.5 else "Kaldı")
df
```

---

## 8. Minik Analiz Senaryosu: Günlük adım sayıları

Elinizde küçük bir veri olsun. Kod yapısı şu fikirle aynıdır:

- veri → `DataFrame`
- özet istatistik
- filtre

Örnek:

```python
import pandas as pd

veri = {
    "gun": ["Pzt", "Sal", "Çar", "Per", "Cum", "Cmt", "Paz"],
    "adim": [4500, 6200, 8000, 3000, 7000, 9000, 4000],
}

df_adim = pd.DataFrame(veri)
df_adim
```

Özet:

```python
ortalama_adim = df_adim["adim"].mean()
en_cok = df_adim["adim"].max()
en_az = df_adim["adim"].min()

print("Ortalama adım:", ortalama_adim)
print("En çok adım:", en_cok)
print("En az adım:", en_az)
```

Filtre:

```python
df_adim[df_adim["adim"] >= 7000]
```

---

## 9. Kısa Kontrol Soruları

Aşağıdaki soruların cevaplarını not edin:

- Notebook’ta bir hücre nasıl çalıştırılır?
- Markdown ile Code hücresi arasındaki fark nedir?
- Python’da liste nasıl yazılır? Basit bir örnek verin.
- `len` ve `sum` fonksiyonları ne işe yarar?
- `if`–`else` hangi durumda kullanılır?
- `pandas.DataFrame` neyi temsil eder?

---

## Ek 1: Fonksiyonlara Giriş (Tekrar kullanım fikri)

Fonksiyonlar, bir işlemi tekrar tekrar aynı isimle çağırmayı sağlar:

```python
def selamla(isim):
    print(f"Merhaba {isim}, çalışmaya hoş geldin!")

selamla("Hamit")
selamla("Ayşe")
```

`return` ile sonuç döndürme:

```python
def ortalama_hesapla(sayilar):
    toplam = sum(sayilar)
    adet = len(sayilar)
    return toplam / adet

notlar = [70, 80, 90]
print("Ortalama:", ortalama_hesapla(notlar))
```

Örnek bir sınıflandırma fonksiyonu:

```python
def harf_notu(ortalama):
    if ortalama >= 90:
        return "AA"
    elif ortalama >= 80:
        return "BA"
    elif ortalama >= 70:
        return "BB"
    elif ortalama >= 60:
        return "CB"
    else:
        return "FF"

for n in [45, 60, 75, 90]:
    print(n, "→", harf_notu(n))
```

---

## Ek 2: Liste Slicing ve Liste Üretimi

Slicing örneği:

```python
notlar = [50, 60, 70, 80, 90]

ilk = notlar[0]
son = notlar[-1]
orta_uc = notlar[1:4]

print("İlk:", ilk)
print("Son:", son)
print("Ortadaki üçlü:", orta_uc)
```

Liste üretimi (list comprehension) fikir olarak pratik bir kısayoldur:

```python
sayilar = [1, 2, 3, 4, 5]
kareler = [s ** 2 for s in sayilar]
ciftler = [s for s in sayilar if s % 2 == 0]

kareler, ciftler
```

---

## Ek 3: `random` ile Küçük Simülasyonlar (İstatistik bağlantısı)

Rastgele değer üretme:

```python
import random

random_sayi = random.randint(1, 6)
print("Zar:", random_sayi)
```

Basit bir simülasyon:

```python
sonuclar = []

for _ in range(100):
    zar = random.randint(1, 6)
    sonuclar.append(zar)

print("İlk 10 atış:", sonuclar[:10])
print("1 sayısı kaç kez geldi:", sonuclar.count(1))
```

Sensör gürültüsü benzetimi (gerçek değer etrafında rastgele sapma):

```python
gercek_mesafe = 100  # cm
olcumler = []

for _ in range(50):
    gürültü = random.uniform(-5, 5)
    olcum = gercek_mesafe + gürültü
    olcumler.append(olcum)

print("İlk 5 ölçüm:", olcumler[:5])
print("Ölçüm ortalaması:", sum(olcumler) / len(olcumler))
```

