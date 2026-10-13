# Dart Programlama Dili Temelleri 2: Fonksiyonlar, İsimli Parametreler ve Koleksiyon Operatörleri

**Flutter'da widget ağacını açtığınızda gördüğünüz her satır, aslında Dart fonksiyonları ve kurucu metotlarının bir yansımasıdır.**

İlk iki yazıda mobil ekosistemin temellerini, Flutter mimarisini ve Dart dilinin değişken/koleksiyon yapılarını ele almıştık. Ancak Flutter dünyasına adım attığınızda en çok karşılaşacağınız şey; süslü parantezlerle açılan parametreler (`child:`, `onPressed:`), tıklandığında çalışan geri çağırım (callback) fonksiyonları ve listeleri dönüştüren fonksiyonel operatörlerdir.

Bu yazıda, Flutter kodlarken "Bu süslü parantez ne işe yarıyor?", "Fonksiyonu değişkene nasıl atıyoruz?" veya "Listeyi tek satırda nasıl filtreleriz?" sorularının yanıtlarını VS Code üzerinde canlı kodlama yaparak uygulamalı olarak inceliyoruz.

---

### Bu Yazıda Neler Var?

* **Fonksiyon Tanımları:** Standart fonksiyonlar ve tek satırlık ok fonksiyonları (`fat arrow: =>`)
* **Flutter'ın Sözdizimi Temeli:** Konumsal (Positional) vs. İsimli (Named) Parametreler
* **Opsiyonel ve Zorunlu Alanlar:** `required` ve varsayılan (default) değer kullanımı
* **Birinci Sınıf Fonksiyonlar (First-Class Citizens):** Fonksiyonları değişkene atama ve parametre olarak geçme (Callback mantığı)
* **Fonksiyonel Koleksiyon Operatörleri:** `map`, `where`, `fold` ve `any/every`
* **Mini Laboratuvar:** Terminal üzerinde not filtreleme, dönüştürme ve özet çıkarma motoru

---

## 1. Fonksiyon Yapısı ve Ok Sözdizimi (Fat Arrow)

Dart'ta fonksiyonlar bir dönüş tipi, bir isim, parametre listesi ve gövdeden (`{}`) oluşur. Eğer fonksiyon tek bir satırdan veya ifadeden ibaretse, süslü parantezler yerine ok sözdizimi (`=>`) kullanılır.

VS Code üzerinde `main.dart` dosyamızı açıp terminalden test edelim:

```dart
// Standart fonksiyon
String formatNoteTitle(String title) {
  return title.trim().toUpperCase();
}

// Ok fonksiyonu (Fat Arrow): Tek satırlık dönüşlerde süslü parantez ve return yerine geçer
bool isNoteValid(String title) => title.trim().isNotEmpty;

void main() {
  String rawTitle = '   flutter mimarisi   ';

  if (isNoteValid(rawTitle)) {
    String formatted = formatNoteTitle(rawTitle);
    print('Düzenlenmiş Başlık: $formatted'); // Çıktı: FLUTTER MİMARİSİ
  }
}

```

---

## 2. Flutter'ın Kalbi: Parametre Çeşitleri

Flutter'da bir `Container`, `Text` veya `ElevatedButton` oluştururken parametrelerin nasıl iletildiğini anlamak, kurucu metotların (constructor) arkasındaki Dart mantığını kavramaktan geçer.

Dart'ta parametreler ikiye ayrılır:

### A. Konumsal Parametreler (Positional Parameters)

Argümanların, fonksiyondaki sıraya birebir uyarak girilmesi zorunludur:

```dart
void createNotePositional(String title, String category, int priority) {
  print('Not: $title | Kategori: $category | Öncelik: $priority');
}

void main() {
  // Sıralama kesinlikle bozulamaz: title, category, priority
  createNotePositional('Toplantı', 'İş', 1);
}

```

*Sorun:* Parametre sayısı 4-5'e çıktığında hangi değerin ne anlama geldiği okunamaz hâle gelir.

---

### B. İsimli Parametreler (Named Parameters) — Flutter Yöntemi

Parametreler süslü parantez `{}` içine alınır. Çağrılırken sıranın hiçbir önemi yoktur; değerler parametre adıyla eşleştirilerek verilir. Flutter widget'larının neredeyse tamamı bu yapıyı kullanır.

* Zorunlu kılmak için: `required`
* İsteğe bağlı bırakmak için: `?` (nullable) veya varsayılan değer

