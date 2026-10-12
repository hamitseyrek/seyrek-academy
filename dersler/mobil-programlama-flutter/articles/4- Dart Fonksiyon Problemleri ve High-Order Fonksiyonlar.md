# Dart Fonksiyon Problemleri ve High-Order Fonksiyonlar

**Dart ile fonksiyon yazarken sadece “çalışsın yeter” demek uzun vadede ciddi karmaşaya yol açıyor. Girdi–çıktısı net, yan etkileri kontrollü ve tekrar kullanılabilir fonksiyonlar; hem Flutter tarafında hem de saf Dart kodunda işleri çok kolaylaştırıyor. Bu yazıda fonksiyon tasarımından başlayıp, high-order fonksiyon kavramına ve pratik problem türlerine uzanan bir yol izliyoruz.**

---

## Fonksiyon Tasarlarken Nelere Dikkat Etmeli?

Fonksiyon, kabaca **girdi alıp çıktı üreten** küçük bir birimdir. İyi tasarlanmış fonksiyonların ortak birkaç özelliği vardır:

- **Net girdi ve çıktı:**  
  İmza (signature) okununca fonksiyonun ne beklediği ve ne döndürdüğü anlaşılmalıdır.
- **Tek sorumluluk:**  
  Çok fazla işi tek fonksiyona yüklemek (“hem hesapla hem ekrana yazdır hem dosyaya kaydet”) okunabilirliği bozar.
- **Yan etkileri kontrol altında tutmak:**  
  Mümkün olduğunca saf fonksiyonlar (aynı girdi → aynı çıktı, dış dünyayı değiştirmeyen) tercih edilmelidir.
- **İsimlendirme:**  
  Fonksiyon isimleri **fiil** olmalı ve ne yaptığını anlatmalıdır (`calculateAverage`, `filterUsers`, `logMessage` vb.).

Örnek olarak kötü ve iyi isimlendirmeyi kıyaslayalım:

```dart
// Kötü
int f(List<int> x) {
  // ...
}

// İyi
int sumPositiveNumbers(List<int> values) {
  // ...
}
```

İkinci fonksiyonu gören biri, gövdeyi okumadan da tahmin yürütebilir.

---

## Saf Fonksiyon (Pure Function) ve Yan Etkiler

**Saf fonksiyon (pure function):**

- Aynı girdi ile her zaman aynı çıktıyı üretir.
- Dışarıdaki hiçbir durumu değiştirmez (global değişken, dosya sistemi, network çağrısı vb. yoktur).

```dart
int square(int x) {
  return x * x; // saf fonksiyon
}
```

**Yan etkili fonksiyon (side-effect):**

```dart
int counter = 0;

int increaseAndGet() {
  counter++;              // dıştaki durumu değiştiriyor
  return counter;
}
```

Flutter içinde **UI güncellemek**, **log yazmak**, **HTTP isteği atmak** gibi işler doğası gereği yan etkilidir; bunları tamamen ortadan kaldıramayız. Ancak:

- İşin mantığını (hesaplama, filtreleme vb.) saf fonksiyonlara ayırıp,
- UI / IO katmanında sadece bu fonksiyonları çağırmak,

uygulamanın **test edilebilirliğini** ve **bakımını** ciddi şekilde kolaylaştırır.

---

## High-Order Fonksiyon Nedir?

Dart’ta fonksiyonlar da birer nesnedir; bu sayede:

- Fonksiyonlar **parametre olarak** başka fonksiyonlara verilebilir,
- Fonksiyonlar **geri dönüş değeri** olarak döndürülebilir,
- List / Map gibi koleksiyonlar üzerinde `map`, `where`, `fold` gibi fonksiyonel araçlar kullanılabilir.

Bu tarz fonksiyonlara **high-order function** denir.

### Örnek: Fonksiyonu Parametre Olarak Vermek

