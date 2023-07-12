import 'package:flutter/material.dart';
import 'package:tads_todo_v2/src/tasks/data/tasks_repo.dart';
import 'package:tads_todo_v2/src/tasks/db/local_db.dart';
import 'package:tads_todo_v2/src/tasks/domain/task.dart';

class TaskCreateScreen extends StatelessWidget {
  const TaskCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simple TODO')),
      body: const Padding(
          padding: EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 16),
          child: MyCustomForm()),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // índice da aba ativa, começa em 0
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Tarefas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.create),
            label: 'Criar tarefa',
          ),
        ],
        onTap: (index) {
          Navigator.pushNamed(context, index == 0 ? '/tasks' : '/tasks/create');
        },
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  TaskRepository taskRepo = TaskRepository(LocalDB2());
  String _title = '';
  String _description = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Criação de tarefas",
            style: TextStyle(
              fontSize: 24.0,
            ),
          ),
          const SizedBox(
            width: 1,
            height: 24,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Título',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Digite um texto válido';
              }
              return null;
            },
            onSaved: (value) {
              if (value != null) {
                _title = value;
              }
            },
          ),
          const SizedBox(
            width: 1,
            height: 8,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Descrição completa',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Digite um texto válido';
              }
              return null;
            },
            onSaved: (value) {
              if (value != null) {
                _description = value;
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  Task task = Task(DateTime.now().millisecondsSinceEpoch, _title, _description);
                  taskRepo.insert(task);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Tarefa criada!"),
                      backgroundColor: Colors.green,
                    ),
                  );

                  Navigator.pushNamed(context, '/tasks');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Verifique os dados"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Criar'),
            ),
          ),
        ],
      ),
    );
  }
}
