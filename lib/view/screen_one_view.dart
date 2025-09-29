import 'package:flutter/material.dart';

import '../services/local_database_service.dart';


class ScreenOneView extends StatefulWidget {
  const ScreenOneView({super.key});

  @override
  State<ScreenOneView> createState() => _ScreenOneViewState();
}

class _ScreenOneViewState extends State<ScreenOneView> {
  final db = LocalDataBaseService.instance;
  List<Map<String, dynamic>> todos = [];

  @override
  void initState() {
    super.initState();
    _getTodos();
  }

  Future<void> _getTodos() async {
    final data = await db.getTodos('tasks');
    setState(() => todos = data);
  }

  Future<void> _addOrEditTodo({Map<String, dynamic>? existing}) async {
    final titleController = TextEditingController(text: existing?['title'] ?? '');
    final descController = TextEditingController(text: existing?['description'] ?? '');

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(existing == null ? 'Add Task' : 'Edit Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: InputDecoration(hintText: 'Title')),
            TextField(controller: descController, decoration: InputDecoration(hintText: 'Description')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isEmpty) return;

              final data = {
                'title': titleController.text,
                'description': descController.text,
                'date': DateTime.now().toIso8601String(),
              };

              if (existing == null) {
                await db.insertTodo('tasks', data);
              } else {
                await db.updateTodo('tasks', data, 'id = ?', [existing['id']]);
              }
              _getTodos();
              Navigator.pop(context);
            },
            child: Text(existing == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteTodo(int id) async {
    await db.deleteTodo('tasks', 'id = ?', [id]);
    _getTodos();
  }

  Future<void> _toggleComplete(Map<String, dynamic> todo) async {
    await db.updateTodo(
      'tasks',
      {'isCompleted': todo['isCompleted'] == 1 ? 0 : 1},
      'id = ?',
      [todo['id']],
    );
    _getTodos();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Todo Tasks')),
      body: todos.isEmpty
          ? const Center(child: Text('No tasks yet.'))
          : ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: 20
              ),
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return Card(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Checkbox(
                      value: todo['isCompleted'] == 1,
                      onChanged: (_) => _toggleComplete(todo),
                    ),
                    title: Text(
                      todo['title'],
                      style: TextStyle(
                        decoration: todo['isCompleted'] == 1
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    subtitle: Text(todo['description']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _addOrEditTodo(existing: todo),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteTodo(todo['id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditTodo(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
