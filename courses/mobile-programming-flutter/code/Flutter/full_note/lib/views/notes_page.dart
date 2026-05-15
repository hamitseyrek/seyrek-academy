import 'package:flutter/material.dart';
import 'package:full_note/repository/notes_repository.dart';
import 'package:full_note/view_models/note_add_view_model.dart';
import 'package:full_note/view_models/notes_list_vies_model.dart';
import 'package:full_note/views/add_note.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final vm = NotesListViesModel(NotesRepository());
  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

  Future<void> _refreshNotes() async {
    await vm.loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: vm,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Notlarım'),
          ),
          body: vm.notes.isEmpty
        ? const Center(
          child: Text('Henüz not yok!'),
        )
        : ListView.builder(
          itemCount: vm.notes.length,
          itemBuilder: (context, index) {
            final note = vm.notes[index];
            return ListTile(
              title: Text(note.title),
              subtitle: Text(note.content),
              trailing: Icon(Icons.arrow_forward),
            );
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            gotoAddNote(context);
          },
          child: const Icon(Icons.heart_broken_rounded),
        ),
        );
      },
    );
  }

  void gotoAddNote(BuildContext context) {
    final addVm = NoteAddViewModel(NotesRepository());
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddNote(viewModel: addVm)),
    ).then((_) => _refreshNotes());
  }
}