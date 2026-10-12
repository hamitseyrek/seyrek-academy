# Flutter’a Geçmeden Önce Bilmeniz Gereken Her Şey: Dart Diline Kapsamlı Giriş

**Tek kod tabanıyla mobil uygulama yazmak istiyorsanız, önce Dart’ı iyi kavramak işinizi çok kolaylaştırır. Bu yazıda, sıfırdan sınıflara, fonksiyonlardan closure’lara kadar Dart’ın temelini ve bir adım ötesini örneklerle anlatıyorum.**

---

Flutter ile uygulama geliştirmeye başlamadan önce dilin kendisine aşina olmak, hem hata ayıklarken hem de widget ağacında neyin nerede kullanıldığını anlamanızda büyük fark yaratır. Dart, Google’ın Flutter ile birlikte öne çıkardığı, modern ve okunabilir bir dil: statik tipli, null-safe ve fonksiyonları birinci sınıf vatandaş olarak ele alıyor. Bu yazıda **değişkenlerden başlayıp veri tipleri, koşullar, döngüler, fonksiyonlar, sınıflar, enum’lar, kalıtım, extension’lar** ve **fonksiyonların ileri kullanımı** (closure, tear-off, generator) ile **küçük örnek projeye** kadar tek bir kaynakta topladım. İster derste kaynak olarak kullanın, ister Flutter’a hazırlık için okuyun; elinizin altında tutabileceğiniz bir rehber hedefliyorum.

**Bu yazıda neler var?**
- Dart nedir, neden önemli?
- İlk program: `main()` ve `print`
- Değişkenler, sabitler: `var`, `final`, `const`
- Temel veri tipleri: sayılar, String, bool, List, Set, Map
- Operatörler ve koşullu yapılar
- Döngüler ve fonksiyonlar
- Null safety’e kısa giriş
- Sınıflar, constructor’lar, enum, kalıtım, extension
- Fonksiyonlar derinlemesine: parametre türleri, first-class fonksiyonlar, closure, tear-off, generator’lar
- Örnek uygulama ve kendini test etme soruları

---

## Dart’ı Neden Önemseyelim?

Dart, özellikle **kullanıcı arayüzü** geliştirmeye uygun, modern bir programlama dili. Flutter ile birlikte kullandığınızda:

- **Tek kod tabanı** ile Android, iOS ve diğer platformlara uygulama çıkarabilirsiniz.
- **Statik tipli** ve **null-safety** sayesinde birçok hata derleme aşamasında yakalanır.
- Lambda, koleksiyon operasyonları ve extension’larla hem okunabilir hem esnek kod yazarsınız.

Flutter’a geçmeden önce Dart’ı “temel + bir adım ileri” seviyede öğrenmek, dönüp bakacağınız sağlam bir zemin oluşturur.

---

## İlk Dart Programı

Her Dart uygulaması bir **giriş noktası** ile başlar: `main()` fonksiyonu.

```dart
void main() {
  print('Merhaba Dart!');
}
```

- `main`: Programın çalışmaya başladığı fonksiyon.
- `print`: Konsola çıktı yazdırır.

Bu kadarı bile, neredeyse her Dart/Flutter projesinin en minimal iskeletidir.

---

## Değişkenler ve Sabitler

Dart’ta değişken tanımlarken birkaç seçeneğiniz var:

- **`var`** — Türü derleyici çıkarır.
- **`dynamic`** — Türü çalışma zamanında değişebilir; esnek ama dikkatli kullanmak gerekir.
- **Açık tür** — `int`, `double`, `String`, `bool` vb.
- **`final`** — Bir kez atanır, sonra değişmez (çalışma zamanında belli olabilir).
- **`const`** — Derleme zamanında sabit, değişmez.

**`var` ile:**

```dart
void main() {
  var name = 'Ali';       // String
  var age = 21;           // int
  print(name);
  print(age);
}
```

**Açık tür ile:**

