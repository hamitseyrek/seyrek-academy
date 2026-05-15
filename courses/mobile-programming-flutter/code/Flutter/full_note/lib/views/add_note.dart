import 'package:flutter/material.dart';
import 'package:full_note/models/note_model.dart';
import 'package:full_note/view_models/note_add_view_model.dart';

class AddNote extends StatefulWidget {
  final NoteAddViewModel viewModel;

  const AddNote({super.key, required this.viewModel});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Not Ekle', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.indigo.withAlpha(20),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.post_add_rounded, size: 50, color: Colors.indigo)),
              ),
              SizedBox(height: 12),
              Text('Not ekleme sayfası', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey.shade700),),
              SizedBox(height: 20),
              TextField(
                controller: _titleController,
                decoration: _inputDecoration(
                  'Not Başlığı',
                  'Notunuzun başlığını buraya yazın',
                  Icon(Icons.title_outlined)
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _contentController,
                decoration: _inputDecoration(
                  'Not İçeriği',
                  'Notunuzun içeriğini buraya yazın',
                  Icon(Icons.note_alt_outlined)
                ),
                maxLines: 5,
              ),
              SizedBox(height: 20),
              FilledButton.icon(
                icon: Icon(Icons.save_outlined),
                onPressed: () async {
                  final title = _titleController.text;
                  final content = _contentController.text;
          
                  if (title.isNotEmpty && content.isNotEmpty) {
                    final note = Note(id: DateTime.now().microsecondsSinceEpoch, title: title, content: content);
                    await widget.viewModel.saveNote(note);
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lütfen başlık ve içerik girin'), 
                      backgroundColor: Colors.grey.shade800,
                      behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                label: Text('Notu Kaydet'),
              ),
            ],
                ),
        ),
      ));
  }

  InputDecoration _inputDecoration(
    String labelText,
    String hintText,
    Widget prefixIcon,
  ) {
    return InputDecoration(
                labelText: labelText,
                hintText: hintText,
                prefixIcon: prefixIcon,
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.indigo),
                ),
              );
  }
}