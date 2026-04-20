# Dart Fonksiyon Problem Seti Çözümleri

Bu doküman, **`4S- Dart Fonksiyon Problem Seti.md`** içindeki soruların örnek çözümlerini ve kısa açıklamalarını içerir.  
Kodlar Dart dilinde, **değişken/fonksiyon/sınıf isimleri İngilizce**, açıklamalar ve çıktılar Türkçe olacak şekilde yazılmıştır.

Not: Buradaki çözümler **birer örnek**tir; eşdeğer farklı implementasyonlar da doğru kabul edilebilir.

---

## 1. Basit Toplama Fonksiyonu

**Soru:** `sumTwoNumbers(int a, int b)` fonksiyonunu yazın.

**Çözüm:**

```dart
int sumTwoNumbers(int a, int b) {
  return a + b;
}

void main() {
  int result = sumTwoNumbers(3, 5);
  print('Toplam: $result'); // Toplam: 8
}
```

**Açıklama:**  
Fonksiyon iki `int` alıp doğrudan toplar ve `int` döndürür; en temel saf fonksiyon örneği.

---

## 2. Maksimumu Bulma

**Soru:** `maxOfThree(int a, int b, int c)` en büyük sayıyı döndürsün.

**Çözüm:**

```dart
int maxOfThree(int a, int b, int c) {
  int max = a;
  if (b > max) {
    max = b;
  }
  if (c > max) {
    max = c;
  }
  return max;
}

void main() {
  print(maxOfThree(3, 10, 7)); // 10
}
```

**Açıklama:**  
`max` değişkeniyle başlayıp `if` bloklarıyla güncelleyerek en büyük değeri buluyoruz.

---

## 3. Liste İçindeki Çift Sayıları Sayma

**Soru:** `countEvenNumbers(List<int> values)` fonksiyonu.

**Çözüm:**

```dart
int countEvenNumbers(List<int> values) {
  int count = 0;
  for (var value in values) {
    if (value % 2 == 0) {
      count++;
    }
  }
  return count;
}

void main() {
  print(countEvenNumbers([1, 2, 3, 4, 5, 6])); // 3
}
```

**Açıklama:**  
Her elemanı mod 2 ile kontrol edip eşitse sayacı artırıyoruz.

---

## 4. String Ters Çevirme

**Soru:** `reverseString(String input)` fonksiyonu.

**Çözüm:**

```dart
String reverseString(String input) {
  return input.split('').reversed.join();
}

void main() {
  print(reverseString('Dart')); // traD
}
```

**Açıklama:**  
`split('')` ile karakter listesi, `reversed` ile tersine çevirme, `join()` ile tekrar string haline getirme.

---

## 5. Palindrom Kontrolü

**Soru:** `isPalindrome(String text)` büyük/küçük harf duyarsız çalışsın.

**Çözüm:**

```dart
bool isPalindrome(String text) {
  String normalized = text.toLowerCase();
  String reversed = normalized.split('').reversed.join();
  return normalized == reversed;
}

void main() {
  print(isPalindrome('Kayak')); // true
  print(isPalindrome('test'));  // false
}
```

**Açıklama:**  
Önce `toLowerCase()` ile normalize edip sonra tersini alıp karşılaştırıyoruz.

---

## 6. Faktöriyel Hesabı

**Soru:** İteratif ve recursive faktöriyel.

**Çözüm (iteratif):**

```dart
int factorialIterative(int n) {
  int result = 1;
  for (int i = 1; i <= n; i++) {
    result *= i;
  }
  return result;
}
```

**Çözüm (recursive):**

```dart
int factorialRecursive(int n) {
  if (n <= 1) {
    return 1;
  }
  return n * factorialRecursive(n - 1);
}

void main() {
  print(factorialIterative(5));  // 120
  print(factorialRecursive(5));  // 120
}
```

**Açıklama:**  
0 ve 1 için 1 döndürmek, recursive versiyonda temel durumdur.

---

## 7. Ortalama Hesaplama

**Soru:** `calculateAverage(List<double> values)`.

**Çözüm:**

