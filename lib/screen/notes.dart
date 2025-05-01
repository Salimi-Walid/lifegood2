import 'package:flutter/material.dart';
import 'package:lifegood/database/database_notes.dart';
import 'package:intl/intl.dart';
import 'package:lifegood/model/container_notes.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final NotesDatabase db = NotesDatabase();
  List<Map<String, dynamic>> notes = [];

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<void> loadNotes() async {
    final data = await db.getNotes();
    setState(() {
      notes = data;
    });
  }

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  void showAddNoteDialog() {
    titleController.clear();
    descriptionController.clear();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Add Note"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (titleController.text.isEmpty) return;

                  final now = DateTime.now();
                  final formattedDate = DateFormat(
                    'yyyy-MM-dd – kk:mm',
                  ).format(now);

                  await db.insertNote(
                    titleController.text,
                    descriptionController.text,
                    formattedDate,
                  );
                  Navigator.pop(context);
                  loadNotes();
                },
                child: const Text("Save"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      floatingActionButton: FloatingActionButton(
        onPressed: showAddNoteDialog,
        backgroundColor: Color.fromARGB(255, 233, 165, 165),
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("My Notes", style: TextStyle(color: Colors.black)),
        leading: Icon(Icons.sports_gymnastics),
      ),
      body:
          notes.isEmpty
              ? const Center(child: Text("No notes yet."))
              : GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return ContainerNotes(
                    titel: note['title'],
                    descreption: note['description'],
                    date: note['date'],
                  );
                },
              ),
    );
  }
}
