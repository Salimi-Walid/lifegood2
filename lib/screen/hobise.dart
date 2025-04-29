import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lifegood/model/container_hobies.dart';
import 'package:lifegood/database/database_hobies.dart';

class Hobbies extends StatefulWidget {
  const Hobbies({super.key});

  @override
  State<Hobbies> createState() => _HobbiesState();
}

class _HobbiesState extends State<Hobbies> {
  // Variables
  bool isReminderEnabled = false;
  bool isDone = false;
  TimeOfDay? selectedTime;
  final DatabaseHobies db = DatabaseHobies();
  final List<String> categories = ['Sport', 'Music', 'Reading', 'Coding'];
  String? selectedCategory;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final myBox = Hive.box('hobbies');

  @override
  void initState() {
    super.initState();
    // Initialize data
    _loadHobbiesData();
  }

  // Load hobbies data from Hive
  void _loadHobbiesData() {
    try {
      if (myBox.get('HOBBIES') == null) {
        db.createnitialdata();
      } else {
        db.loadData();
      }
      // Force refresh of UI after loading data
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('Error loading hobbies data: $e');
    }
  }

  @override
  void dispose() {
    // Clean up controllers
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Delete a hobby
  void deleteHobby(int index) {
    setState(() {
      db.hobies.removeAt(index);
      db.updatedData();
    });
  }

  // Update the "done" status of a hobby
  void updateHobbyDoneStatus(int index, bool isDone) {
    setState(() {
      // Make sure the hobby at this index exists and has enough elements
      if (index < db.hobies.length && db.hobies[index].length >= 7) {
        db.hobies[index][6] = isDone; // Update the "done" status
        db.updatedData(); // Save changes to database
      }
    });
  }

  // Show dialog to add new hobby
  void showInputDialog() {
    // Reset values before showing dialog
    _titleController.clear();
    _descriptionController.clear();
    selectedCategory = null;
    selectedTime = null;
    isReminderEnabled = false;
    isDone = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Add your hobby"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Choose Category',
                      ),
                      items:
                          categories.map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        setStateDialog(() {
                          selectedCategory = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        hintText: 'Title',
                        labelText: 'Title',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        hintText: 'Description',
                        labelText: 'Description',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 10),
                    SwitchListTile(
                      title: const Text("Remind me"),
                      value: isReminderEnabled,
                      onChanged: (value) {
                        setStateDialog(() {
                          isReminderEnabled = value;
                          if (!value) {
                            selectedTime = null;
                          }
                        });
                      },
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                    ),
                    if (isReminderEnabled) ...[
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedTime != null
                                ? 'Time: ${selectedTime!.format(context)}'
                                : 'Pick time',
                            style: const TextStyle(fontSize: 16),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final TimeOfDay? time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (time != null) {
                                setStateDialog(() {
                                  selectedTime = time;
                                });
                              }
                            },
                            child: const Text("Choose Time"),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Validate input
                    if (selectedCategory == null ||
                        _titleController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in all required fields'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }

                    final now = DateTime.now();
                    final dateNow = now.toIso8601String();
                    String reminderTime;

                    if (isReminderEnabled && selectedTime != null) {
                      final reminderDateTime = DateTime(
                        now.year,
                        now.month,
                        now.day,
                        selectedTime!.hour,
                        selectedTime!.minute,
                      );
                      reminderTime = reminderDateTime.toIso8601String();
                    } else {
                      reminderTime = dateNow;
                    }

                    setState(() {
                      db.hobies.add([
                        selectedCategory,
                        _titleController.text,
                        _descriptionController.text,
                        dateNow,
                        isReminderEnabled,
                        reminderTime,
                        isDone, // Always false for new hobbies
                      ]);
                      db.updatedData(); // Save to database
                    });

                    // Clear fields and close dialog
                    _titleController.clear();
                    _descriptionController.clear();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: showInputDialog,
        backgroundColor: const Color.fromARGB(255, 255, 133, 133),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("My Hobbies", style: TextStyle(color: Colors.black)),
        leading: const Icon(Icons.sports_gymnastics, color: Colors.black),
      ),
      body:
          db.hobies.isEmpty
              ? const Center(
                child: Text(
                  "No hobbies added yet.\nTap + to add your first hobby!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              )
              : ListView.builder(
                itemCount: db.hobies.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  // Get the "isDone" value, default to false if not available
                  bool isDone = false;
                  if (db.hobies[index].length >= 7) {
                    isDone = db.hobies[index][6] ?? false;
                  }

                  return ContainerHobies(
                    selection: db.hobies[index][0],
                    titel: db.hobies[index][1],
                    descreption: db.hobies[index][2],
                    date: db.hobies[index][3],
                    initialIsDone: isDone,
                    ontape: () => deleteHobby(index),
                    onDoneChanged:
                        (newValue) => updateHobbyDoneStatus(index, newValue),
                  );
                },
              ),
    );
  }
}
