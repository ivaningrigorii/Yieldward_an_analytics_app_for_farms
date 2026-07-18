import '../database.dart';


class Field {
  int id;
  String description;
  String region;

  Field({
    this.id = 0,
    required this.description,
    required this.region
  });

  Map<String, dynamic> toMap() {
    return {'region': region, 'description': description};
  }

  @override
  String toString() {
    return 'Field{region: $region, description: $description}';
  }
}

Future<void> insertField(Field field) async {
  var provider = DBProvider();
  final db = await provider.database;
  print(field.toMap());
    db.insert(
      'field_', field.toMap()
    ).then((value) => print("Добавлена запись сid = $value"));
}


Future<List<Field>> selectFieldsAll() async {
  var provider = DBProvider();
  final db = await provider.database;

  final List<Map<String, dynamic>> maps = await db.query('field_');

  return List.generate(maps.length, (i) {
    return Field(
      id: maps[i]['id'],
      description: maps[i]['description'],
      region: maps[i]['region'],
    );
  });
}

Future truncateFields() async {
  var provider = DBProvider();
  final db = await provider.database;

  db.delete('field_;');
}


Future deleteField(int id) async {
  var provider = DBProvider();
  final db = await provider.database;

  db.execute("PRAGMA foreign_keys=ON");
  db.delete('field_', where: "id = ?", whereArgs: [id]);
}


Future<Field> getField(int id) async {
  var provider = DBProvider();
  final db = await provider.database;

  List<Map<String, dynamic>> maps = await db.query('field_', where: 'id = ?', whereArgs: [id]);

  var t = Field(
    id: maps[0]['id'],
    description: maps[0]['description'],
    region: maps[0]['region'],
  );

  return t;
}