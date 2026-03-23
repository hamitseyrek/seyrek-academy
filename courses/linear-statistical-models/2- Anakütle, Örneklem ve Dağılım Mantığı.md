# Anakütle, Örneklem ve Dağılım Mantığı

Bu makale; anakütle–örneklem ilişkisinden başlayarak parametre–istatistik ayrımını, örnekleme hatası ve belirsizliği açıklar. Ardından farklı örnekleme yöntemlerini ve “dağılım” fikrinin neden kritik olduğunu, robotik/sensör veri dünyasıyla ilişkilendirerek kurar. Amacımız tek bir cümlede: sınırlı ölçümden daha büyük bir gruba dair anlamlı çıkarım yapmanın mantığını oturtmak.

---

## İçerik başlıkları

- Anakütle ve örneklem: “neyi temsil ediyoruz?”
- Parametre vs istatistik: “hangisi ölçülür, hangisi tahmin edilir?”
- Örnekleme hatası ve belirsizlik: “kesin değer yerine güvenli çıkarım”
- Örnekleme yöntemleri: rastgele, sistematik, tabakalı
- Dağılım kavramı: olasılıkla sezgisel bağlantı
- Veri toplama hataları: gürültü, etiketleme ve seçim yanlılığı
- Kısa bir simülasyonla örneklem dağılımı fikri

---

## 1. Anakütle ve örneklem: aynı dosya, farklı sorular

İstatistikte en sık yapılan karışıklıklardan biri şudur: “Elimizde şu tablo var; o zaman anakütle de bu tablodur.” Oysa anakütle, verinin kendisi değil; araştırma sorusunun hedeflediği tüm birimleri ifade eder.

- **Anakütle (population)**: Araştırma için ilgilenilen tüm birimlerin oluşturduğu küme.
- **Örneklem (sample)**: Anakütleden seçilmiş, gözlenen/ölçülen alt küme.

Önemli sonuç: Aynı fabrika, farklı sorularda farklı anakütle tanımlayabilir. (Örneğin tüm robotlar mı, yalnızca A modeli robotlar mı?) Bu yüzden önce soruyu netleştirmek gerekir.

---

## 2. Parametre mi istatistik mi?

Bir anakütleye dair sayısal bir özellik düşünün:

- **Parametre**: Anakütleye ait sayısal özellik. Genellikle bilinmez; çünkü tüm birimler ölçülmez.
- **İstatistik**: Örneklemden hesaplanan sayısal özellik. Parametreyi tahmin etmek için kullanılır.

Tipik bir karşılaştırma:

| Kavram | Kaynak | Genelde bilinir mi? | Örnek |
|--------|--------|----------------------|--------|
| Parametre | Anakütle | Hayır (tahmin edilir) | μ, σ, p |
| İstatistik | Örneklem | Evet (veri toplandı) | x̄, s, p̂ |

Bu tablo, şu cümleyi pratikleştirir: “Ölçtüğüm şey istatistik; asıl hedeflediğim şey parametre.”

---

## 3. Örnekleme hatası ve belirsizlik: neden ‘tek sayı’ yetmez?

Örneklem alındığında, istatistik çoğu zaman parametrenin tam kendisi olmaz. Bunun adı:

- **Örnekleme hatası**: İstatistik ile parametre arasındaki fark (örnek: x̄ − μ).

Bunun temel nedeni basittir: anakütlenin tamamını ölçmeyiz; sadece bir kısmını görürüz. Bu görünen kısım bazen “şanslı”, bazen “şanssız” olabilir.

Buradan belirsizliğe geçilir:

- **Belirsizlik**: Parametreyi tam bilemeyiz; sadece örneklemden elde ettiğimiz tahmini ve bu tahminin ne kadar güvenilir olabileceğini konuşabiliriz.

Pratik mesaj: İstatistik, “kesin cevap” üretmekten çok “veriye dayalı ve belirsizliği de ifade eden” çıkarım yapma disiplinidir.

---

## 4. Örnekleme yöntemleri (mantık düzeyinde)

Örneklemi nasıl seçtiğiniz, sonuçların temsil gücünü belirler. Üç yaygın yöntem:

### 4.1. Rastgele (olasılıklı) örnekleme

Anakütledeki birimlerin seçilme olasılığı bilinir (çoğu zaman eşittir). Seçim tarafsız olduğu için çıkarım yapmak adına güçlü bir zemindir.

### 4.2. Sistematik örnekleme

Liste gibi sıralı bir yapıda belirli aralıklarla birim seçilir (ör. her 10. robot). Uygulaması kolaydır; fakat periyodik bir örüntü varsa yanıltabilir.

### 4.3. Tabakalı örnekleme

Anakütle alt gruplara ayrılır (tabakalar). Her tabakadan ayrı ayrı örnek alınır. Amaç, önemli alt grupların temsiliyi artırmaktır.

Kısa karşılaştırma:

