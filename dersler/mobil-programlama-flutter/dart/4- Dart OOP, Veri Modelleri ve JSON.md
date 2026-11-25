# Dart Programlama Dili Temelleri 3: Nesne Yönelimli Programlama, Veri Modelleri ve JSON Dönüşümleri

**Ham `Map` yapılarıyla mobil uygulama yönetilmez. Gerçek dünyada tip güvenliği, veri modelleri ve temiz mimari konuşur.**

Serinin ilk yazısında değişkenleri, koleksiyonları ve Sound Null Safety mekanizmasını incelemiştik. İkinci yazıda ise fonksiyonel yetenekleri, Flutter widget sözdiziminin temeli olan isimli parametreleri (`named parameters`) ve `map/where` operatörlerini ele aldık.

Ancak bir mobil uygulama büyüdükçe verileri `note['title']` gibi anahtarlarla (Map) yönetmek büyük bir teknik borç ve çökme riski yaratır: Yanlış yazılan tek bir harf (`title` yerine `tittle`) uygulamanın sessizce bozulmasına yol açar.

Bu yazıda; ham verileri tip güvenli sınıflara dönüştürmeyi, Flutter'ın `const` widget mimarisinin temelini, durumları güvenceye alan `enum` yapılarını, extension metotlarını ve REST API'lerle konuşurken olmazsa olmazımız olan **JSON Serialization (`fromJson` / `toJson`)** adımlarını VS Code üzerinde uygulamalı olarak inceliyoruz.

---

### Bu Yazıda Neler Var?

* **Sınıflar ve Kurucu Metotlar (Constructors):** Üretici yapılar ve `this` kullanımı
* **Flutter'ın Performans Sırrı:** `const` Constructor mantığı ve bellek optimizasyonu
* **Veri Modelleri (Model Classes):** `Map` yapılarını tip güvenli sınıflara dönüştürme
* **JSON Serialization:** `fromJson` fabrikası (factory) ve `toJson` metodu
* **Tip Güvenli Durumlar:** `enum` yapıları ile çalışma
* **Extension Metotları:** Mevcut sınıflara yeni yetenekler kazandırma
* **Mini Laboratuvar:** API simülasyonundan gelen JSON verisini parse eden ve yöneten model motoru

---

## 1. Sınıf Tanımı ve Kurucu Metotlar (Constructors)

Dart'ta sınıflar `class` anahtar kelimesiyle tanımlanır. Sınıfın alanları (`fields`) ve bu alanları başlatan kurucu metotları (`constructor`) bulunur.

İkinci yazıda öğrendiğimiz **isimli parametreler (`{}`)**, model sınıflarında da birebir kullanılır:

```dart
class Note {
  final int id;
  final String title;
  final String description;
  final bool isCompleted;

  // Standart İsimli Kurucu (Constructor)
  Note({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
  });

  // Metot
  void toggleStatus() {
    print('$title notunun durumu güncellendi.');
  }
}

void main() {
  final note1 = Note(
    id: 1,
    title: 'Flutter Öğren',
    description: 'Widget mimarisi incelenecek.',
  );

  print('Not Başlığı: ${note1.title}');
  print('Tamamlandı mı: ${note1.isCompleted}');
}

```

---

## 2. Flutter’ın Performans Sırrı: `const` Constructor

Flutter kodlarken linter sürekli `const Text('...')` veya `const SizedBox()` yazmanızı önerir. Bunun nedeni bellek optimizasyonudur.

Eğer bir sınıfın tüm alanları `final` ise, kurucu metodun başına `const` eklenebilir. Bu sayede derleyici, aynı parametrelerle üretilen nesneleri bellekte tek bir yerde tutar ve Flutter ekranı yeniden çizildiğinde (rebuild) bu nesneleri sıfırdan oluşturmaz.

```dart
class PriorityBadge {
  final String label;
  final int level;

  // const kurucu: Tüm alanlar final olmalıdır
  const PriorityBadge({
    required this.label,
    required this.level,
  });
}

void main() {
  // Bellekte iki ayrı nesne değil, tek bir referans oluşturulur:
  const badge1 = PriorityBadge(label: 'Acil', level: 5);
  const badge2 = PriorityBadge(label: 'Acil', level: 5);

  print(identical(badge1, badge2)); // Çıktı: true (Aynı bellek adresi!)
}

```

