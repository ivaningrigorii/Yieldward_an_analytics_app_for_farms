import '../database.dart';


class Whether {
  int id;
  String dateTime_ ;
  double temperature ;
  double rainProbability;


  Whether({
    this.id = 0,
    required this.dateTime_,
    required this.temperature,
    required this.rainProbability,
  });

  Map<String, dynamic> toMap() {
    return {'dateTime': dateTime_, 'temperature': temperature, 'rainProbability': rainProbability, };
  }

  @override
  String toString() {
    return 'Field{datetime: $dateTime_, temperature: $temperature, rainProbability: $rainProbability}';
  }
}


Future<void> insertWhether(Whether whether) async {
  var provider = DBProvider();
  final db = await provider.database;

  db.insert(
      'whether', whether.toMap()
  ).then((value) => print("Добавлена запись сid = $value"));
}

Future deleteWhether(int id) async {
  var provider = DBProvider();
  final db = await provider.database;

  db.delete('whether', where: "id = ?", whereArgs: [id]);
}


