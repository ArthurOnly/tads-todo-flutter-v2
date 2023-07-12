import 'package:tads_todo_v2/src/tasks/db/db_interface.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocalDB2 implements DBInterface {
  final externalUrl = 'https://0d8c-186-208-105-29.ngrok-free.app/api/tasks/';

  Future<Database> getDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'tasks.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)',
        );
      },
      version: 1,
    );
  }


  @override
  Future<void> insert(Map<String, dynamic> item) async {
    final database = await getDatabase();

    print(item);

    await database.insert(
      'tasks',
      item,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> list() async {
    final database = await getDatabase();

    final List<Map<String, dynamic>> maps = await database.query('tasks') ?? [];
    print(maps);
    return maps;
  }
  
  @override
  Future<Map<String, dynamic>?> findOne(int id) {
    final database = getDatabase();

    return database.then((db) async {
      final List<Map<String, dynamic>> maps = await db.query(
        'tasks',
        where: 'id = ?',
        whereArgs: [id],
      );
      return maps.isNotEmpty ? maps.first : null;
    });
    
  }
  
  @override
  Future<void> remove(int id) {
    final database = getDatabase();

    return database.then((db) async {
      await db.delete(
        'tasks',
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }
  
  @override
  Future<void> update(Map<String, dynamic> updatedItem) {
    // TODO: implement update
    throw UnimplementedError();
  }

  Future<void> syncData() async {
    List<Map<String, dynamic>> tasks = await list();


    final response = await http.get(Uri.parse(externalUrl));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      List<Map<String, dynamic>> newTasks = List<Map<String, dynamic>>.from(jsonResponse);

      for (var task in newTasks) {
        bool taskExists = tasks.any((element) => element['title'] == task['title']);

        if (!taskExists) {
          await insert(task);
        }
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }
}