```dart
void printNumber(int number) {
  print('Sayı: $number');
}

void applyToList(List<int> values, void Function(int) operation) {
  for (var value in values) {
    operation(value);
  }
}

void main() {
  var numbers = [1, 2, 3];
  applyToList(numbers, printNumber);
}
```

### Örnek: Fonksiyon Döndüren Fonksiyon

```dart
int Function(int) createMultiplier(int factor) {
  return (int x) => x * factor;
}

void main() {
  var doubleFn = createMultiplier(2);
  print(doubleFn(5)); // 10
}
```

Bu yapı, özellikle **tekrar eden kalıpları soyutlamak** için çok kullanışlıdır.

---

## List Üzerinde map, where, reduce, fold, forEach

Dart’ın koleksiyon API’si, fonksiyonel düşünmeyi destekleyen birçok yardımcı fonksiyon sunar:

- `map` → her elemanı dönüştürür, yeni bir koleksiyon döndürür.
- `where` → bir koşulu sağlayan elemanları filtreler.
- `reduce` → elemanları birleştirip tek bir değer üretir (ilk elemanı başlangıç alır).
- `fold` → `initialValue` ile başlayıp tüm elemanları katlar (reduce’un daha genel hali).
- `forEach` → her eleman için yan etkili bir işlem yapar (örneğin `print`).

### map Örneği

```dart
void main() {
  var numbers = [1, 2, 3];
  var squares = numbers.map((n) => n * n).toList();
  print(squares); // [1, 4, 9]
}
```

### where (filter) Örneği

```dart
void main() {
  var numbers = [1, 2, 3, 4, 5, 6];
  var evens = numbers.where((n) => n % 2 == 0).toList();
  print(evens); // [2, 4, 6]
}
```

### reduce Örneği (Toplam)

```dart
void main() {
  var numbers = [1, 2, 3, 4];
  var sum = numbers.reduce((acc, n) => acc + n);
  print(sum); // 10
}
```

### fold Örneği (Başlangıç Değeri ile)

```dart
void main() {
  var numbers = [1, 2, 3, 4];
  var sum = numbers.fold<int>(0, (acc, n) => acc + n);
  print(sum); // 10
}
```

### forEach Örneği

```dart
void main() {
  var names = ['Ali', 'Ayşe', 'Mehmet'];
  names.forEach((name) => print('Merhaba $name'));
}
```

Bu fonksiyonlar, klasik `for` döngüsünü kullanmadan, daha **deklaratif** (ne yapılacağını söyleyen) bir stil sunar.

---

## Problem Tipi 1: Sayı Listesi – Filtreleme, Dönüştürme, İstatistik

Sık karşılaşılan bir senaryo: elimizde bir **sayı listesi** var ve bu liste üzerinde çeşitli işlemler yapmak istiyoruz.

### Örnek veri

```dart
List<int> numbers = [3, 10, 5, 8, 2, 15];
```

### Sadece Çift Sayıları Alma

```dart
List<int> getEvenNumbers(List<int> values) {
  return values.where((n) => n % 2 == 0).toList();
}
```

### Her Sayının Karesini Alma

```dart
List<int> getSquares(List<int> values) {
  return values.map((n) => n * n).toList();
}
```

### Min, Max ve Ortalama Hesaplama

```dart
(int min, int max, double average) calculateStats(List<int> values) {
  if (values.isEmpty) return (0, 0, 0.0);

  int min = values.first;
  int max = values.first;
  int sum = 0;

  for (var value in values) {
    if (value < min) min = value;
    if (value > max) max = value;
    sum += value;
  }

  double average = sum / values.length;
  return (min, max, average);
}
```

Bu üç fonksiyon, **fonksiyonel araçları** (map/where) ve klasik döngüleri harmanlayarak tipik istatistik problemlerini çözer.

---

## Problem Tipi 2: Metin Listesi – Arama, Gruplama, Sayma

Metin (String) listeleriyle çalışırken de benzer pattern’ler tekrarlar:

```dart
List<String> words = [
  'dart',
  'flutter',
  'dart',
  'widget',
  'state',
  'dart',
];
```

