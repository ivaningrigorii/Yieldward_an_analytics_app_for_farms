
import '../database.dart';

class FieldWork {
  int id;
  int workload;
  int id_field;
  int id_typework;

  FieldWork({
    this.id = 0,
    required this.workload,
    required this.id_field,
    required this.id_typework,

  });

  Map<String, dynamic> toMap() {
    return {'workload': workload,
              'id_typework': id_typework, 'id_field': id_field};
  }

  @override
  String toString() {
    return 'Field{region: $workload}';
  }
}

Future<void> insertFieldWork(FieldWork field) async {
  var provider = DBProvider();
  final db = await provider.database;
  print(field.toMap());
  db.insert(
      'fieldwork', field.toMap()
  ).then((value) => print("Добавлена запись сid = $value"));
}


Future<List<FieldWork>> selectFieldWorksAll(int id_field) async {
  var provider = DBProvider();
  final db = await provider.database;

  final List<Map<String, dynamic>> maps = await db.query(
      'fieldwork', where: 'id_field = ?',
      whereArgs: [id_field]
  );

  return List.generate(maps.length, (i) {
     return FieldWork(
      id: maps[i]['id'],
        workload: maps[i]['workload'],
       id_field: maps[i]['id_field'],
       id_typework: maps[i]['id_typework'],
     );
  }
  );
}


Future deleteFieldWork(int id) async {
  var provider = DBProvider();
  final db = await provider.database;

  db.execute("PRAGMA foreign_keys=ON");
  db.delete('fieldwork', where: "id = ?", whereArgs: [id]);
}


Future<FieldWork> getFieldWork(int id) async {
  var provider = DBProvider();
  final db = await provider.database;

  List<Map<String, dynamic>> maps = await db.query('fieldwork', where: 'id = ?', whereArgs: [id]);

  var t = FieldWork(
    id: maps[0]['id'],
      workload: maps[0]['workload'],
      id_field: maps[0]['id_field'],
      id_typework: maps[0]['id_typework'],
  );

  return t;
}


class StatisticWork {
  int sum_f;
  int exec_f;
  int sum_t;
  int exec_t;
  int id_fieldwork;
  int workload;

  StatisticWork({
    required this.sum_f,
    required this.exec_f,
    required this.sum_t,
    required this.exec_t,
    required this.id_fieldwork,
    required this.workload
  });

  Map<String, dynamic> toMap() {
    return {
      'sum_f': sum_f,
      'exec_f': exec_f,
      'sum_t': sum_t,
      'exec_t': exec_t,
      'id_fieldwork': id_fieldwork,
      'workload': workload,
    };
  }

  @override
  String toString() {
    return 'Field{region: $id_fieldwork}';
  }
}


Future<List<StatisticWork>> selectActivePlansStat() async {
  print('Что-то происходит');
  var provider = DBProvider();
  final db = await provider.database;
  print('Что-то происходит');

  var query = """
SELECT  
DISTINCT 
  coalesce(sum_f,0) as sum_f, 
    coalesce(exec_f,0) as exec_f, 
    coalesce(sum_t,0) as sum_t, 
    coalesce(exec_t,0) as exec_t, 
    
    CASE  
      when workload1 is not null then workload1 
      ELSE workload2  
    END as workload, 
    
    id as id_fieldwork 
from  
(
SELECT 
  DISTINCT 
    coalesce(sum(v),0) as sum_f,
        coalesce(count(exec),0) as exec_f,
      f.id,
      workload as workload1
    from fieldwork as f
      left join task as t
        on t.id_fieldwork = f.id
      left join field_
      on f.id_field = field_.id 
    WHERE exec is NULL or exec = 0 
GROUP by f.id, exec 
 ) as t1 LEFT join  
( 
SELECT  
  DISTINCT 
    coalesce(sum(v),0) as sum_t,
        coalesce(count(exec),0) as exec_t,
        workload as workload2,
      f.id
    from fieldwork as f
      left join task as t
        on t.id_fieldwork = f.id
      left join field_
      on f.id_field = field_.id 
    WHERE exec = 1 or exec is null 
GROUP by f.id, exec 
 ) as t2 
 USING(id) 
 WHERE coalesce(sum_t,0) < workload 
 
 UNION 
 
select  
DISTINCT 
  coalesce(sum_f,0) as sum_f, 
    coalesce(exec_f,0) as exec_f, 
    coalesce(sum_t,0) as sum_t, 
    coalesce(exec_t,0) as exec_t, 
    
    CASE  
      when workload1 is not null then workload1 
      ELSE workload2  
    END as workload, 
    
    id as id_fieldwork 
from  
(
  SELECT
  DISTINCT 
    coalesce(sum(v),0) as sum_t,
        coalesce(count(exec),0) as exec_t,
        workload as workload2,
      f.id
    from fieldwork as f
      left join task as t
        on t.id_fieldwork = f.id
      left join field_
      on f.id_field = field_.id 
    WHERE exec = 1 or exec is null 
  GROUP by f.id, exec 
 ) as t1 LEFT join  
( 
  SELECT 
  DISTINCT 
    coalesce(sum(v),0) as sum_f,
        coalesce(count(exec),0) as exec_f,
      f.id,
      workload as workload1
    from fieldwork as f
      left join task as t
        on t.id_fieldwork = f.id
      left join field_
      on f.id_field = field_.id 
    WHERE exec is NULL or exec = 0 
GROUP by f.id, exec 

 ) as t2 
 USING(id) 
 WHERE coalesce(sum_t,0) < workload
 """;

  print(query);
  final List<Map<String, dynamic>> maps = await db.rawQuery(query);
  if (maps.isEmpty) {
    print('мапа нету');
  }
  print('итог');

  print(maps.toString());

  return List.generate(maps.length, (i) {
    return StatisticWork(
    sum_f: maps[i]['sum_f'],
  exec_f: maps[i]['exec_f'],
  sum_t: maps[i]['sum_t'],
  exec_t: maps[i]['exec_t'],
  id_fieldwork: maps[i]['id_fieldwork'],
  workload: maps[i]['workload'],
    );
  });
}

