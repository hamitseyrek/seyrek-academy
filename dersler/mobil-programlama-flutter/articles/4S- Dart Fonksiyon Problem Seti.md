# Dart Fonksiyon Problem Seti

Bu doküman, Dart’ta **fonksiyonlar** ve **higher-order fonksiyonlar** (fonksiyon döndüren / fonksiyon alan fonksiyonlar) üzerinde bol bol pratik yapmak için hazırlanmış soru setidir.  
Tüm örneklerde **değişken, fonksiyon ve sınıf isimleri İngilizce** seçilmiştir; açıklamalar ve ekrana yazdırılan metinler Türkçe tutulmuştur.

Sorular **artan zorlukta** ilerler; 1–8 temel fonksiyon kullanımı, 9–14 higher-order fonksiyonlar, 15–20 ise karışık/mini uygulama tadında problemlerdir.

---

## 1. Basit Toplama Fonksiyonu

`sumTwoNumbers` adında, iki `int` alıp toplamını döndüren bir fonksiyon yazın.  
Ardından `main` içinde bu fonksiyonu çağırıp sonucu ekrana yazdırın.

**İpucu:**  
İmza kabaca şöyle olacaktır:

```dart
int sumTwoNumbers(int a, int b) {
  // ...
}
```

---

## 2. Maksimumu Bulma

`maxOfThree` adında, üç `int` parametre alıp en büyük olanı döndüren bir fonksiyon yazın.

- Koşullu ifadeleri (`if/else`) kullanın.
- `main` içinde farklı girdilerle test edin.

---

## 3. Liste İçindeki Çift Sayıları Sayma

`countEvenNumbers` adında, `List<int>` alan ve içindeki **çift** sayıların sayısını döndüren bir fonksiyon yazın.

Örnek:  
`[1, 2, 3, 4, 5, 6]` için sonuç `3` olmalı.

---

## 4. String Ters Çevirme

`reverseString` adında, bir `String` alan ve ters çevrilmiş halini döndüren bir fonksiyon yazın.

Örnek:  
`"Dart"` → `"traD"`

**İpucu:**  
`split`, `reversed`, `join` metodlarını kullanabilirsiniz.

---

## 5. Palindrom Kontrolü

`isPalindrome` adında, bir `String` alıp palindrom olup olmadığını `bool` olarak döndüren fonksiyon yazın.

- Büyük/küçük harf duyarsız çalışsın (örn. `"Kayak"`, `"KAyak"` de palindrom sayılsın).
- Boş string palindrom kabul edilsin.

---

## 6. Faktöriyel Hesabı

`factorial` adında, pozitif bir `int` alan ve faktöriyelini döndüren fonksiyon yazın.

- Hem **iteratif** (döngü ile) hem de **özyinelemeli (recursive)** versiyonunu yazmanız bekleniyor.
- 0! = 1 olduğunu unutmayın.

---

## 7. Ortalama Hesaplama

`calculateAverage` adında, bir `List<double>` alan ve listedeki sayıların ortalamasını döndüren fonksiyon yazın.

- Liste boşsa `0.0` döndürün.
- Sonucu `double` olarak döndürün.

---

## 8. Map Üzerinden Not Hesabı

Öğrencilerin notlarını tutan şu yapı verilsin:

```dart
Map<String, int> grades = {
  'Ali': 80,
  'Ayşe': 95,
  'Mehmet': 70,
};
```

`findTopStudent` adında, bu `Map<String, int>`’i alan ve **en yüksek nota sahip öğrencinin ismini** döndüren fonksiyon yazın.

- Birden fazla öğrenci aynı en yüksek nota sahipse ilk bulduğunuzu döndürebilirsiniz.

---

## 9. Higher-Order: Fonksiyonu Parametre Olarak Alan Basit Örnek

`applyToList` adında, şu imzaya sahip bir fonksiyon yazın:

```dart
List<int> applyToList(
  List<int> values,
  int Function(int) operation,
)
```

