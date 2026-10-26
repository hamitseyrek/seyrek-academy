# Arduino C/C++ 101: Dil Temelleri ve Arduino’ya Uygulaması

**Bu metin, Arduino ortamında kullanılan C/C++ dilinin temel yapı taşlarını (veri tipleri, operatörler, koşullar, döngüler, fonksiyonlar ve diziler) “101 seviyesi”nde toplu bir giriş olarak anlatıyor. Amaç, kart üzerindeki örneklerden bağımsız şekilde dili tanımak; kodu okurken “bu satır ne yapıyor?” sorusuna daha rahat cevap verebilmek.**

---

# İçerik başlıkları

- Arduino C/C++ program yapısı (setup/loop bağlamında düşünülerek)  
- Temel veri tipleri, sabitler ve operatörler  
- Koşullar (`if`), karşılaştırma ve mantık operatörleri  
- Döngüler (`for`, `while`) ve sayaç mantığı  
- Fonksiyonlar: parametreler, dönüş değeri, kapsam (scope)  
- Diziler (array), basit dizilerle örnek kullanım  
- Kısa kavram soruları ve uygulama problemleri  

---

## 1. Arduino’da C/C++ Program Yapısı

Arduino ortamında klasik `main()` fonksiyonu, framework tarafından gizlenir; bunun yerine:

- Bir kez çalışan `setup()` fonksiyonu  
- Sonsuz döngü olarak çalışan `loop()` fonksiyonu  

üzerinden program kurulur.

Kavramsal olarak:

```text
// Arduino çerçevesi tarafından üretilen iskelet (özet)
int main() {
  init();         // Donanım ilk ayarları
  setup();        // Kullanıcının setup'ı
  while (true) {
    loop();       // Kullanıcının loop'u
  }
}
```

Bu yapı, “gömülü program bitmez, sürekli döner” fikrini dil düzeyine yansıtır.

---

## 2. Temel Veri Tipleri, Sabitler ve Operatörler

### 2.1. Sık Kullanılan Veri Tipleri

- `int` – Tam sayı (çoğu Arduino kartında 16 bit).  
- `long` – Daha geniş aralıkta tam sayı (32 bit).  
- `float` – Ondalıklı sayılar (kayan nokta).  
- `bool` – `true` veya `false`.  
- `byte` – 0–255 aralığında 8 bit değer; bit işlemleri için elverişli.  

Tip seçimi, hem okunabilirlik hem de bellek kullanımı açısından önemlidir.

### 2.2. Sabitler ve Değişkenler

- Sabitler: `const` anahtar sözcüğü ile tanımlanır, kod boyunca değişmezler.  
- Değişkenler: Çalışma sırasında yeni değerler alabilir.

Örnek:

```text
const int MAX_SPEED = 255;
int currentSpeed = 0;
```

### 2.3. Temel Operatörler

- Aritmetik: `+`, `-`, `*`, `/`, `%`  
- Atama: `=`, `+=`, `-=`, `*=`, `/=`, `%=`  
- Karşılaştırma: `==`, `!=`, `<`, `>`, `<=`, `>=`  
- Mantık: `&&` (VE), `||` (VEYA), `!` (DEĞİL)  

Bu operatörler, koşullar ve hesaplamalar için temel yapı taşlarıdır.

---

## 3. Koşullar: `if`, Karşılaştırma ve Mantık

### 3.1. `if` Yapısının Mantığı

Genel şema:

```text
if (koşul) {
  // koşul true ise çalışır
} else {
  // koşul false ise çalışır
}
```

Koşul, karşılaştırma ve mantık operatörleri ile kurulur:

- `if (sensorValue > threshold)`  
- `if (buttonState == HIGH && enabled == true)` gibi.

### 3.2. Çoklu Dallanma

Birden fazla durum için:

```text
if (value < a) {
  // durum 1
} else if (value < b) {
  // durum 2
} else {
  // diğer durumlar
}
```

Bu yapı, sensör değerlerine göre çok seviyeli kararlar vermek için çekirdek bir araçtır.

---

## 4. Döngüler: `for` ve `while`

### 4.1. `for` Döngüsü

Sayaç tabanlı tekrarlar için kullanılır:

```text
for (int i = 0; i < 10; i++) {
  // i: 0,1,2,...,9
}
```

Arduino bağlamında:

- Bir LED dizisini sırayla yakıp söndürmek  
- Belirli sayıda ölçüm alıp ortalamasını hesaplamak  
gibi durumlarda doğrudan kullanılır.

### 4.2. `while` Döngüsü

Koşul doğru olduğu sürece dönen yapıdır:

```text
while (koşul) {
  // koşul true iken tekrar
}
```

Gömülü sistemlerde, `while(true)` ile sonsuz döngü kurmak yerine, mevcut iskelet (`loop()`) zaten bu rolü oynadığı için dikkatli kullanılmalıdır; bloklayıcı yapılar tepki süresini olumsuz etkileyebilir.

---

## 5. Fonksiyonlar: Parametre, Dönüş Değeri ve Kapsam

Fonksiyonlar, tekrarlanan işleri tek bir yerde toplamak için kullanılır.

### 5.1. Temel Tanım

Genel şablon:

```text
geri_dönüş_türü fonksiyonAdı(parametreler) {
  // iş
  return değer; // gerekiyorsa
}
```

Örnek:

- Girdi olarak bir ADC değeri alıp, Volt cinsine çeviren bir fonksiyon:  
- LED parlaklığını ayarlayan yardımcı bir fonksiyon.

### 5.2. Parametre Geçirme

- Değer ile geçirme (en yaygın kullanım):  
  - Fonksiyon, argümanın bir kopyası üzerinde çalışır.  
- Gömülü sistemlerde gereksiz kopyalardan kaçınmak için bazen referans veya pointer kullanılır; 101 seviyesinde temel fikirleri bilmek yeterlidir, ayrıntılar ileri aşamaya bırakılabilir.

### 5.3. Kapsam (Scope)

- Bir fonksiyonun içinde tanımlanan değişkenler, yalnızca o fonksiyon içinde geçerlidir (yerel).  
- Küresel (global) değişkenler, dosya genelinde kullanılabilir.  

Kapsam, özellikle `loop()` ile yardımcı fonksiyonlar arasında veri paylaşırken önemlidir.

---

## 6. Diziler (Array) ile Çalışmak

### 6.1. Dizinin Temeli

Bir dizide aynı türden birden fazla değer ardışık bellekte tutulur:

```text
int readings[10];   // 10 elemanlı int dizi
```

İndeksler 0’dan başlar:

- `readings[0]` ilk eleman  
- `readings[9]` son eleman  

Bu model, sensör okumalarını saklamak, birden fazla LED pinini tek yapı içinde tutmak gibi durumlarda sık kullanılır.

### 6.2. Tipik Kullanım: Ölçüm Saklama

Son 10 ADC okumasının ortalamasını hesaplama fikrini düşünelim:

```text
const int NUM_READINGS = 10;
int readings[NUM_READINGS];

void setup() {
  // Başlangıçta tüm elemanları 0 yapabiliriz
  for (int i = 0; i < NUM_READINGS; i++) {
    readings[i] = 0;
  }
}

void loop() {
  int toplam = 0;

  // Yeni okuma eklendiğini ve readings dizisinin güncellendiğini varsayalım
  // (örneğin en eskiyi atıp en yeniyi sona ekleyen bir mantıkla).

  for (int i = 0; i < NUM_READINGS; i++) {
    toplam += readings[i];
  }

  int ortalama = toplam / NUM_READINGS;

  // ortalama değeri başka hesaplar için kullanılabilir
}
```

Bu örnek, dizilerin üzerinde döngüyle gezmeyi ve basit bir istatistik (ortalama) üretmeyi gösterir.

### 6.3. LED Dizisi Tutmak

Birden fazla LED’i sırayla yakmak için pinleri dizi halinde saklamak, kodun tekrarını azaltır:

```text
const int LED_COUNT = 3;
int ledPins[LED_COUNT] = {2, 3, 4};

void setup() {
  for (int i = 0; i < LED_COUNT; i++) {
    pinMode(ledPins[i], OUTPUT);
  }
}

void loop() {
  for (int i = 0; i < LED_COUNT; i++) {
    digitalWrite(ledPins[i], HIGH);
    delay(200);
    digitalWrite(ledPins[i], LOW);
  }
}
```

Burada, `for` döngüsü index üzerinden giderken, aynı kod bloğu farklı pinler için çalışır; yeni bir LED eklemek sadece diziye pin eklemek anlamına gelir.

