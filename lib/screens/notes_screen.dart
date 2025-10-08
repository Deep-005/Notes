import 'package:flutter/material.dart';
import 'package:practice_app/db/notes_db.dart';
import 'package:practice_app/screens/note_card.dart';
import 'package:practice_app/screens/note_dialog.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Map<String, dynamic>> notes = [];
  List<Map<String, dynamic>> filteredNotes = []; // List to hold filtered notes
  final TextEditingController _searchController =
      TextEditingController(); // Controller for search input
  bool _isSearching = false; // Flag to check if searching is active

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    final fetchedNotes = await NotesDatabase.instance.getNotes();
    setState(() {
      notes = fetchedNotes;
      filteredNotes = fetchedNotes; // Initialize filteredNotes with all notes
    });
  }

  void showNoteDialog({int? id, String? title, String? description}) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return NoteDialog(
          noteId: id,
          title: title,
          description: description,
          onNoteSaved: (newTitle, newDescription, currentDate) async {
            if (id == null) {
              await NotesDatabase.instance
                  .addNote(newTitle, newDescription, currentDate);
            } else {
              await NotesDatabase.instance
                  .updateNote(newTitle, newDescription, currentDate, id);
            }
            fetchNotes(); // Refresh the notes list
          },
        );
      },
    );
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      filteredNotes = notes; // Reset filteredNotes to show all notes
    });
  }

  void _filterNotes(String query) {
    setState(() {
      filteredNotes = notes
          .where((note) =>
              note['title'].toLowerCase().contains(query.toLowerCase()) ||
              note['description'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade300,
        elevation: 10,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search notes...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                style: TextStyle(color: Colors.white),
                onChanged: _filterNotes, // Filter notes as the user types
              )
            : Text(
                'Notes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
        actions: [
          _isSearching
              ? IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: _stopSearch, // Stop searching and reset the list
                )
              : IconButton(
                  icon: Icon(Icons.search, color: Colors.white),
                  onPressed: _startSearch, // Start searching
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showNoteDialog();
        },
        backgroundColor: Colors.deepPurple.shade300,
        child: Icon(Icons.add, color: Colors.white, size: 30),
      ),
      body: filteredNotes.isEmpty
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Image(
                fit: BoxFit.contain,
                height: 500.0,
                image: AssetImage('assets/empty.png'),
              ),
            )
          : Padding(
              padding: EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: filteredNotes.length,
                itemBuilder: (context, index) {
                  final note = filteredNotes[index];
                  return NoteCard(
                    note: note,
                    onDelete: () async {
                      await NotesDatabase.instance.deleteNote(note['id']);
                      fetchNotes(); // Refresh the notes list
                    },
                    onTap: () {
                      showNoteDialog(
                        id: note['id'],
                        title: note['title'],
                        description: note['description'],
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}
