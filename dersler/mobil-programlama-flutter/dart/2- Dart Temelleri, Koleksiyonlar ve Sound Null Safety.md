# Dart Programlama Dili Temelleri: Değişkenler, Koleksiyonlar ve Null Safety

**Tek kod tabanıyla mobil uygulama yazmak istiyorsanız, önce Dart’ı iyi kavramak işinizi inanılmaz derecede kolaylaştırır.**

Flutter ile uygulama geliştirmeye başlamadan önce dilin kendisine aşina olmak; hem hata ayıklarken hem de widget ağacında neyin nerede kullanıldığını anlamada büyük fark yaratır. Birçok geliştirici doğrudan widget ağacına dalıp ilk form doğrulamasında veya veri listeleme adımında dilin temellerine takılır. Dart, Google’ın modern ve kullanıcı arayüzü geliştirmeye odaklı olarak tasarladığı güçlü bir dil: statik tipli, null-safe ve okunabilirliği yüksek.

Bu yazıda, Dart’ın temelini oluşturan **değişkenler, sabitler, akış kontrolü, List/Map koleksiyonları ve modern dillerin en kritik güvenlik mekanizması olan Sound Null Safety mimarisini** VS Code üzerinde canlı kodlama yaparak inceliyoruz.

### Bu Yazıda Neler Var?

* **Çalışma Ortamı:** VS Code ile Dart çalıştırma (`main` fonksiyonu ve `dart run`)
* **Değişkenler ve Sabitler:** `var`, tip güvenliği, `final` ve `const` farkı
* **Akış Kontrolü:** `if-else`, ternary (`? :`) ve `switch-case`
* **Koleksiyonlar:** Dinamik listeler (`List`) ve anahtar-değer haritaları (`Map`)
* **Sound Null Safety:** `?`, `?.`, `??` ve `!` operatörleriyle çökmesiz kod yazımı
* **Mini Laboratuvar:** Terminalde çalışan not listesi filtreleme uygulaması

---

1. ## Çalışma Ortamı: VS Code ile Dart Dosyası Çalıştırma



Tarayıcı tabanlı araçlar yerine doğrudan terminal ve editörle çalışmak en temiz yoldur.

