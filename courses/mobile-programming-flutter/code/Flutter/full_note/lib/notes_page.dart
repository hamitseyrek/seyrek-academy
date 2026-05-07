import 'package:flutter/material.dart';
import 'package:full_note/note_model.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final List<Note> _notes = [
    Note(id: 1, title: 'ders',content: 'notlarım')
    ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notlarım'),
      ),
      body: _notes.isEmpty
      ? const Center(
        child: Text('Henüz not yok!'),
      )
      : ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          return ListTile(
            title: Text(note.title),
            subtitle: Text(note.content),
          );
      }),
      
    );
  }
}