```dart
double calculateAverage(List<double> values) {
  if (values.isEmpty) return 0.0;

  double sum = 0;
  for (var value in values) {
    sum += value;
  }
  return sum / values.length;
}

void main() {
  print(calculateAverage([10, 20, 30])); // 20.0
}
```

**Açıklama:**  
Boş liste kontrolü önemli; aksi halde 0’a bölme hatası olabilir.

---

## 8. Map Üzerinden Not Hesabı

**Soru:** `findTopStudent(Map<String, int> grades)`.

**Çözüm:**

```dart
String? findTopStudent(Map<String, int> grades) {
  String? topName;
  int? topGrade;

  grades.forEach((name, grade) {
    if (topGrade == null || grade > topGrade!) {
      topGrade = grade;
      topName = name;
    }
  });

  return topName;
}

void main() {
  Map<String, int> grades = {
    'Ali': 80,
    'Ayşe': 95,
    'Mehmet': 70,
  };
  print(findTopStudent(grades)); // Ayşe
}
```

**Açıklama:**  
İlk değer için `topGrade == null` kontrolüyle başlangıç yapıyoruz.

---

## 9. Higher-Order: applyToList

**Soru:** `List<int> applyToList(List<int> values, int Function(int) operation)`.

**Çözüm:**

```dart
List<int> applyToList(List<int> values, int Function(int) operation) {
  List<int> result = [];
  for (var value in values) {
    result.add(operation(value));
  }
  return result;
}

int square(int x) => x * x;

void main() {
  var numbers = [1, 2, 3];
  var squares = applyToList(numbers, square);
  print(squares); // [1, 4, 9]
}
```

**Açıklama:**  
Higher-order fonksiyonun klasik örneği: işlemi dışarıdan alıyoruz.

---

## 10. Higher-Order: filterList

**Soru:** `filterList(List<int> values, bool Function(int) test)`.

**Çözüm:**

```dart
List<int> filterList(List<int> values, bool Function(int) test) {
  List<int> result = [];
  for (var value in values) {
    if (test(value)) {
      result.add(value);
    }
  }
  return result;
}

void main() {
  var numbers = [1, 2, 3, 4, 5, 6];
  var evens = filterList(numbers, (n) => n % 2 == 0);
  var greaterThanThree = filterList(numbers, (n) => n > 3);

  print(evens);           // [2, 4, 6]
  print(greaterThanThree); // [4, 5, 6]
}
```

**Açıklama:**  
Burada `test` fonksiyonu filtre kriterini soyutluyor; fonksiyonel programlama tarzına giriş.

---

## 11. Higher-Order: createMultiplier

**Soru:** `createMultiplier(int factor)` size `int Function(int)` döndürsün.

**Çözüm:**

```dart
Function createMultiplier(int factor) {
  return (int x) => x * factor;
}

void main() {
  var doubleFn = createMultiplier(2);
  var tripleFn = createMultiplier(3);

  print(doubleFn(5)); // 10
  print(tripleFn(5)); // 15
}
```

**Açıklama:**  
`factor` dış kapsamda; dönen fonksiyon bu değişkeni “hatırlıyor” (closure).

---

## 12. composeStringTransformers

**Soru:** İki `String Function(String)` alıp bileşimlerini döndüren fonksiyon.

**Çözüm:**

```dart
String Function(String) composeStringTransformers(
  String Function(String) first,
  String Function(String) second,
) {
  return (String input) {
    return second(first(input));
  };
}

String toUpper(String s) => s.toUpperCase();
String addExclamation(String s) => '$s!';

void main() {
  var composed = composeStringTransformers(toUpper, addExclamation);
  print(composed('dart')); // DART!
}
```

**Açıklama:**  
Fonksiyon kompozisyonu: çıktı, önce `first`, sonra `second`’dan geçiyor.

---

## 13. reduceList

**Soru:** `reduceList(List<int> values, int initial, int Function(int, int) combine)`.

**Çözüm:**

