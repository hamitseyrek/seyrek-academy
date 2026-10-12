import 'package:flutter/material.dart';
import 'package:full_note/models/note_model.dart';
import 'package:full_note/repository/note_repository_fb.dart';
import 'package:full_note/repository/notes_repository.dart';

class NotesListViesModel extends ChangeNotifier {
  final NotesRepository _notesRepository;
  final NoteRepositoryFb _noteRepositoryFb;

  NotesListViesModel(this._notesRepository, this._noteRepositoryFb);
  List<Note> notes = [];

  Future<void> loadNotes() async {
    final loadNotes = await _notesRepository.loadNotes(); // locale
    // final loadNotes = await _noteRepositoryFb.loadNotes(); // firebase
    notes..clear()..addAll(loadNotes);
    notifyListeners();
  }
}