# Proje Kurulumu ve Temel Ekranlar

Bu makalenin amacı, not uygulamasını sıfırdan başlatıp ilk çalışan ekran akışını oluşturmaktır. Bu aşamada odak, mimariyi büyütmek değil; doğru temeli kurmaktır.

Her adımda:

- Ne yapılacağı
- Hangi dosyanın oluşturulacağı
- Kodu nereye yazacağın
- Neden bu şekilde ilerlediğin

net olarak belirtilmiştir.

---

## 0. Hazırlık

### 0.1. Yeni Flutter projesi oluştur

Terminalde:

```bash
flutter create note_app_series
cd note_app_series
```

### 0.2. Projeyi IDE'de aç

Proje açıldıktan sonra ilk olarak `lib/main.dart` sade bir başlangıca çekilir.

Önce çalışan en basit yapı kurulur; sonra ekranlar kontrollü şekilde eklenir.

---

## 1. Uygulama giriş noktasını sade kur

### 1.1. `main.dart` dosyasını güncelle

`lib/main.dart` dosyasında Flutter’ın oluşturduğu varsayılan içeriği tamamen silip, sadece “çalışan en küçük uygulama”yı bırakacağız. Böylece sonraki adımlarda eklediğimiz her ekranı bu temel üzerinden adım adım doğrulayabiliriz.

Mevcut içeriği tamamen sil ve aşağıdakiyle değiştir:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text('Not Uygulaması'),
        ),
      ),
    );
  }
}
```

### 1.2. `app.dart` dosyasını oluştur

`app.dart`, uygulamanın tema ve başlangıç ekranı gibi ayarlarını bir araya toplayacağımız dosyadır. Böylece `main.dart` sadece giriş noktası olarak kalır.

`lib/app.dart`:

```dart
import 'package:flutter/material.dart';
import 'views/notes_page.dart';

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note App Series',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const NotesPage(),
    );
  }
}
```

### 1.3. (Kritik) `main.dart`’i `app.dart` ile bağla

Son adımda, `main.dart`’i az önce oluşturduğumuz `NoteApp` ile eşleştirerek gerçek başlangıç noktasını tanımlarız.

`lib/main.dart` içinde içeriği şu hale getir:

```dart
import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  runApp(const NoteApp());
}
```

---

## 2. Not modelini oluştur

### 2.1. `models/note.dart` ekle

Notları ekranlardan bağımsız bir veri modeliyle temsil etmek, ileride iş mantığını taşıyacağımız ViewModel katmanını sadeleştirir.

`lib/models/note.dart` dosyasını oluştur ve aşağıdaki içeriği ekle:

```dart
class Note {
  final int id;
  final String title;
  final String content;

  Note({
    required this.id,
    required this.title,
    required this.content,
  });
}
```

---

## 3. Ana ekranı oluştur (`NotesPage`)

### 3.1. `views/notes_page.dart` dosyasını oluştur

Bu ekranda not listesini ve yeni not ekleme akışını birlikte kuracağız. Amaç, “uygulamanın ana ekranı”nı ilk kez çalışır hale getirmektir.

`lib/views/notes_page.dart` dosyasını oluştur:

```dart
import 'package:flutter/material.dart';
import '../models/note.dart';
import 'add_edit_note_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final List<Note> _notes = [];

  Future<void> _goToAddNotePage() async {
    final created = await Navigator.of(context).push<Note>(
      MaterialPageRoute(
        builder: (_) => const AddEditNotePage(),
      ),
    );

    if (created != null) {
      setState(() {
        _notes.add(created);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notlarım'),
      ),
      body: _notes.isEmpty
          ? const Center(
              child: Text('Henüz not yok. Sağ alttan yeni not ekleyin.'),
            )
          : ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return ListTile(
                  title: Text(note.title),
                  subtitle: Text(
                    note.content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddNotePage,
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

---

## 4. Ekleme ekranını oluştur (`AddEditNotePage`)

### 4.1. `views/add_edit_note_page.dart` dosyasını oluştur

Not ekleme işini ayrı bir ekrana almak, ileride düzenleme senaryosunu da aynı yapı üzerinden desteklemeyi kolaylaştırır.

`lib/views/add_edit_note_page.dart` dosyasını oluştur:

```dart
import 'package:flutter/material.dart';
import '../models/note.dart';

class AddEditNotePage extends StatefulWidget {
  const AddEditNotePage({super.key});

  @override
  State<AddEditNotePage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Başlık boş bırakılamaz.')),
      );
      return;
    }

    final note = Note(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      content: content,
    );

    Navigator.of(context).pop(note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Not')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Başlık',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contentController,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'İçerik',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveNote,
                child: const Text('Kaydet'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```
