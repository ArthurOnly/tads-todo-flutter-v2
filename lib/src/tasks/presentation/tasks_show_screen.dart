import 'package:flutter/material.dart';
import 'package:tads_todo_v2/src/tasks/data/tasks_repo.dart';
import 'package:tads_todo_v2/src/tasks/db/local_db.dart';
import 'package:tads_todo_v2/src/tasks/db/virtual_db.dart';
import 'package:tads_todo_v2/src/tasks/domain/task.dart';

class TaskShowScreen extends StatelessWidget {
  final int taskId;
  const TaskShowScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simple TODO')),
      body: TaskShowComponent(id: taskId),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // índice da aba ativa, começa em 0
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

class TaskShowComponent extends StatefulWidget {
  final int id;
  const TaskShowComponent({Key? key, required this.id}) : super(key: key);

  @override
  State<TaskShowComponent> createState() => _TaskShowComponentState();
}

class _TaskShowComponentState extends State<TaskShowComponent> {
  late Task task = Task(1, '', '');
  TaskRepository taskRepo = TaskRepository(LocalDB2());

  @override
  void initState() {
    super.initState();
    getTask();
  }

  void getTask() async {
    Task? task = await taskRepo.getOne(widget.id);
    if (task != null) {
      setState(() {
        this.task = task;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              task.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            subtitle: Text(
              task.description,
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
