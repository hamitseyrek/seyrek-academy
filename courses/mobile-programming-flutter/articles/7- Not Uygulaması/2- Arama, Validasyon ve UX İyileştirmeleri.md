# State Management: ChangeNotifier ile Eski Koddan Yeni Koda Geçiş

Bu makalede odak yalnızca **state management**tir.  
3. makalede MVVM mimarisi kurulmuştu; bu aşamada `setState` tabanlı güncellemeyi `ChangeNotifier` tabanlı yönetime taşıyacağız.

Bu içerik, eski kod / yeni kod karşılaştırması ile ilerler.

## State management nedir?

State management, uygulamadaki verinin değişimini ve UI güncellemelerini yönetme yöntemidir.

Bu projede state örnekleri:

- Not listesi
- Arama metni
- Filtrelenmiş liste

## Neden `setState`ten `ChangeNotifier`a geçiyoruz?

`setState` küçük örneklerde pratiktir; fakat ekran büyüdükçe:

- UI dosyası kalabalıklaşır
- Gereksiz rebuild'ler artar
- Aynı state'i birden fazla widget ile paylaşmak zorlaşır

`ChangeNotifier` bu sorunları azaltır:

- State tek yerde yönetilir
- `notifyListeners()` ile kontrollü güncelleme yapılır
- ViewModel test ve bakım açısından daha yönetilebilir olur

---

## 1. Eski kod / yeni kod: Temel fark

### Eski yaklaşım (`setState`)

```dart
setState(() {
  _viewModel.addNote(
    title: result['title'] as String,
    content: result['content'] as String,
  );
});
```

### Yeni yaklaşım (`ChangeNotifier`)

```dart
_viewModel.addNote(
  title: result['title'] as String,
  content: result['content'] as String,
);
```

Fark: `addNote()` içinde `notifyListeners()` olduğu için dışarıda `setState` gerekmez.

---

## 2. ViewModel'i ChangeNotifier'a çevir

### 2.1. `viewmodels/notes_view_model.dart` dosyasını güncelle

`lib/viewmodels/notes_view_model.dart`:

```dart
import 'package:flutter/material.dart';
import '../models/note.dart';

class NotesViewModel extends ChangeNotifier {
  final List<Note> _notes = [];
  String _query = '';

  List<Note> get notes => List.unmodifiable(_notes);
  String get query => _query;

  List<Note> get filteredNotes {
    if (_query.isEmpty) return notes;
    return _notes
        .where((note) => note.title.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void addNote({
    required String title,
    required String content,
  }) {
    _notes.add(
      Note(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
        content: content,
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void updateNote({
    required int id,
    required String title,
    required String content,
  }) {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index == -1) return;

    _notes[index] = _notes[index].copyWith(
      title: title,
      content: content,
    );
    notifyListeners();
  }

  void deleteNote(int id) {
    _notes.removeWhere((note) => note.id == id);
    notifyListeners();
  }
}
```

**Neden?**  
State değişimi tek noktadan yönetilir; UI sadece dinler.

---

## 3. Eski kod / yeni kod: Listener yönetimi

### Eski yaklaşım (manuel listener + riskli)

```dart
@override
void initState() {
  super.initState();
  _viewModel.addListener(() {
    setState(() {});
  });
}
```

Bu yaklaşım çalışır; ancak listener referansı doğru yönetilmezse bakım zorluğu ve hata riski oluşur.

### Yeni yaklaşım (ListenableBuilder)

`ListenableBuilder`, listener yönetimini framework seviyesinde otomatik yapar.

---

## 4. `NotesPage` dosyasını ListenableBuilder ile güncelle

### 4.1. `views/notes_page.dart` dosyasını güncelle

`lib/views/notes_page.dart`:

```dart
import 'package:flutter/material.dart';
import '../models/note.dart';
import '../viewmodels/notes_view_model.dart';
import 'add_edit_note_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final NotesViewModel _viewModel = NotesViewModel();

  Future<void> _openAdd() async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(builder: (_) => const AddEditNotePage()),
    );
    if (result == null) return;

    _viewModel.addNote(
      title: result['title'] as String,
      content: result['content'] as String,
    );
  }

  Future<void> _openEdit(Note note) async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(builder: (_) => AddEditNotePage(initialNote: note)),
    );
    if (result == null) return;

    _viewModel.updateNote(
      id: note.id,
      title: result['title'] as String,
      content: result['content'] as String,
    );
  }

  void _delete(Note note) {
    _viewModel.deleteNote(note.id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Not silindi.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notlarım')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Notlarda ara',
                border: OutlineInputBorder(),
              ),
              onChanged: _viewModel.setQuery,
            ),
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: _viewModel,
              builder: (context, child) {
                final notes = _viewModel.filteredNotes;

                if (notes.isEmpty) {
                  return const Center(child: Text('Henüz not yok.'));
                }

                return ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return ListTile(
                      title: Text(note.title),
                      subtitle: Text(
                        note.content,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () => _openEdit(note),
                      trailing: IconButton(
                        onPressed: () => _delete(note),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAdd,
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

**Neden?**  
`ListenableBuilder`, `ChangeNotifier` güncellemelerini dinler; manuel `setState` çağrısı ihtiyacını kaldırır.

---

## 5. Eski kod / yeni kod karşılaştırma özeti

### Eski (`setState` odaklı)

- Her iş kuralı sonrası `setState` çağrısı
- UI katmanı state güncelleme sorumluluğu taşır

### Yeni (`ChangeNotifier` odaklı)

- ViewModel içinde `notifyListeners()`
- UI katmanı yalnızca dinler
- Kod okunabilirliği ve bakım kalitesi artar

---

## 6. Bu makalenin çıktısı

Bu aşamada:

- State yönetimi `ChangeNotifier` ile merkezi hale gelir.
- `setState` bağımlılığı büyük ölçüde kaldırılır.
- Eski koddan yeni koda geçiş mantığı anlaşılır hale gelir.

Bir sonraki makalede arama, validasyon ve UX iyileştirmeleri bu yapı üzerinde geliştirilecektir.

## Kaynak

- [ChangeNotifier Kullanımında Code Review](https://raw.githubusercontent.com/hamitseyrek/flux_note/main/ChangeNotifier-Code-Review.md)
