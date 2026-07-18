import 'dart:developer';

import 'package:flutter/cupertino.dart';

import '../database.dart';

class TypeWork {
  int id;
  String type_work;
  String cultures;

  TypeWork({
    this.id = 0,
    required this.type_work,
    required this.cultures
  });

  Map<String, dynamic> toMap() {
    return {'type_work': type_work, 'cultures': cultures};
  }

  @override
  String toString() {
    return 'Field{type_work: $type_work, cultures: $cultures}';
  }
}


Future<List<TypeWork>> selectTypeWorksAll() async {
  var provider = DBProvider();
  final db = await provider.database;

  final List<Map<String, dynamic>> maps = await db.query('typework');

  return List.generate(maps.length, (i) {
    return TypeWork(
      id: maps[i]['id'],
      type_work: maps[i]['type_work'],
      cultures: maps[i]['cultures']
    );
  });
}


Future<TypeWork> getTypeWork(int id) async {
  var provider = DBProvider();
  final db = await provider.database;

  List<Map<String, dynamic>> maps = await db.query('typework', where: 'id = ?', whereArgs: [id]);

  var t = TypeWork(
    id: maps[0]['id'],
    type_work: maps[0]['type_work'],
    cultures: maps[0]['cultures'],
  );

  return t;
}

Future<int?> getTypeWorkByCalendarDate(DateTime calendarDate) async {
  var provider = DBProvider();
  final db = await provider.database;

  final String formattedDate = "${calendarDate.year}-"
    "${calendarDate.month.toString().padLeft(2, '0')}-"
    "${calendarDate.day.toString().padLeft(2, '0')}";

  const String sql = '''
    WITH tasks AS (
      SELECT 
        MIN(fw.id_typework) AS id_typework, (COUNT(*) - SUM(t.exec)) AS cnt_exec,
          COUNT(*) AS cnt
      FROM task AS t 
      INNER JOIN fieldwork AS fw 
        ON t.id_fieldwork = fw.id AND DATE(t.date_task) = DATE(?)
    )
     SELECT 
      CASE 
        WHEN cnt > 0 THEN 
          CASE cnt_exec
            WHEN 0 THEN -1
            ELSE id_typework
          END
      END AS result
       
     FROM tasks;
      
      
    ''';

  final List<Map<String, dynamic>> result = await db.rawQuery(sql, [formattedDate]);
  final int firstResult = result.first['result'] as int;

  return firstResult;
}