- `values` listesindeki her elemana `operation` fonksiyonunu uygulayıp yeni bir liste döndürsün.
- Örneğin `operation` olarak `square` (x → x * x) verirseniz `[1, 2, 3]` → `[1, 4, 9]` elde etmelisiniz.

---

## 10. Higher-Order: Filtreleme Fonksiyonu

`filterList` adında, aşağıdaki imzaya sahip bir fonksiyon yazın:

```dart
List<int> filterList(
  List<int> values,
  bool Function(int) test,
)
```

- `test` fonksiyonundan `true` dönen elemanlar yeni listeye alınsın.
- Örnek kullanım:
  - Sadece çift sayıları filtrelemek için: `test = (n) => n % 2 == 0`
  - Sadece 10’dan büyükleri filtrelemek için: `test = (n) => n > 10`

---

## 11. Higher-Order: Fonksiyon Döndüren Fonksiyon (Multiplier)

`createMultiplier` adında, bir `int factor` alan ve size `int Function(int)` döndüren bir fonksiyon yazın.

- Dönen fonksiyon, aldığı sayıyı `factor` ile çarpsın.
- Örnek:
  - `var doubleFn = createMultiplier(2);`
  - `doubleFn(5)` → `10`

---

## 12. Higher-Order: String Dönüştürücü Zincir

`composeStringTransformers` adında, iki farklı `String Function(String)` alan ve bunların **bileşimini** döndüren bir fonksiyon yazın:

```dart
String Function(String) composeStringTransformers(
  String Function(String) first,
  String Function(String) second,
)
```

Dönen fonksiyon, önce `first`, sonra `second` fonksiyonunu uygulasın.

- Örnek:
  - `toUpper` → tüm harfleri büyüten fonksiyon
  - `addExclamation` → sonuna `!` ekleyen fonksiyon
  - `composed = composeStringTransformers(toUpper, addExclamation)`
  - `composed('dart')` → `"DART!"`

---

## 13. Higher-Order: Basit Reduce İşlemi

`reduceList` adında, şu imzaya sahip bir fonksiyon yazın:

```dart
int reduceList(
  List<int> values,
  int initialValue,
  int Function(int accumulator, int element) combine,
)
```

- `accumulator` başlangıçta `initialValue` olsun.
- Her elemanda `accumulator = combine(accumulator, element)` yapın.
- Tüm elemanlar işlendikten sonra `accumulator` değerini döndürün.

Örnek kullanımlar:

- Tüm sayıları toplamak için: `combine = (acc, element) => acc + element`
- En büyük sayıyı bulmak için: `combine = (acc, element) => acc > element ? acc : element`

---

## 14. Closure: Sayaç Oluşturucu

`createCounter` adında, size `void Function()` döndüren bir fonksiyon yazın:

- İçeride `int counter = 0;` olsun.
- Dönen fonksiyon her çağrıldığında `counter`’ı arttırsın ve değeri ekrana yazdırsın.

Örnek:

```dart
void main() {
  var counter1 = createCounter();
  var counter2 = createCounter();

  counter1(); // Sayaç: 1
  counter1(); // Sayaç: 2

  counter2(); // Sayaç: 1
}
```

`counter1` ve `counter2`’nin birbirinden bağımsız sayaçlar olduğunu gözlemleyin.

---

## 15. Liste İstatistikleri (Min, Max, Ortalama)

`calculateStats` adında, bir `List<int>` alıp size bir record döndüren bir fonksiyon yazın:

```dart
(int min, int max, double average) calculateStats(List<int> values)
```

- Liste boşsa `min` ve `max` için `0`, `average` için `0.0` dönün.
- Aksi halde gerçek min, max ve ortalama değerlerini hesaplayın.

---

## 16. Öğrenci Not Sistemi – Fonksiyonlarla

Aşağıdaki gibi bir `Student` sınıfınız olsun:

```dart
class Student {
  String name;
  List<int> grades;

  Student({
    required this.name,
    required this.grades,
  });
}
```

İstenen fonksiyonlar:

1. `double calculateStudentAverage(Student student)`  
   - Bir öğrencinin not ortalamasını hesaplasın.
