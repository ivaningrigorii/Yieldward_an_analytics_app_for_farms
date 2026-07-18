import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static final DBProvider db = DBProvider();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Database? getDB() {
    return _database;
  }

  initDB() async {
    String path;

    Directory documentsDirectory = await getApplicationSupportDirectory();
    path = join(documentsDirectory.path, "ProjectDB.db");


    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          db.execute("PRAGMA foreign_keys=ON");
          db.execute("""
            CREATE TABLE field_ (
              id integer PRIMARY KEY AUTOINCREMENT,
              description text NOT NULL,
              region text NOT NULL
            );
          """);

          db.execute("""
          insert into field_ (id, description, region)
          VALUES 
            (0, 'не полевые работы', 'зона техники собранного урожая')
          """);


          db.execute("""
          CREATE TABLE typework (
	          id integer PRIMARY KEY AUTOINCREMENT,
  	        type_work text
          );
          """);
          db.execute("""
          insert into typework (id, type_work, cultures)
          VALUES 
            (3, 'закупки поездки'),
            (4, 'ремонт техники'),
            (0, 'подготовка почвы'),
            (1, 'полевые работы обработка культур'),
            (2, 'поливка и обработка культур'),
            (5, 'ангарные работы'),
            (6, 'покупка продажа зерна (привоз отвоз)'),
            (7, 'другие работы')
          """);

          db.execute("""
            CREATE table fieldwork (
	            id integer PRIMARY KEY AUTOINCREMENT,
  	          workload integer,
  	          id_field integer,
  	          id_typework integer,
  
  	          FOREIGN KEY (id_field) REFERENCES field_(id) ON DELETE CASCADE,
  	          FOREIGN KEY (id_typework) REFERENCES typework(id) ON DELETE CASCADE
            );
          """);

          db.execute("""
            CREATE TABLE task (
              id integer PRIMARY KEY AUTOINCREMENT,
              volume_of_fieldwork integer DEFAULT 0,
              description text DEFAULT '',
              exec integer,
              id_fieldwork integer,
              date_task string,
              
              FOREIGN KEY (id_fieldwork) REFERENCES fieldwork(id) ON DELETE CASCADE
            );
          """);


          db.execute("""
            CREATE TABLE whether (
              id integer PRIMARY KEY AUTOINCREMENT,
              dateTime_ string,
              temperature real,
              rainProbability real,
              id_fieldwork int,
              
              FOREIGN KEY (id_fieldwork) REFERENCES fieldwork(id) ON DELETE CASCADE
            );
          """);
          db.execute("PRAGMA foreign_keys=ON");
        });
  }
}