```dart
void main() {
  String name = 'Ayşe';
  int age = 20;
  double pi = 3.14;
  bool isActive = true;
  print('$name, $age yaşında. pi = $pi, aktif: $isActive');
}
```

**`final` ve `const` farkı:**

```dart
void main() {
  final today = DateTime.now();  // run-time'da belli olur
  const pi = 3.14159;            // derleme zamanında sabit
  print('Bugün: $today, pi: $pi');
}
```

- **`final`**: Çalışma anında hesaplanabilir, ama bir kez atandıktan sonra değişmez.
- **`const`**: Değer derleme zamanında bilinir ve sabittir.

---

## Temel Veri Tipleri

**Sayılar: `int`, `double`, `num`**

```dart
void main() {
  int age = 25;
  double temperature = 23.5;
  num score = 10;        // int veya double
  score = 10.5;
  print('Yaş: $age, Sıcaklık: $temperature, Skor: $score');
}
```

**String:**

```dart
void main() {
  String firstName = 'Ali';
  String lastName = "Yılmaz";
  String fullName = '$firstName $lastName';
  print('Merhaba $fullName');

  String longText = '''
Bu birden fazla satırlı
String örneğidir.
''';
  print(longText);
}
```

**bool:**

```dart
void main() {
  bool isActive = true;
  bool isLessonFinished = false;
  print('Aktif: $isActive, Ders bitti mi: $isLessonFinished');
}
```

**Koleksiyonlar: List, Set, Map**

```dart
void main() {
  List<String> names = ['Ali', 'Ayşe', 'Mehmet'];
  Set<int> numbers = {1, 2, 3, 3};    // 3 bir kez
  Map<String, int> grades = { 'Ali': 90, 'Ayşe': 85 };
  print(names);
  print(numbers);
  print(grades);
}
```

---

## Operatörler

Aritmetik: `+`, `-`, `*`, `/`, `~/` (tamsayı bölme), `%`.  
Karşılaştırma: `==`, `!=`, `<`, `>`.  
Mantıksal: `&&`, `||`, `!`.  
Atama ve artırma: `+=`, `++`, `--`.

```dart
void main() {
  int a = 10, b = 3;
  print(a ~/ b);   // 3
  print(a % b);    // 1

  int number = 0;
  number += 5;
  number++;
  print(number);   // 6
}
```

---

## Koşullu Yapılar: if ve switch

**if / else if / else:**

```dart
void main() {
  int grade = 75;
  if (grade >= 90) {
    print('Harf notu: AA');
  } else if (grade >= 80) {
    print('Harf notu: BA');
  } else if (grade >= 70) {
    print('Harf notu: BB');
  } else {
    print('Harf notu: Daha düşük');
  }
}
```

**switch:**

```dart
void main() {
  String day = 'Pazartesi';
  switch (day) {
    case 'Pazartesi':
      print('Haftanın ilk iş günü.');
      break;
    case 'Cumartesi':
    case 'Pazar':
      print('Hafta sonu!');
      break;
    default:
      print('Diğer gün.');
  }
}
```

---

## Döngüler

**for, while, do-while, for-in:**

```dart
void main() {
  for (int i = 0; i < 5; i++) {
    print('i = $i');
  }

  int number = 0;
  while (number < 3) {
    print('while: $number');
    number++;
  }

  List<String> names = ['Ali', 'Ayşe', 'Mehmet'];
  for (var name in names) {
    print('Merhaba $name');
  }
}
```

---

## Fonksiyonlar

**Temel tanım, void, isimli parametreler, arrow:**

```dart
int sum(int a, int b) {
  return a + b;
}

void greet(String name) {
  print('Merhaba $name');
}

void printUserInfo({ required String name, int age = 18 }) {
  print('Ad: $name, Yaş: $age');
}

int square(int x) => x * x;

void main() {
  print(sum(3, 5));
  greet('Ali');
  printUserInfo(name: 'Ayşe');
  printUserInfo(name: 'Mehmet', age: 25);
  print(square(4));   // 16
}
```

