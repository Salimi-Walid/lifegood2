import 'package:flutter/material.dart';
import 'package:lifegood/database/database_todos.dart';

class Todo extends StatefulWidget {
  const Todo({super.key});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  List<Map<String, dynamic>> _todos = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTodos();
  }

  Future<void> _fetchTodos() async {
    final todos = await SQLiteTodos.instance.getTodos();
    setState(() {
      _todos = todos;
    });
  }

  Future<void> _addTodo() async {
    if (_titleController.text.isEmpty) return;

    await SQLiteTodos.instance.insertTodo({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'isCompleted': 0,
    });

    _titleController.clear();
    _descriptionController.clear();
    _fetchTodos();
    Navigator.of(context).pop();
  }

  Future<void> _toggleTodoCompletion(int id, bool isCompleted) async {
    await SQLiteTodos.instance.updateTodo(id, {
      'isCompleted': isCompleted ? 1 : 0,
    });
    _fetchTodos();
  }

  Future<void> _deleteTodo(int id) async {
    await SQLiteTodos.instance.deleteTodo(id);
    _fetchTodos();
  }

  void _showAddTodoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(onPressed: _addTodo, child: const Text('Add')),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To-Do List')),
      body:
          _todos.isEmpty
              ? const Center(child: Text('No tasks available'))
              : ListView.builder(
                itemCount: _todos.length,
                itemBuilder: (context, index) {
                  final todo = _todos[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    child: ListTile(
                      title: Text(
                        todo['title'],
                        style: TextStyle(
                          decoration:
                              todo['isCompleted'] == 1
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                        ),
                      ),
                      subtitle: Text(todo['description'] ?? ''),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: todo['isCompleted'] == 1,
                            onChanged: (value) {
                              _toggleTodoCompletion(todo['id'], value ?? false);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteTodo(todo['id']),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