---

## 3. Durum Yönetiminde Güvenlik: `enum`

Notların öncelik seviyesini veya durumunu metin (`'acil'`, `'normal'`) olarak tutmak hataya açıktır. Klavyeden yanlış bir harf girildiğinde tüm mantık çöker. `enum`, sadece izin verilen seçeneklerin seçilmesini garanti eder.

```dart
enum Priority {
  low,
  medium,
  high,
}

class Task {
  final String title;
  final Priority priority;

  Task({required this.title, required this.priority});
}

void main() {
  final myTask = Task(title: 'Rapor hazırla', priority: Priority.high);

  switch (myTask.priority) {
    case Priority.low:
      print('Acelesi yok.');
      break;
    case Priority.medium:
      print('Gün içinde tamamla.');
      break;
    case Priority.high:
      print('-> Kritik: Hemen ilgilen!');
      break;
  }
}

```

---

## 4. REST API ve Yerel Veri Köprüsü: JSON Serialization

Gerçek bir mobil uygulamada veriler sunucudan (REST API) veya yerel veri tabanından ham JSON formatında gelir:

```json
{"id": 101, "title": "API Entegrasyonu", "is_completed": true}

```

Bu JSON verisi Dart tarafında önce bir `Map<String, dynamic>` yapısına dönüşür; ardından model sınıfımıza aktarılır. Bu dönüşümü sağlamak için iki standart yapı kullanılır:

1. `factory Note.fromJson(Map<String, dynamic> json)`: Ham haritayı alıp `Note` nesnesi üretir.
2. `Map<String, dynamic> toJson()`: Nesneyi sunucuya göndermek üzere tekrar `Map` yapısına çevirir.

```dart
class Note {
  final int id;
  final String title;
  final bool isCompleted;

  Note({
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  // 1. JSON'dan Nesneye (Factory Constructor)
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as int,
      title: json['title'] as String,
      isCompleted: json['is_completed'] as bool? ?? false, // Güvenli fallback
    );
  }

  // 2. Nesneden JSON'a
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'is_completed': isCompleted,
    };
  }
}

```

---

## 5. Extension Metotları ile Sınıflara Güç Katma

