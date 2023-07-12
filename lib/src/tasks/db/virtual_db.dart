import 'dart:math';

import 'package:tads_todo_v2/src/tasks/db/db_interface.dart';

class VirtualDB implements DBInterface{
  final List<Map<String, dynamic>> _items = [
    {
      'id': 5,
      'title': 'Fazer tarefa de dispositivos móveis',
      'description': 'Descrição completa da tarefa'
    },
    {
      'id': 6,
      'title': 'Resolver issues do PDS',
      'description': 'Acessar o Github e verificar...'
    }
  ];
  static final VirtualDB _db = VirtualDB._privateConstructor();

  VirtualDB._privateConstructor();

  factory VirtualDB() {
    return _db;
  }

  @override
  Future<void> insert(Map<String, dynamic> item) async {
    item['id'] = Random().nextInt(1000);
    _items.add(item);
  }

  @override
  Future<void> remove(int id) async {
    _items.removeWhere((item) => item['id'] == id);
  }

  @override
  Future<void> update(Map<String, dynamic> updatedItem) async {
    int i = _items.indexWhere((item) => item['id'] == updatedItem['id']);
    _items[i] = updatedItem;
  }

  @override
  Future<List<Map<String, dynamic>>> list() async {
    return _items;
  }

  @override
  Future<Map<String, dynamic>?> findOne(int id) async {
    return _items.firstWhere((item) => item['id'] == id);
  }
}

final taskDB = VirtualDB();