```dart
void createNote({
  required String title,          // Zorunlu alan
  String category = 'Genel',      // Girilmezse varsayılan 'Genel' olur
  int priority = 2,               // Girilmezse varsayılan 2 olur
  String? description,            // Nullable: İsteğe bağlı boş geçilebilir
}) {
  print('--- Not Oluşturuldu ---');
  print('Başlık: $title');
  print('Kategori: $category');
  print('Öncelik: $priority');
  print('Açıklama: ${description ?? 'Yok'}');
}

void main() {
  // Parametre sırası serbesttir; isimleriyle çağrılır
  createNote(
    title: 'Ders İzlencesi',
    priority: 1,
    description: 'Bölüm sekreterliğine iletilecek.',
  );

  createNote(
    title: 'Market',
    category: 'Ev',
  );
}

```

> **Flutter Bağlantısı:**
> Flutter'da yazdığımız `Text('Merhaba', style: TextStyle(fontSize: 16))` ifadesinde; `'Merhaba'` konumsal, `style:` ise isimli bir parametredir.

---

## 3. Birinci Sınıf Fonksiyonlar ve Callback (Geri Çaırım) Mekanizması

Dart'ta fonksiyonlar birer veri tipidir; değişkenlere atanabilir, başka fonksiyonlara parametre olarak iletilebilir veya bir fonksiyondan geri döndürülebilir.

Bu yapı, Flutter'da bir butona tıklandığında ne olacağını belirten `onPressed:` veya `onTap:` geri çağırımlarının temelidir.

```dart
// Geri çağırım (callback) tipi tanımlama veya doğrudan Function tipi kullanma
void executeAction(String taskName, Function onComplete) {
  print('Görev başlatıldı: $taskName');
  // ... işlem yapıldı ...
  onComplete(); // İşlem bitince dışarıdan verilen fonksiyonu tetikle
}

void main() {
  // 1. İsimsiz (Anonim) fonksiyonu parametre olarak geçme
  executeAction('Veri İndirme', () {
    print('-> Bildirim: İndirme tamamlandı!');
  });

  // 2. Bir fonksiyonu değişkene atama
  var logger = (String msg) => print('[LOG - ${DateTime.now()}]: $msg');
  logger('Kullanıcı çıkış yaptı.');
}

```

---

## 4. Modern Koleksiyon Operatörleri: `map`, `where`, `fold`

Geleneksel `for` döngüleriyle veri ayıklamak kod kalabalığına ve hata riskine yol açar. Dart; fonksiyonel dillerden aldığı koleksiyon operatörleriyle veriyi dönüştürmeyi tek satıra indirir.

### `where()`: Filtreleme