### Belirli Bir Kelimeyi Sayma

```dart
int countOccurrences(List<String> words, String target) {
  return words.where((word) => word == target).length;
}
```

### Uzunluğa Göre Filtreleme

```dart
List<String> filterByLength(List<String> words, int minLength) {
  return words.where((word) => word.length >= minLength).toList();
}
```

### Kelimeleri Frekans Tablosu Haline Getirme

```dart
Map<String, int> buildFrequencyMap(List<String> words) {
  Map<String, int> freq = {};

  for (var word in words) {
    freq[word] = (freq[word] ?? 0) + 1;
  }

  return freq;
}
```

Bu tarz fonksiyonlar, hem basit arama/sayma işlerini çözer hem de metin analizi gibi konulara giriş sağlar.

---

## Closure ile Sayaç ve Logger

Closure, dış kapsamda tanımlı değişkenleri “hatırlayan” fonksiyon nesnesi demektir.

### Sayaç Örneği

```dart
void Function() createCounter() {
  int counter = 0;

  return () {
    counter++;
    print('Sayaç: $counter');
  };
}

void main() {
  var counter1 = createCounter();
  var counter2 = createCounter();

  counter1(); // Sayaç: 1
  counter1(); // Sayaç: 2
  counter2(); // Sayaç: 1
}
```

Her `createCounter` çağrısında **yeni bir `counter` değişkeni** oluşur ve dönen fonksiyon bu değişkeni saklar.

### Basit Logger Örneği

```dart
void Function(String) createLogger(String prefix) {
  return (String message) {
    final timestamp = DateTime.now().toIso8601String();
    print('[$timestamp][$prefix] $message');
  };
}

void main() {
  var infoLogger = createLogger('INFO');
  var errorLogger = createLogger('ERROR');

  infoLogger('Uygulama başlatıldı');
  errorLogger('Beklenmeyen bir hata oluştu');
}
```

Burada da `prefix`, closure sayesinde her logger örneği için özelleşmiş durumda.

---

## Hangi Problem Tipinde Hangi Fonksiyon Tekniği Mantıklı?

Farklı problem türleri için farklı fonksiyonel yaklaşımlar daha uygundur:

- **Basit hesaplama (toplama, çarpma, dönüştürme):**  
  - Saf fonksiyonlar (`int → int`, `List<int> → List<int>`).  
  - Yan etkisiz, tek sorumluluk ilkesine uygun.

- **Liste dönüştürme / filtreleme:**  
  - `map`, `where`, `forEach` ve gerektiğinde özel higher-order yardımcılar (`applyToList`, `filterList` gibi).

- **Toplama / istatistik / katlama:**  
  - `reduce` veya `fold` ile listeyi tek bir değere indirgeme.  
  - Örneğin toplam, min/max, ortalama vb.

- **Esnek koşul veya strateji seçimi:**  
  - Fonksiyonu parametre olarak alan yapılar (`bool Function(T)` veya `T Function(T)`) kullanmak.  
  - Örneğin `filterProductsByPrice`, `printTodoTitles` gibi.

- **Durum saklama (sayaç, logger, cache):**  
  - Closure tabanlı fonksiyon üreticileri (`createCounter`, `createLogger`).  
  - Dış kapsamda tutmak istemediğiniz küçük durumları fonksiyonun kendi içinde saklayabilirsiniz.

Genel kural:  
**Ne kadar çok tekrar eden kalıp görüyorsanız, o kadar çok high-order fonksiyon ve closure’dan faydalanabilirsiniz.**  
Bu sayede kod daha kısa değil, öncelikle **daha anlamlı ve yeniden kullanılabilir** hale gelir.

---

Daha fazla pratik için:  
- Açık uçlu problem seti: **`4S- Dart Fonksiyon Problem Seti.md`**  
- Aynı problemlerin örnek çözümleri: **`4C- Dart Fonksiyon Problem Seti Çözümleri.md`**  
dosyalarına göz atabilirsiniz.*** End Patch
