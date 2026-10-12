import 'package:full_note/models/note_model.dart';
import 'package:full_note/repository/note_repository_fb.dart';
import 'package:full_note/repository/notes_repository.dart';

class NoteAddViewModel {
  final NotesRepository _notesRepository;
  final NoteRepositoryFb _noteRepositoryFb;

  NoteAddViewModel(this._notesRepository, this._noteRepositoryFb);
  Future<void> saveNote(Note note) async {
    // await _notesRepository.saveNote(note); // locale
    await _noteRepositoryFb.saveNote(note); // firebase
  }
}