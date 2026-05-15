import 'dart:convert';
import 'package:full_note/models/note_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesRepository {
  static const String prefStringListKey = 'notes';

  Future<List<Note>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesData = prefs.getStringList(prefStringListKey) ?? [];
    
    return notesData.map((noteString) {
      final noteMap = jsonDecode(noteString) as Map<String, dynamic>;
      return Note(
        id: noteMap['id'] as int,
        title: noteMap['title'] as String,
        content: noteMap['content'] as String,
      );
    }).toList();
  }

  Future<void> saveNote(Note note) async {
    final prefs = await SharedPreferences.getInstance();
    final notesData = await loadNotes();
    notesData.add(note);
    final jsonNotesData = notesData.map((note) => jsonEncode({
      'id': note.id,
      'title': note.title,
      'content': note.content,
    })).toList();
    await prefs.setStringList(prefStringListKey, jsonNotesData);
  }
}