Bazen var olan bir sınıfın (örneğin Dart'ın kendi `String` veya `DateTime` sınıflarının) içine yeni bir fonksiyon eklemek isteriz. Dart'ın **extension** özelliği, kaynak koduna dokunmadan sınıflara metot eklememizi sağlar.

```dart
// String sınıfına ilk harfi büyütme yeteneği ekleyelim
extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

// DateTime sınıfına okunabilir format yeteneği ekleyelim
extension DateFormatting on DateTime {
  String toReadableDate() => '$day/$month/$year';
}

void main() {
  String rawName = 'flutter';
  print(rawName.capitalize()); // Çıktı: Flutter

  DateTime today = DateTime.now();
  print(today.toReadableDate()); // Çıktı: 13/10/2026
}

```

---

## 6. Mini Uygulama Laboratuvarı: Uçtan Uca Model ve API Simülasyonu

Öğrendiğimiz tüm OOP yapılarını, `enum`, `extension`, `fromJson` ve ikinci makaledeki koleksiyon operatörlerini bir araya getiren kapsamlı bir laboratuvar yazalım.

VS Code'da `main.dart` dosyanıza şu kodu ekleyip `dart run main.dart` komutuyla çalıştırın:

```dart
// 1. Öncelik Seviyesi Enum
enum Priority { low, medium, high }

// 2. Enum için Extension (Görsel etiket üretimi)
extension PriorityExtension on Priority {
  String get label {
    switch (this) {
      case Priority.low:
        return 'Düşük';
      case Priority.medium:
        return 'Normal';
      case Priority.high:
        return 'Kritik';
    }
  }
}

// 3. Profesyonel Model Sınıfı
class NoteModel {
  final int id;
  final String title;
  final Priority priority;
  final bool isCompleted;
  final DateTime createdAt;

  const NoteModel({
    required this.id,
    required this.title,
    required this.priority,
    required this.isCompleted,
    required this.createdAt,
  });

  // REST API'den gelen veriyi parse eden fabrika kurucu
  factory NoteModel.fromJson(Map<String, dynamic> json) {
    // String önceliği enum tipine güvenli eşleme
    Priority parsedPriority;
    switch (json['priority'] as String?) {
      case 'high':
        parsedPriority = Priority.high;
        break;
      case 'medium':
        parsedPriority = Priority.medium;
        break;
      default:
        parsedPriority = Priority.low;
    }

    return NoteModel(
      id: json['id'] as int,
      title: json['title'] as String,
      priority: parsedPriority,
      isCompleted: json['is_completed'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  // Sunucuya veya yerel depolamaya gönderim formatı
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'priority': priority.name,
      'is_completed': isCompleted,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // İmmutable veri güncelleme için kopya üretici (copy-with)
  NoteModel copyWith({bool? isCompleted}) {
    return NoteModel(
      id: id,
      title: title,
      priority: priority,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
    );
  }
}

void main() {
  // Simüle Edilmiş REST API Yanıtı (Ham JSON Listesi)
  final List<Map<String, dynamic>> apiResponse = [
    {
      'id': 1,
      'title': 'Mimari şablonunu belirle',
      'priority': 'high',
      'is_completed': false,
      'created_at': '2026-10-10T10:00:00Z',
    },
    {
      'id': 2,
      'title': 'Widget testlerini yaz',
      'priority': 'medium',
      'is_completed': true,
      'created_at': '2026-10-11T12:30:00Z',
    },
    {
      'id': 3,
      'title': 'App icon ve splash ekle',
      'priority': 'low',
      'is_completed': false,
      'created_at': '2026-10-12T09:15:00Z',
    },
  ];

  print('=== 1. API VERİSİNİ TİP GÜVENLİ NESNELERE DÖNÜŞTÜRME ===');
  // map operatörü ile ham haritaları Model nesnelerine çeviriyoruz
  List<NoteModel> notes = apiResponse.map((json) => NoteModel.fromJson(json)).toList();

  for (var note in notes) {
    String check = note.isCompleted ? '[Tamamlandı]' : '[Bekliyor]';
    print('$check #${note.id} ${note.title} (Öncelik: ${note.priority.label})');
  }

  print('\n=== 2. KRİTİK GÖREVLERİ FİLTRELEME ===');
  var urgentTasks = notes.where((n) => n.priority == Priority.high && !n.isCompleted);
  for (var task in urgentTasks) {
    print('-> Acil Eylem Gerekli: ${task.title}');
  }

  print('\n=== 3. DURUM GÜNCELLEME VE JSON ÇIKTISI ===');
  // 1 numaralı notu tamamlandı olarak işaretle (copyWith ile)
  NoteModel updatedNote = notes.first.copyWith(isCompleted: true);
  print('Güncellenen Notun JSON Formatı (Sunucuya Gidecek Veri):');
  print(updatedNote.toJson());
}

```

### Terminal Çıktısı

```text
=== 1. API VERİSİNİ TİP GÜVENLİ NESNELERE DÖNÜŞTÜRME ===
[Bekliyor] #1 Mimari şablonunu belirle (Öncelik: Kritik)
[Tamamlandı] #2 Widget testlerini yaz (Öncelik: Normal)
[Bekliyor] #3 App icon ve splash ekle (Öncelik: Düşük)

=== 2. KRİTİK GÖREVLERİ FİLTRELEME ===
-> Acil Eylem Gerekli: Mimari şablonunu belirle

=== 3. DURUM GÜNCELLEME VE JSON ÇIKTISI ===
Güncellenen Notun JSON Formatı (Sunucuya Gidecek Veri):
{id: 1, title: Mimari şablonunu belirle, priority: high, is_completed: true, created_at: 2026-10-10T10:00:00.000Z}

```

---

## Özet ve Dart Bölümünün Kapanışı

Bu 3 makalelik Dart serisinde adım adım şunları inşa ettik:

1. **Bölüm 1:** Temel tipleri, `final`/`const` farkını, koleksiyonları ve Sound Null Safety mimarisini kavradık.
2. **Bölüm 2:** İsimli parametrelerle Flutter widget sözdizimini öğrendik, callback mantığını ve koleksiyon dönüştürücülerini (`map`, `where`, `fold`) yazdık.
3. **Bölüm 3:** Ham haritaları bırakıp tip güvenli model sınıfları, `const` optimizasyonu, `enum` güvenliği ve REST API'lerin can damarı olan JSON dönüşümlerini inşa ettik.