Bir koşula uyan elemanları ayıklar (SQL'deki `WHERE` mantığı):

```dart
void main() {
  List<int> priorities = [1, 3, 5, 2, 4, 5];

  // Sadece acil olanları (4 ve üzeri) filtrele
  var urgent = priorities.where((p) => p >= 4).toList();
  print('Acil Seviyeler: $urgent'); // [5, 4, 5]
}

```

---

### `map()`: Dönüştürme

Listedeki her bir elemanı alıp başka bir forma dönüştürür. Flutter'da veri listelerini arayüzde widget listesine dönüştürmenin en sık kullanılan yoludur.

```dart
void main() {
  List<String> rawTags = ['dart', 'flutter', 'mobile'];

  // Etiketlerin başına '#' koy ve büyüt
  List<String> formattedTags = rawTags.map((tag) => '#${tag.toUpperCase()}').toList();
  print(formattedTags); // [#DART, #FLUTTER, #MOBILE]
}

```

---

### `fold()`: Kümülatif Hesaplama

Listedeki tüm elemanları gezerek tek bir sonuca indirger (örneğin toplam, çarpım veya özet metin):

```dart
void main() {
  List<int> taskDurations = [15, 30, 45, 10]; // Dakika cinsinden

  // Başlangıç değeri 0; her süreyi toplama ekle
  int totalTime = taskDurations.fold(0, (total, duration) => total + duration);
  print('Toplam Harcanan Süre: $totalTime dakika'); // 100 dakika
}

```

---

## 5. Mini Uygulama Laboratuvarı: Terminalde Not Filtreleme ve Dönüştürme Motoru

Öğrendiğimiz fonksiyonları, isimli parametreleri ve koleksiyon operatörlerini tek bir senaryoda birleştirelim.

Aşağıdaki kod; ham bir veri listesini alır, fonksiyonel filtrelerden geçirir ve kullanıcıya özet bir rapor sunar.

```dart
// Not oluşturucu fonksiyon (İsimli parametreler)
Map<String, dynamic> buildNote({
  required int id,
  required String title,
  required String category,
  required int priority, // 1 (Düşük) - 5 (Kritik)
  bool isCompleted = false,
}) {
  return {
    'id': id,
    'title': title,
    'category': category,
    'priority': priority,
    'isCompleted': isCompleted,
  };
}

// Filtreleme fonksiyonu (Birinci sınıf fonksiyon parametresi alır)
List<Map<String, dynamic>> filterNotes(
  List<Map<String, dynamic>> source,
  bool Function(Map<String, dynamic>) predicate,
) {
  return source.where(predicate).toList();
}

void main() {
  // 1. Veri tabanını simüle eden liste
  List<Map<String, dynamic>> noteList = [
    buildNote(id: 1, title: 'Flutter Kurulumu', category: 'Mobil', priority: 5, isCompleted: true),
    buildNote(id: 2, title: 'Dart İsimli Parametreler', category: 'Mobil', priority: 4),
    buildNote(id: 3, title: 'Market Alışverişi', category: 'Kişisel', priority: 1),
    buildNote(id: 4, title: 'MVVM Mimarisi Tasarımı', category: 'Mobil', priority: 5),
  ];

  // 2. map ile arayüz formatına dönüştürme
  print('=== TÜM NOTLAR (Özet Görünüm) ===');
  var displayList = noteList.map((n) {
    String mark = n['isCompleted'] ? '[Tamamlandı]' : '[Bekliyor]';
    return '$mark ${n['title']} (Kategori: ${n['category']})';
  });
  displayList.forEach(print);

  // 3. where ile acil ve bekleyen işleri filtreleme
  print('\n=== ACİL VE TAMAMLANMAMIŞ MOBİL GÖREVLER ===');
  var pendingUrgentMobile = filterNotes(
    noteList,
    (n) => n['category'] == 'Mobil' && n['priority'] >= 4 && !n['isCompleted'],
  );

  for (var note in pendingUrgentMobile) {
    print('-> Dikkat: ${note['title']} (Öncelik Seviyesi: ${note['priority']})');
  }

  // 4. fold ile bekleyen işlerin toplam öncelik puanını çıkarma
  int pendingPrioritySum = noteList
      .where((n) => !n['isCompleted'])
      .fold(0, (sum, n) => sum + (n['priority'] as int));

  print('\nToplam Bekleyen İş Yükü Puanı: $pendingPrioritySum');
}

```

### Terminal Çıktısı

Terminalde `dart run main.dart` çalıştırıldığında alınan sonuç:

```text
=== TÜM NOTLAR (Özet Görünüm) ===
[Tamamlandı] Flutter Kurulumu (Kategori: Mobil)
[Bekliyor] Dart İsimli Parametreler (Kategori: Mobil)
[Bekliyor] Market Alışverişi (Kategori: Kişisel)
[Bekliyor] MVVM Mimarisi Tasarımı (Kategori: Mobil)

=== ACİL VE TAMAMLANMAMIŞ MOBİL GÖREVLER ===
-> Dikkat: Dart İsimli Parametreler (Öncelik Seviyesi: 4)
-> Dikkat: MVVM Mimarisi Tasarımı (Öncelik Seviyesi: 5)

Toplam Bekleyen İş Yükü Puanı: 10

```

---

## Özet

Bu yazıda şunları netleştirdik:

1. Ok sözdizimi (`=>`) ile tek satırlık pratik fonksiyonlar yazmayı,
2. Flutter widget'larının temelini oluşturan **isimli parametreler (`{required ...}`)** mekanizmasını,
3. Fonksiyonları birinci sınıf vatandaş olarak ele alıp **callback (onPressed/onTap)** akışlarını kurgulamayı,
4. `map`, `where` ve `fold` operatörleriyle listeleri tek satırda dönüştürmeyi ve filtrelemeyi.

Artık verilerimizi fonksiyonel olarak yönetebiliyoruz. Serinin bir sonraki ve Dart bölümünün son yazısında; verilerimizi gevşek `Map` yapılarından kurtarıp sağlam bir mimariye oturtmak için **Nesne Yönelimli Programlama (OOP), Model Sınıfları, JSON Dönüşümleri ve Enum Yapıları** konusunu ele alacağız.