---

## Null Safety’e Kısa Giriş

Dart’ta bir değişkenin **null** alıp alamayacağını türle belirtiriz:

- **`int age;`** — `age` null olamaz (atanmalı).
- **`int? age;`** — `age` null veya tam sayı olabilir.

```dart
void main() {
  int? age;
  print(age);        // null
  age = 20;
  int result = age ?? 0;   // null ise 0 kullan
  print(result);
}
```

`?.`, `??`, `!` gibi operatörler ileride işinize yarar; burada sadece fikri verdim.

---

## Sınıflar ve Nesneler (OOP)

**Basit sınıf ve constructor:**

```dart
class Student {
  String name;
  int age;
  Student(this.name, this.age);

  void introduceYourself() {
    print('Merhaba, ben $name, $age yaşındayım.');
  }
}

void main() {
  Student student = Student('Ali', 21);
  student.introduceYourself();
}
```

**Named constructor ve varsayılan değerler:**

```dart
class Student {
  String name;
  int age;
  String department;

  Student(this.name, this.age, this.department);

  Student.nameOnly(this.name)
      : age = 18,
        department = 'Bilinmiyor';
}

void main() {
  var s1 = Student('Ayşe', 20, 'Bilgisayar Mühendisliği');
  var s2 = Student.nameOnly('Mehmet');
  print(s1.department);
  print(s2.department);
}
```

**Getter ve setter:**

```dart
class BankAccount {
  double _balance = 0;
  double get balance => _balance;
  set balance(double value) {
    if (value >= 0) _balance = value;
  }
}
```

---

## Enum

Sabit değer listesi için **enum** kullanırız; özellikle `switch` ile okunabilir kod yazmayı kolaylaştırır.

```dart
enum LectureDay { monday, tuesday, wednesday, thursday, friday }

void main() {
  LectureDay day = LectureDay.monday;
  if (day == LectureDay.friday) {
    print('Haftanın son ders günü!');
  } else {
    print('Ders günü: $day');
  }
}
```

---

## Kalıtım (extends)

Bir sınıf, başka bir sınıftan davranış miras alabilir; metodu yeniden yazmak için **@override** kullanırız.

```dart
class Animal {
  void makeSound() {
    print('Bir hayvan ses çıkarıyor.');
  }
}

class Cat extends Animal {
  @override
  void makeSound() {
    print('Miyav!');
  }
}

void main() {
  Animal a = Animal();
  Cat c = Cat();
  a.makeSound();
  c.makeSound();
}
```

---

## Extension: Mevcut Tiplere Metot Eklemek

Extension ile dilin çekirdeğini değiştirmeden türlere yeni metotlar ekleyebiliriz.

```dart
extension StringExtension on String {
  String reverse() {
    return split('').reversed.join();
  }
}

void main() {
  String text = 'Dart';
  print(text.reverse());   // traD
}
```

---

## Örnek: Not Ortalaması Hesaplayıcı

Aşağıdaki örnek, sınıf, constructor, List ve fonksiyonu bir araya getiriyor:

```dart
class Course {
  String name;
  int credit;
  double grade;   // 0–100

  Course({ required this.name, required this.credit, required this.grade });
}

double calculateAverage(List<Course> courses) {
  if (courses.isEmpty) return 0;
  double totalScore = 0;
  int totalCredit = 0;
  for (var course in courses) {
    totalScore += course.grade * course.credit;
    totalCredit += course.credit;
  }
  return totalScore / totalCredit;
}

void main() {
  var courses = <Course>[
    Course(name: 'Matematik', credit: 4, grade: 80),
    Course(name: 'Programlama', credit: 6, grade: 90),
    Course(name: 'Fizik', credit: 3, grade: 70),
  ];
  double average = calculateAverage(courses);
  print('Ağırlıklı not ortalaması: ${average.toStringAsFixed(2)}');
}
```

---

## Fonksiyonlar Derinlemesine

