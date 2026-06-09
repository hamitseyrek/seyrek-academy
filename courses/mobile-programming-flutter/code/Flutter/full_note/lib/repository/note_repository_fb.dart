import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:full_note/models/note_model.dart';

class NoteRepositoryFb {
  Stream<List<Note>> loadNotes() {
    return FirebaseFirestore.instance.collection('notes').snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        return Note(
          id: doc.id,
          title: data['title'] ?? '',
          content: data['content'] ?? '',
        );
      }).toList();
    });
  }

  Future<void> saveNote(Note note) async {
    await FirebaseFirestore.instance.collection('notes').add({
      'title': note.title,
      'content': note.content,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
