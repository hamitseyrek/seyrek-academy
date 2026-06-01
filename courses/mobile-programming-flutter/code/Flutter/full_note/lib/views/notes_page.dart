import 'package:flutter/material.dart';
import 'package:full_note/repository/notes_repository.dart';
import 'package:full_note/view_models/note_add_view_model.dart';
import 'package:full_note/view_models/notes_list_vies_model.dart';
import 'package:full_note/views/add_note.dart';
import 'package:full_note/views/widget/custom_input_decoration.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final vm = NotesListViesModel(NotesRepository());
  final TextEditingController _searchController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

  Future<void> _refreshNotes() async {
    await vm.loadNotes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: vm,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Notlarım',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                child: TextField(
                  controller: _searchController,
                  decoration: customInputDecoration(
                    "Not ara...",
                    Icon(Icons.search),
                    suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(onPressed: () => _searchController.clear(), icon: Icon(Icons.close))
                ),
                onChanged: (_) => setState(() {})),
              ),
              Expanded(child: buidBody()),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            onPressed: () {
              gotoAddNote(context);
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget buidBody() {
    final query = _searchController.text.trim().toLowerCase();
    final filteredNotes = vm.notes.where((note) {
      return note.title.toLowerCase().contains(query) ||
            note.content.toLowerCase().contains(query);
    }).toList();
    if(filteredNotes.isEmpty){
      return Center(
        child: Text("EŞLEŞEN NOTE YOK"),
      );
    }
    return vm.notes.isEmpty
            ? const Center(child: Text('Henüz not yok!'))
            : ListView.builder(
                itemCount: filteredNotes.length,
                itemBuilder: (context, index) {
                  final note = filteredNotes[index];
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.fromLTRB(14, 6, 14, 6),
                      title: Text(
                        note.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        note.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Icon(Icons.arrow_forward),
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