Bu bölümde Dart’taki fonksiyon modelini biraz daha derinlemesine ele alıyoruz. Resmi dokümantasyon: `https://dart.dev/language/functions`.

### İsimli ve opsiyonel parametreler

İsimli parametreler `{ }`, opsiyonel konumsal parametreler `[]` ile tanımlanır.

```dart
void createUser({
  required String firstName,
  required String lastName,
  int age = 18,
  bool isActive = true,
}) {
  print('Ad: $firstName, Soyad: $lastName, Yaş: $age, Aktif: $isActive');
}

String greet(String name, [String? title]) {
  if (title != null) return 'Merhaba $title $name';
  return 'Merhaba $name';
}

void main() {
  createUser(firstName: 'Ali', lastName: 'Yılmaz', age: 22);
  print(greet('Ali'));
  print(greet('Ayşe', 'Dr.'));
}
```

### main() ve komut satırı argümanları

```dart
void main(List<String> args) {
  print('Argüman sayısı: ${args.length}');
  print(args);
}
```

### Fonksiyonlar birinci sınıf vatandaş

Fonksiyonlar bir değişkene atanabilir, parametre olarak geçilebilir veya başka bir fonksiyondan döndürülebilir.

```dart
void printNumber(int number) {
  print('Sayı: $number');
}

void applyOperation(List<int> numbers, void Function(int) operation) {
  for (var n in numbers) operation(n);
}

Function createMultiplier(int factor) {
  return (int x) => x * factor;
}

void main() {
  var list = [1, 2, 3];
  applyOperation(list, printNumber);

  var multiplyByTwo = createMultiplier(2);
  print(multiplyByTwo(5));   // 10
}
```

### Fonksiyon tipi ve typedef

```dart
typedef BinaryOp = int Function(int x, int y);

int add(int a, int b) => a + b;
int multiply(int a, int b) => a * b;

int apply(int a, int b, BinaryOp op) {
  return op(a, b);
}

void main() {
  print(apply(3, 4, add));       // 7
  print(apply(3, 4, multiply));  // 12
}
```

### Anonim fonksiyonlar ve lambda

```dart
void main() {
  var numbers = [1, 2, 3, 4];
  numbers.forEach((number) {
    print('Sayı: $number');
  });
  numbers.forEach((number) => print('Kısa: $number'));

  var fruits = ['elma', 'armut', 'portakal'];
  fruits.forEach((fruit) {
    var upper = fruit.toUpperCase();
    print('$fruit → $upper');
  });
}
```

### Lexical scope ve closure

```dart
Function createCounter() {
  int counter = 0;
  return () {
    counter++;
    print('Sayaç: $counter');
  };
}

void main() {
  var counter1 = createCounter();
  var counter2 = createCounter();
  counter1();   // Sayaç: 1
  counter1();   // Sayaç: 2
  counter2();   // Sayaç: 1
}
```

### Tear-off: Fonksiyonu referans olarak geçmek

```dart
void printValue(int value) {
  print(value);
}

void main() {
  var list = [10, 20, 30];
  list.forEach(printValue);

  var buffer = StringBuffer();
  list.forEach(buffer.write);
  print(buffer.toString());   // 102030
}
```

### Dönüş değeri ve record

```dart
(String, int) userSummary() {
  return ('Ali', 25);
}

void main() {
  var (name, age) = userSummary();
  print('Ad: $name, Yaş: $age');
}
```

### Generator: sync* ve async*

```dart
Iterable<int> generateNumbers(int n) sync* {
  int k = 0;
  while (k < n) {
    yield k;
    k++;
  }
}

Stream<int> generateNumbersAsync(int n) async* {
  int k = 0;
  while (k < n) {
    await Future.delayed(Duration(milliseconds: 500));
    yield k;
    k++;
  }
}

Iterable<int> countdown(int n) sync* {
  if (n > 0) {
    yield n;
    yield* countdown(n - 1);
  }
}

void main() {
  for (var v in generateNumbers(5)) print(v);   // 0,1,2,3,4
  for (var v in countdown(3)) print(v);        // 3,2,1
}
```

