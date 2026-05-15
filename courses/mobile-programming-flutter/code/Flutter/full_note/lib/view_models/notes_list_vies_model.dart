import 'package:flutter/material.dart';
import 'package:full_note/models/note_model.dart';
import 'package:full_note/repository/notes_repository.dart';

class NotesListViesModel extends ChangeNotifier {
  final NotesRepository _notesRepository;

  NotesListViesModel(this._notesRepository);
  List<Note> notes = [];

  Future<void> loadNotes() async {
    final loadNotes = await _notesRepository.loadNotes();
    notes..clear()..addAll(loadNotes);
    notifyListeners();
  }
}