2. `Student? findBestStudent(List<Student> students)`  
   - En yüksek ortalamaya sahip öğrenciyi bulup döndürsün (liste boşsa `null`).

---

## 17. Basit Filtre – Map ile

Aşağıdaki gibi bir ürün listesi olduğunu varsayın:

```dart
class Product {
  String name;
  double price;

  Product({required this.name, required this.price});
}
```

`filterProductsByPrice` adında, şu imzaya sahip fonksiyonu yazın:

```dart
List<Product> filterProductsByPrice(
  List<Product> products,
  bool Function(Product) test,
)
```

Örnek kullanımlar:

- 100 TL’den ucuz ürünler
- 50 ile 200 TL arası ürünler

---

## 18. Basit Todo List – Higher-Order ile İşlemler

`Todo` adında, şu şekilde bir sınıfınız olsun:

```dart
class Todo {
  String title;
  bool isDone;

  Todo({
    required this.title,
    this.isDone = false,
  });
}
```

İstenen fonksiyonlar:

1. `List<Todo> getCompletedTodos(List<Todo> todos)`  
   - `isDone == true` olanları döndürsün.
2. `List<Todo> getPendingTodos(List<Todo> todos)`  
   - `isDone == false` olanları döndürsün.
3. `void printTodoTitles(List<Todo> todos, bool Function(Todo) filter)`  
   - `filter` fonksiyonundan `true` dönen todo’ların sadece başlıklarını (`title`) ekrana yazdırsın.

Bu üç fonksiyonda, mümkün olduğunca tekrar eden kodu azaltmak için **higher-order fonksiyon** (örneğin `filter` benzeri bir fonksiyon) kullanmayı düşünün.

---

## 19. String İşleme – Pipeline

`StringProcessor` adında, aşağıdaki gibi bir sınıf tasarlayın:

```dart
class StringProcessor {
  final List<String Function(String)> _operations;

  StringProcessor(this._operations);

  String process(String input) {
    // TODO: input'u sırayla tüm operasyonlardan geçirip sonucu döndür
  }
}
```

- `process` metodu, `input`’u `_operations` listesindeki fonksiyonlardan sırayla geçirsin (pipe).
- Örnek operasyonlar:
  - `trim` → baştaki ve sondaki boşlukları silsin.
  - `toUpperCase` → tüm harfleri büyütsün.
  - `addPrefix` → başına sabit bir ek koysun (örn. `"INFO: "`).

Örnek kullanım senaryosu kurgulayın:

- Gelen log mesajlarını önce temizleyip sonra belli bir formatta yazdırmak gibi.

---

## 20. Küçük Uygulama: Basit Hesap Makinesi

`Calculator` adında, aşağıdaki imzaya sahip fonksiyonları olan bir yapı tasarlayın (sınıf veya fonksiyon seti olabilir):

- `int add(int a, int b)`
- `int subtract(int a, int b)`
- `int multiply(int a, int b)`
- `double divide(int a, int b)`
- `int operate(int a, int b, int Function(int, int) operation)`

`operate`, kendisine verilen `operation` fonksiyonunu kullanarak işlemi gerçekleştirsin.

- `main` içinde örnek bir menü veya sabit senaryolar üzerinden bu fonksiyonları çağırıp sonuçları ekrana yazdırın.
- `divide` fonksiyonunda sıfıra bölme durumuna karşı basit bir kontrol ekleyin.

---

Bu problem setinin çözümleri ve açıklamaları için **`4C- Dart Fonksiyon Problem Seti Çözümleri.md`** dosyasına bakabilirsiniz.*** End Patch```}쁘assistant to=functions.ApplyPatch.Serialized-by-toolsүүлэгчassistant to=functions.ApplyPatchikwembuassistantательства to=functions.ApplyPatch дызcommentary  聚利 to=functions.ApplyPatch  北京赛车前jsonassistant to=functions.ApplyPatchള്ളcommentary ’établissement to=functions.ApplyPatch  faktycznie-jsonassistant to=functions.ApplyPatch## Test Output Reasoning:
