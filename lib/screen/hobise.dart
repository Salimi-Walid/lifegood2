import 'package:flutter/material.dart';
import 'package:lifegood/database/database_hobies.dart';
import 'package:lifegood/model/container_hobies.dart';

class Hobbies extends StatefulWidget {
  const Hobbies({super.key});

  @override
  State<Hobbies> createState() => _HobbiesState();
}

class _HobbiesState extends State<Hobbies> {
  bool isReminderEnabled = false;
  bool isDone = false;
  TimeOfDay? selectedTime;
  final List<String> categories = ['Sport', 'Music', 'Reading', 'Coding'];
  String? selectedCategory;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<Map<String, dynamic>> hobbies = [];

  @override
  void initState() {
    super.initState();
    _loadHobbiesData();
  }

  Future<void> _loadHobbiesData() async {
    final data = await SQLiteHobbies.instance.getHobbies();
    setState(() {
      hobbies = data;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> deleteHobby(int id) async {
    await SQLiteHobbies.instance.deleteHobby(id);
    await _loadHobbiesData();
  }

  Future<void> updateHobbyDoneStatus(int id, bool isDone) async {
    final hobby = hobbies.firstWhere((h) => h['id'] == id);
    hobby['isDone'] = isDone ? 1 : 0;
    await SQLiteHobbies.instance.updateHobby(id, hobby);
    await _loadHobbiesData();
  }

  void showInputDialog() {
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
                          if (!value) selectedTime = null;
                        });
                      },
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                    ),
                    if (isReminderEnabled)
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
                              final time = await showTimePicker(
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
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedCategory == null ||
                        _titleController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in all required fields'),
                        ),
                      );
                      return;
                    }

                    final now = DateTime.now();
                    final dateNow = now.toIso8601String();
                    final reminderTime =
                        (isReminderEnabled && selectedTime != null)
                            ? DateTime(
                              now.year,
                              now.month,
                              now.day,
                              selectedTime!.hour,
                              selectedTime!.minute,
                            ).toIso8601String()
                            : dateNow;

                    await SQLiteHobbies.instance.insertHobby({
                      'category': selectedCategory,
                      'title': _titleController.text,
                      'description': _descriptionController.text,
                      'date': dateNow,
                      'isReminderEnabled': isReminderEnabled ? 1 : 0,
                      'reminderTime': reminderTime,
                      'isDone': 0,
                    });

                    await _loadHobbiesData();
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
          hobbies.isEmpty
              ? const Center(
                child: Text(
                  "No hobbies added yet.\nTap + to add your first hobby!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              )
              : ListView.builder(
                itemCount: hobbies.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final hobby = hobbies[index];
                  return ContainerHobies(
                    selection: hobby['category'],
                    titel: hobby['title'],
                    descreption: hobby['description'],
                    date: hobby['date'],
                    initialIsDone: hobby['isDone'] == 1,
                    ontape: () => deleteHobby(hobby['id']),
                    onDoneChanged:
                        (newValue) =>
                            updateHobbyDoneStatus(hobby['id'], newValue),
                  );
                },
              ),
    );
  }
}