```dart
int reduceList(
  List<int> values,
  int initialValue,
  int Function(int accumulator, int element) combine,
) {
  int acc = initialValue;
  for (var element in values) {
    acc = combine(acc, element);
  }
  return acc;
}

void main() {
  var numbers = [1, 2, 3, 4];

  int sum = reduceList(numbers, 0, (acc, e) => acc + e);
  int max = reduceList(numbers, numbers.first, (acc, e) => acc > e ? acc : e);

  print(sum); // 10
  print(max); // 4
}
```

**Açıklama:**  
Klasik reduce katlaması; `acc`’i her adımda `combine` ile güncelliyoruz.

---

## 14. Closure: createCounter

**Soru:** `createCounter` size `void Function()` döndürsün.

**Çözüm:**

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

**Açıklama:**  
Her `createCounter` çağrısı için ayrı bir `counter` saklanır; closure kavramının net örneği.

---

## 15. Liste İstatistikleri (min, max, average)

**Soru:** `(int min, int max, double average) calculateStats(List<int> values)`.

**Çözüm:**

```dart
(int min, int max, double average) calculateStats(List<int> values) {
  if (values.isEmpty) {
    return (0, 0, 0.0);
  }

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

void main() {
  var stats = calculateStats([10, 20, 5, 40]);
  print('Min: ${stats.min}, Max: ${stats.max}, Avg: ${stats.average}');
}
```

**Açıklama:**  
Record kullanımı; `stats.min` gibi isimli alanlarla okunabilirlik artıyor.

---

## 16. Öğrenci Not Sistemi

**Soru:** `Student` sınıfı için ortalama ve en iyi öğrenciyi bulma.

**Çözüm:**

```dart
class Student {
  String name;
  List<int> grades;

  Student({
    required this.name,
    required this.grades,
  });
}

double calculateStudentAverage(Student student) {
  if (student.grades.isEmpty) return 0.0;
  int sum = 0;
  for (var grade in student.grades) {
    sum += grade;
  }
  return sum / student.grades.length;
}

Student? findBestStudent(List<Student> students) {
  if (students.isEmpty) return null;

  Student best = students.first;
  double bestAverage = calculateStudentAverage(best);

  for (var student in students.skip(1)) {
    double avg = calculateStudentAverage(student);
    if (avg > bestAverage) {
      best = student;
      bestAverage = avg;
    }
  }

  return best;
}

void main() {
  var students = [
    Student(name: 'Ali', grades: [80, 90]),
    Student(name: 'Ayşe', grades: [95, 100]),
    Student(name: 'Mehmet', grades: [70, 75]),
  ];

  var best = findBestStudent(students);
  if (best != null) {
    print('En iyi öğrenci: ${best.name}');
  }
}
```

**Açıklama:**  
Ortalama fonksiyonunu ayrı tutmak, hem tekrar kullanımı hem de test etmeyi kolaylaştırır.

---

## 17. Ürün Filtreleme

**Soru:** `filterProductsByPrice(List<Product> products, bool Function(Product) test)`.

**Çözüm:**

```dart
class Product {
  String name;
  double price;

  Product({required this.name, required this.price});
}

List<Product> filterProductsByPrice(
  List<Product> products,
  bool Function(Product) test,
) {
  List<Product> result = [];
  for (var product in products) {
    if (test(product)) {
      result.add(product);
    }
  }
  return result;
}

void main() {
  var products = [
    Product(name: 'Kalem', price: 10),
    Product(name: 'Defter', price: 30),
    Product(name: 'Kulaklık', price: 150),
  ];

  var cheap = filterProductsByPrice(products, (p) => p.price < 50);
  var midRange = filterProductsByPrice(products, (p) => p.price >= 50 && p.price <= 200);

  print('Ucuz ürünler: ${cheap.map((p) => p.name).toList()}');
  print('Orta seviye ürünler: ${midRange.map((p) => p.name).toList()}');
}
```

**Açıklama:**  
`test` fonksiyonu koşulu soyutluyor; aynı fonksiyon farklı filtre senaryoları için kullanılabiliyor.

---

## 18. Todo List – Higher-Order ile

**Soru:** Completed/pending todo’lar ve generic bir yazdırma fonksiyonu.