### Örnek: Filtreleme ve dönüştürme

```dart
typedef IntPredicate = bool Function(int);
typedef IntMapper = int Function(int);

List<int> filter(List<int> list, IntPredicate condition) {
  var result = <int>[];
  for (var item in list) {
    if (condition(item)) result.add(item);
  }
  return result;
}

List<int> transform(List<int> list, IntMapper mapper) {
  var result = <int>[];
  for (var item in list) result.add(mapper(item));
  return result;
}

void main() {
  var numbers = [1, 2, 3, 4, 5, 6];
  var evenNumbers = filter(numbers, (n) => n % 2 == 0);
  var squares = transform(numbers, (n) => n * n);
  print('Çift sayılar: $evenNumbers');
  print('Kareler: $squares');
}
```

---

## Kendinizi Test Edin

Aşağıdaki sorular, konuyu ne kadar özümsediğinizi kontrol etmenize yardımcı olur:

1. **`var`**, **`final`** ve **`const`** arasındaki farkları kısaca açıklayın. Hangi durumda hangisini tercih edersiniz?
2. Şu fonksiyonu **isimli parametre** kullanacak şekilde yeniden yazın:  
   `void connect(String host, int port, bool secure) { ... }`
3. **`int? age;`** ve **`int age;`** tanımlarının farkı nedir? Hangisi hangi durumda derleme hatası verir?
4. Bir **`List<int>`** içindeki **tek** sayıları filtreleyip kalanları iki ile çarpan bir fonksiyon yazın; fonksiyon tipini **`typedef`** ile tanımlayın.
5. “Sipariş durumu” gibi bir senaryo için en az 4 değerli bir **enum** tanımlayın ve bir **switch** içinde kullanın.
6. **Closure**: Aşağıdaki kod çalıştırıldığında ekrana ne yazar? Neden?  
   ```dart
   List<Function> createFunctions() {
     var list = <Function>[];
     for (var i = 0; i < 3; i++) {
       list.add(() => print(i));
     }
     return list;
   }
   void main() {
     var funcs = createFunctions();
     funcs.forEach((f) => f());
   }
   ```
7. **`sync*`** ve **`async*`** arasındaki farkı, döndürdükleri türler (Iterable / Stream) üzerinden açıklayın.
8. **String** için şu extension metotlarını yazın: **`isNullOrEmpty()`**, **`reverse()`**, **`wordCount()`** (boşluklara göre kelime sayısı).
9. Aşağıdaki fonksiyonda parametre türlerini (konumsal / isimli / opsiyonel) açıklayın:  
   `void send(String message, { int repeat = 1, bool uppercase = false }) { ... }`
10. **Timer** benzeri bir sınıf tasarlayın: saniye cinsinden süre tutsun; **start()**, **pause()**, **reset()** metotları olsun. En az bir **enum** ve bir **extension** ekleyin.

---

## Özet ve Sonraki Adımlar

Bu yazıda Dart’ın temelini ve bir adım ötesini ele aldık:

- **Temel:** Değişkenler, veri tipleri, operatörler, koşullar, döngüler, fonksiyonlar, null safety.
- **OOP:** Sınıflar, constructor’lar, getter/setter, enum, kalıtım, extension.
- **İleri fonksiyonlar:** İsimli/opsiyonel parametreler, first-class fonksiyonlar, typedef, closure, tear-off, generator’lar.

Tüm kod örneklerini çalıştırıp küçük değişiklikler yaparak denemenizi öneririm. Flutter’a geçtiğinizde widget’ların içinde fonksiyonların callback ve event handler olarak nasıl kullanıldığını fark ettiğinizde, bu yazıdaki fonksiyon ve closure kısmı daha anlamlı gelecektir.

İsterseniz bir sonraki adımda Flutter’da ilk ekranı oluşturma ve state yönetimine giriş konularına da benzer bir rehberle devam edebilirsiniz.

