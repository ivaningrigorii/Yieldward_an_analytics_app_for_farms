
import '../database.dart';


class Task {
  int id;
  int volume_of_fieldwork;
  String description;
  int exec;
  int id_fieldwork;
  String date_task;

  Task({
    this.id = 0,
    required this.volume_of_fieldwork,
    required this.exec,
    required this.description,
    required this.id_fieldwork,
    required this.date_task,
  });

  Map<String, dynamic> toMap() {
    return {
      'v': volume_of_fieldwork,
      'exec': exec,
      'description': description,
      'id_fieldwork': id_fieldwork,
      'date_task':date_task
    };
  }

  @override
  String toString() {
    return 'Field{v: $volume_of_fieldwork, exec: $exec}';
  }
}


Future<List<Task>> selectTasksSome(int fieldwork_id, DateTime selected_date) async {
  var provider = DBProvider();
  final db = await provider.database;

  final List<Map<String, dynamic>> maps = await db.query(
      'task', where: 'id_fieldwork = ? and date_task = ?',
      whereArgs: [fieldwork_id, selected_date.toIso8601String()]
  );

  return List.generate(maps.length, (i) {
    return Task(
        id: maps[i]['id'],
        volume_of_fieldwork: maps[i]['v'],
        description: maps[i]['description'],
        exec: maps[i]['exec'],
      id_fieldwork: maps[i]['id_fieldwork'],
      date_task: maps[i]['date_task'],
    );
  });
}

Future<List<Task>> selectTasksAlll() async {
  var provider = DBProvider();
  final db = await provider.database;

  final List<Map<String, dynamic>> maps = await db.query('task');

  print('вот тут вот');
  print(maps.toString());

  return List.generate(maps.length, (i) {
    return Task(
      id: maps[i]['id'],
      volume_of_fieldwork: maps[i]['v'],
      exec: maps[i]['exec'],
      description: maps[i]['description'],
      id_fieldwork: maps[i]['id_fieldwork'],
      date_task: maps[i]['date_task'],
    );
  });
}

Future<void> insertTask(Task task) async {
  var provider = DBProvider();
  final db = await provider.database;

  db.insert(
      'task', task.toMap()
  ).then((value) => print("Добавлена запись сid = $value"));
}


Future deleteTask(int id) async {
  var provider = DBProvider();
  final db = await provider.database;

  db.execute("PRAGMA foreign_keys=ON");
  db.delete('task', where: "id = ?", whereArgs: [id]);
}


Future chageTaskExeck(int id, int exec) async {
  var provider = DBProvider();
  final db = await provider.database;

  db.update('task', {'exec':exec}, where: "id = ?", whereArgs: [id]);
}