**Çözüm:**

```dart
class Todo {
  String title;
  bool isDone;

  Todo({
    required this.title,
    this.isDone = false,
  });
}

List<Todo> filterTodos(
  List<Todo> todos,
  bool Function(Todo) test,
) {
  List<Todo> result = [];
  for (var todo in todos) {
    if (test(todo)) {
      result.add(todo);
    }
  }
  return result;
}

List<Todo> getCompletedTodos(List<Todo> todos) =>
    filterTodos(todos, (t) => t.isDone);

List<Todo> getPendingTodos(List<Todo> todos) =>
    filterTodos(todos, (t) => !t.isDone);

void printTodoTitles(
  List<Todo> todos,
  bool Function(Todo) filter,
) {
  var filtered = filterTodos(todos, filter);
  for (var todo in filtered) {
    print(todo.title);
  }
}

void main() {
  var todos = [
    Todo(title: 'Dart çalış', isDone: true),
    Todo(title: 'Flutter ekranı yaz', isDone: false),
    Todo(title: 'Git commit at', isDone: true),
  ];

  print('Tamamlananlar:');
  printTodoTitles(todos, (t) => t.isDone);

  print('Bekleyenler:');
  printTodoTitles(todos, (t) => !t.isDone);
}
```

**Açıklama:**  
Tekrarlayan filtreleme kodunu `filterTodos`’ta topladık; diğer fonksiyonlar bunu kullanıyor.

---

## 19. StringProcessor – Pipeline

**Soru:** Bir dizi string transform fonksiyonunu sırayla uygulayan sınıf.

**Çözüm:**

```dart
class StringProcessor {
  final List<String Function(String)> _operations;

  StringProcessor(this._operations);

  String process(String input) {
    String result = input;
    for (var operation in _operations) {
      result = operation(result);
    }
    return result;
  }
}

String trimText(String text) => text.trim();
String toUpper(String text) => text.toUpperCase();
String addInfoPrefix(String text) => 'INFO: $text';

void main() {
  var processor = StringProcessor([
    trimText,
    toUpper,
    addInfoPrefix,
  ]);

  String raw = '   sistem başlatıldı   ';
  String processed = processor.process(raw);

  print(processed); // INFO: SISTEM BAŞLATILDI
}
```

**Açıklama:**  
Her operation bir fonksiyon; pipeline mantığıyla girdi sırayla tüm fonksiyonlardan geçiyor.

---

## 20. Basit Hesap Makinesi – operate ile

**Soru:** `add`, `subtract`, `multiply`, `divide`, `operate`.

**Çözüm:**

```dart
int add(int a, int b) => a + b;
int subtract(int a, int b) => a - b;
int multiply(int a, int b) => a * b;

double divide(int a, int b) {
  if (b == 0) {
    throw ArgumentError('Sıfıra bölme hatası');
  }
  return a / b;
}

int operate(int a, int b, int Function(int, int) operation) {
  return operation(a, b);
}

void main() {
  int x = 10;
  int y = 5;

  print('Toplam: ${operate(x, y, add)}');        // 15
  print('Fark: ${operate(x, y, subtract)}');     // 5
  print('Çarpım: ${operate(x, y, multiply)}');   // 50

  print('Bölüm: ${divide(x, y)}');               // 2.0

  // Farklı bir operation inline olarak tanımlanabilir:
  int mod(int a, int b) => a % b;
  print('Mod: ${operate(x, y, mod)}');           // 0
}
```

**Açıklama:**  
`operate` fonksiyonu, hesaplamayı soyutlayıp hangi işlemin yapılacağını dışarıdan alıyor. Bu, callback mantığını ve fonksiyon referanslarını pekiştirmek için iyi bir örnek.

---

Bu çözümler, 4. hafta boyunca fonksiyon ve higher-order fonksiyon kavramlarını pekiştirmek için referans olarak kullanılabilir. Öğrencilerden, burada verilen çözümleri bire bir yazmak yerine **önce kendi denemelerini** yapmalarını, daha sonra bu dokümanla karşılaştırmalarını isteyebilirsiniz.***