1. VS Code'u açın ve boş bir klasör oluşturun (örneğin: `dart_basics`).
2. Klasör içine `main.dart` adında bir dosya ekleyin.
3. VS Code terminalini açın (`Ctrl + \`` veya `Cmd + ``).
4. Yazdığınız kodları çalıştırmak için terminale şu komutu yazmanız yeterlidir:

```bash
dart run main.dart


```

Dart'ta her uygulamanın başlangıç noktası `main()` fonksiyonudur:

```dart
void main() {
  print('Dart ortamı hazır.');
}


```

---

## 2. Değişkenler, Sabitler ve Tip Güvenliği

Dart **statik tipli (statically typed)** bir dildir. Bu, bir değişkenin hangi veri türünü tutacağının derleme aşamasında bilinmesi anlamına gelir.

* `int`: Tam sayılar (`10`, `-3`).
* `double`: Ondalıklı sayılar (`3.14`, `10.5`).
* `String`: Metin dizileri (`'Flutter'`, `"Mobil"`).
* `bool`: Mantıksal değerler (`true`, `false`).
* `var`: Tür çıkarımı (type inference). Değişkenin türü atanan ilk değerden otomatik anlaşılır.

### Kod Örneği: `main.dart`

```dart
void main() {
  // Açık tip tanımı
  String appName = 'Not Defteri';
  int totalNotes = 5;
  double appVersion = 1.2;
  bool isDarkMode = true;

  // 'var' kullanımı: Türü Dart kendisi belirler (burada String olur)
  var author = 'Hamit Seyrek';
  // author = 100; // HATA! Bir kez String olan değişken sayıya dönüştürülemez.

  // String Interpolation ($ ve ${})
  print('Uygulama: $appName v$appVersion');
  print('Toplam Not Sayısı: $totalNotes');
  print('Koyu Mod Açık mı: $isDarkMode');
  print('Yazar adı uzunluğu: ${author.length} karakter');
}


```

### `final` ve `const` Farkı

Her iki anahtar kelime de değeri sonradan değiştirilemeyen değişkenler tanımlar. Ancak bellek ve derleme zamanı açısından önemli bir farkları vardır:

* **`const` (Compile-time constant):** Değeri **kod derlenirken** kesin olarak bilinen sabitlerdir.
* **`final` (Run-time constant):** Değeri uygulama **çalıştığı anda** belirlenen ve bir daha değiştirilemeyen sabitlerdir (örneğin API'den gelen kullanıcı ID'si veya o anki saat).

```dart
void main() {
  const double pi = 3.14159; // Derleme anında bellidir.
  final DateTime loginTime = DateTime.now(); // Kod çalıştığı anda belirlenir.

  // pi = 3.14; // HATA!
  // loginTime = DateTime.now(); // HATA!

  print('PI: $pi');
  print('Oturum Açma Saati: $loginTime');
}


```

---

## 3. Akış Kontrolü: Karar Yapıları ve Döngüler

### `if - else` ve Ternary Operatörü

Uygulama durumuna göre farklı ekranlar veya mesajlar göstermek için kullanılır:

```dart
void main() {
  int noteCount = 0;

  // Standart if-else
  if (noteCount > 0) {
    print('Ekran: $noteCount adet not listeleniyor.');
  } else {
    print('Ekran: Henüz hiç not eklenmemiş (Boş durum).');
  }

  // Ternary operatörü (tek satırda koşul): koşul ? doğruysa : yanlışsa
  String badgeColor = noteCount > 0 ? 'Mavi' : 'Gri';
  print('Rozet Rengi: $badgeColor');
}


```

### `switch - case`

Belirli durumların ayrıştırılmasında temiz bir sözdizimi sunar:

```dart
void main() {
  String currentStatus = 'archived'; // 'active', 'archived', 'deleted'

  switch (currentStatus) {
    case 'active':
      print('Not ana ekranda gösteriliyor.');
      break;
    case 'archived':
      print('Not arşiv kutusunda.');
      break;
    case 'deleted':
      print('Not çöp kutusunda.');
      break;
    default:
      print('Bilinmeyen durum.');
  }
}


```

### Döngüler: `for`, `for-in` ve `while`

Veri listelerini tek tek işlemek veya belirli bir işlemi tekrar ettirmek için döngüler kullanılır:

```dart
void main() {
  // 1. Standart Sayaçlı 'for' Döngüsü
  for (int i = 1; i <= 3; i++) {
    print('Sayaç: $i');
  }

  // 2. Koleksiyonlar İçin 'for-in' Döngüsü (En Sık Kullanılan Yöntem)
  List<String> tags = ['Mobil', 'Flutter', 'Yazılım'];
  print('--- for-in ile Etiketler ---');
  for (String tag in tags) {
    print('#$tag');
  }

  // 3. 'while' Döngüsü
  int retry = 0;
  while (retry < 2) {
    print('Yeniden deneniyor: $retry');
    retry++;
  }
}

```

---

## 4. Koleksiyonlar: List ve Map

Mobil uygulamalarda veriler tekil değişkenler yerine diziler halinde gelir. Dart bu ihtiyacı `List` ve `Map` yapılarıyla karşılar.

### List (Sıralı Veri Dizisi)

Aynı türden birden fazla veriyi sıra numarasıyla (index) tutar:

```dart
void main() {
  // String türünde elemanlar tutan bir liste
  List<String> categories = ['Kişisel', 'İş', 'Alışveriş'];

  // Eleman ekleme ve çıkarma
  categories.add('Eğitim');
  categories.remove('İş');

  print('Kategori Sayısı: ${categories.length}');
  print('İlk Kategori: ${categories.first}');
  print('İkinci Eleman (index 1): ${categories[1]}');

  // Döngü ile gezinti (for-in)
  print('--- Tüm Kategoriler ---');
  for (String category in categories) {
    print('- $category');
  }
}


```

### Map (Anahtar - Değer Eşleşmesi)

Verileri `key: value` mantığıyla tutar. REST API'lerden dönen JSON verilerinin Dart tarafındaki karşılığı `Map` yapısıdır:

```dart
void main() {
  // Key: String, Value: dynamic (her türlü değer alabilir)
  Map<String, dynamic> note = {
    'id': 101,
    'title': 'Flutter Kurulumu',
    'isDone': false,
    'tag': 'Mobil',
  };

  print('Not Başlığı: ${note['title']}');
  print('Tamamlandı mı: ${note['isDone']}');

  // Yeni anahtar ekleme / güncelleme
  note['createdAt'] = '2026-10-13';
  note['isDone'] = true;

  print('Güncel Not Haritası: $note');
}


```

---

## 5. Modern Dart’ın Omurgası: Null Safety

Uygulama geliştiricilerin en sık karşılaştığı hatalardan biri `NullPointerException` (boş referansa erişim hatası) durumudur. Dart 2.12 ile gelen **Sound Null Safety** mimarisi sayesinde değişkenler varsayılan olarak `null` değer kabul etmez.

Eğer bir değişkenin boş kalabilme ihtimali varsa, bunu derleyiciye açıkça söylemeniz gerekir.

### Nullable (`?`) ve Non-Nullable

```dart
void main() {
  // Non-nullable: Kesinlikle null olamaz
  String title = 'Alışveriş Listesi';
  // title = null; // HATA! Derleyici buna izin vermez.

  // Nullable (?): Null değer alabilir
  String? description;
  description = null; // Geçerli
  description = 'Süt, ekmek ve yumurta alınacak.';

  print('Başlık: $title');
  print('Açıklama: $description');
}


```

### Güvenli Erişim (`?.`) ve Null-Coalescing (`??`) Operatörleri

Boş kalabilen değerlerle çalışırken uygulamanın çökmesini önleyen iki temel operatör vardır:

```dart
void main() {
  String? userNote;

  // 1. Güvenli çağrı (?.) : Eğer değer null ise hata fırlatmaz, null döner
  print(userNote?.length); // Çıktı: null (Çökme olmaz)

  // 2. Varsayılan değer atama (??) : Değer null ise sağdaki alternatifi kullan
  String displayNote = userNote ?? 'Varsayılan: İçerik girilmedi.';
  print('Gösterilen Metin: $displayNote');

  // 3. Null Assertion (!): "Bu değerin null olmadığından eminim" garantisi
  // DİKKAT: Eğer değer gerçekten null gelirse uygulama çöker.
  userNote = 'Önemli Hatırlatma';
  print(userNote!.toUpperCase());
}


```

---

## 6. Mini Uygulama Laboratuvarı: Terminalde Not Listesi Yönetimi

Tüm bu öğrendiklerimizi bir araya getirerek VS Code terminalinde çalışan, basit ama tam fonksiyonel bir not filtreleme algoritması kuralım.

Bu algoritma, serinin sonraki bölümlerinde Flutter arayüzüne taşıyacağımız veri modelinin temelini oluşturacaktır:

```dart
void main() {
  // Notları temsil eden Map listesi
  List<Map<String, dynamic>> notes = [
    {
      'id': 1,
      'title': 'Haftalık Plan',
      'priority': 'Yüksek',
      'isCompleted': false,
    },
    {
      'id': 2,
      'title': 'Market Alışverişi',
      'priority': 'Düşük',
      'isCompleted': true,
    },
    {
      'id': 3,
      'title': 'Flutter Projesini Başlat',
      'priority': 'Yüksek',
      'isCompleted': false,
    },
  ];

  print('=== TÜM NOTLAR (${notes.length} Adet) ===');
  for (var note in notes) {
    String status = note['isCompleted'] ? '[x]' : '[ ]';
    print('$status ${note['title']} (Öncelik: ${note['priority']})');
  }

  print('\n=== YÜKSEK ÖNCELİKLİ VE TAMAMLANMAMIŞ NOTLAR ===');
  for (var note in notes) {
    bool isHighPriority = note['priority'] == 'Yüksek';
    bool isPending = !note['isCompleted'];

    if (isHighPriority && isPending) {
      print('-> Dikkat: ${note['title']} henüz tamamlanmadı!');
    }
  }
}


```

### Çıktı

Terminalde `dart run main.dart` komutunu çalıştırdığınızda şu çıktıyı görmelisiniz:

```text
=== TÜM NOTLAR (3 Adet) ===
[ ] Haftalık Plan (Öncelik: Yüksek)
[x] Market Alışverişi (Öncelik: Düşük)
[ ] Flutter Projesini Başlat (Öncelik: Yüksek)

=== YÜKSEK ÖNCELİKLİ VE TAMAMLANMAMIŞ NOTLAR ===
-> Dikkat: Haftalık Plan henüz tamamlanmadı!
-> Dikkat: Flutter Projesini Başlat henüz tamamlanmadı!


```

---

## Özet

Bu adımda şunları netleştirdik:

1. `var`, `final` ve `const` arasındaki farkları ve bellek davranışlarını,
2. `List` ile sıralı veri, `Map` ile JSON benzeri anahtar-değer yapıları kurmayı,
3. Dart'ın **Sound Null Safety** yapısıyla `null` hatalarını derleme anında nasıl yakalayabileceğimizi.

Serinin bir sonraki yazısında, bu düz veri yapılarını daha profesyonel ve modüler bir mimariye taşımak için **Dart Fonksiyonları, İsimli Parametreler ve Koleksiyon Metotlarını (`map`, `where`, `fold`)** ele alacağız.