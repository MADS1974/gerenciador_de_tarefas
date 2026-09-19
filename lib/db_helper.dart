import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'tarefa_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'tarefas_v2.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          '''
          CREATE TABLE tarefas(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT,
            data TEXT,
            concluida INTEGER -- Nova coluna adicionada
          )
          ''',
        );
      },
    );
  }

  Future<void> inserirTarefa(Tarefa tarefa) async {
    final db = await database;
    await db.insert('tarefas', tarefa.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Tarefa>> obterTarefas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tarefas');
    return List.generate(maps.length, (i) => Tarefa.fromMap(maps[i]));
  }

  Future<void> atualizarTarefa(Tarefa tarefa) async {
    final db = await database;
    await db.update(
      'tarefas',
      tarefa.toMap(),
      where: 'id = ?',
      whereArgs: [tarefa.id],
    );
  }

  Future<void> deletarTarefa(int id) async {
    final db = await database;
    await db.delete('tarefas', where: 'id = ?', whereArgs: [id]);
  }
}