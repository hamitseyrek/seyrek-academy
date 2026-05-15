import 'package:full_note/models/note_model.dart';
import 'package:full_note/repository/notes_repository.dart';

class NoteAddViewModel {
  final NotesRepository _notesRepository;

  NoteAddViewModel(this._notesRepository);
  Future<void> saveNote(Note note) async {
    await _notesRepository.saveNote(note);
  }
}