| Tür | Kısa açıklama | Ne zaman mantıklı? |
|-----|----------------|---------------------|
| Rastgele | Her birim eşit şansa sahip | Genel amaçlı çıkarım |
| Sistematik | Sabit aralıklarla seçim | Uzun liste, hızlı iş |
| Tabakalı | Gruplara göre ayrı örnek | Gruplar farklı, her birini temsil etmek istenir |

---

## 5. Dağılım nedir? Olasılıkla sezgisel bağ

**Dağılım**, bir değişkenin hangi değerleri aldığı ve bu değerlerin ne sıklıkla görüldüğünün özetidir. Görsel olarak histogram/çubuk grafik bu fikri taşır:

- X ekseni: değerler
- Y ekseni: sıklık (veya oran)

Olasılıkla bağlantı sezgisel düzeydedir:

- Olasılık: bir olayın gerçekleşme şansı (0–1 arası)
- Sıklık: veride kaç kez göründüğü

Çok gözlemde sıklık oranı olasılığa yaklaşır. Bu sezgi, veri analizinde “dağılım” fikrini anlamayı kolaylaştırır.

---

## 6. Aynı anakütleden tekrar tekrar örnek alınca: örneklem dağılımı

Anakütleden defalarca örneklem alındığında her seferinde farklı bir x̄ (örneklem ortalaması) elde edilir. Bu x̄ değerlerinin kendi dağılımı vardır:

> **Örneklem istatistiğinin dağılımı** (sampling distribution).

Bu bakış, güven aralığı ve hipotez testlerinin temelinde durur. Bu makalede amaç matematiğe boğmak değil; şu fikri oturtmaktır:

- örneklem değiştikçe istatistik değişir
- bu değişimin bir düzeni/dağılımı vardır

---

## 7. Veri toplama hataları: gürültü, etiketleme, seçim yanlılığı

Veri yalnızca “doğru ölçüm” değildir; pratikte birçok hata türü sonuçları şekillendirir:

### 7.1. Sensör/ölçüm kaynaklı hatalar

- **Gürültü**: Ölçümde rastgele sapma (gerçek sinyal + gürültü)
- **Sistem hatası (bias)**: Sürekli bir yönde sapma (ör. her zaman 0.5 cm fazla ölçmek)
- **Çözünürlük**: Sensörün ayırt edebildiği en küçük fark; veriyi “katmanlara” bölebilir

### 7.2. Etiketleme ve veri kalitesi

- **Yanlış etiket** (label noise): Ölçülen birimler gerçek sınıfları tam temsil etmeyebilir.
- **Eksik veri**: Bazı birimler hiç kaydedilmezse örneklem seçim yanlılığı taşıyabilir.

### 7.3. Seçim yanlılığı

Veriyi nasıl topladığınız, anakütleyi ne kadar temsil ettiğinizi belirler. Örneğin yalnızca “arıza yapmış” birimler incelenirse, tüm robotların arıza oranı abartılı görünebilir.

---

## 8. Kısa simülasyon: örneklem ortalaması nasıl oynar?

Aşağıdaki kod, aynı küçük veri kümesinden (temsil ettiği anakütle ortalamasıyla) çok sayıda tekrar örneklem alıp x̄’nin dağılımını gözlemlemek için kullanılabilir.

```python
import numpy as np

veri = np.array([25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95])
mu = veri.mean()

np.random.seed(42)
orneklem = np.random.choice(veri, size=5, replace=True)
x_ust = orneklem.mean()

print("Anakütle ortalaması μ =", mu)
print("Örneklem (n=5) ortalaması x̄ =", x_ust)
print("Örnekleme hatası (x̄ - μ) =", x_ust - mu)
```

Daha fazla tekrar için:

```python
n_deney = 100
n_ornek = 5
ortalamalar = []

for _ in range(n_deney):
    ornek = np.random.choice(veri, size=n_ornek, replace=True)
    ortalamalar.append(ornek.mean())

print("Ortalama(x̄) =", np.mean(ortalamalar))
print("x̄ dağılımının oynaklığı (std) =", np.std(ortalamalar))
```

Sezgisel yorum:
- örneklem boyu büyüdükçe x̄ daha kararlı olur
- x̄’lerin yayılımı azalır

---

## 9. Mini alıştırma: bir senaryoyu etiketleyin

Kendi alanınızdan (robotik, sensör, üretim, eğitim, sağlık vb.) bir senaryo düşünün ve yazılı olarak şu etiketleri doldurun:

- Anakütle: ilgilenilen tüm birimler
- Örneklem: kim/neyin ölçüldüğü
- Parametre: hedeflenen sayısal özellik
- İstatistik: örneklemden hesaplanacak ölçüm
- Örnekleme hatası/ belirsizlik nereden gelebilir?

Bu çalışma tamamlandığında, “veri elde ettim” demekten öte “veriyi hangi hedefle konuşturuyorum?” sorusuna cevap verecek bir çerçeve oluşur.

