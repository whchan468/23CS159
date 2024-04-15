import 'package:medireminder/Models/DB%20Model/med_info.dart';
import 'package:medireminder/Models/DB%20Model/med_log.dart';
import 'package:medireminder/Models/DB%20Model/remark.dart';
import 'package:medireminder/Models/DB%20Model/schedule.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SDataBase {
  static final SDataBase instance = SDataBase._init();
  SDataBase._init();
  static Database? _database;

  factory SDataBase() {
    return instance;
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initdb();
    return _database!;
  }

  Future<Database> _initdb() async {
    final path = await getPath();
    Database db = await openDatabase(path,
        version: 1, onCreate: createDB, singleInstance: true);
    return db;
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<String> getPath() async {
    const name = 'medireminder.db';
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<void> createDB(Database db, int version) async {
    await db.execute('''CREATE TABLE medinfo(
        mid INTEGER PRIMARY KEY AUTOINCREMENT, 
        mname TEXT NOT NULL, 
        freq INTEGER NOT NULL, 
        times INTEGER NOT NULL, 
        sdate INTEGER NOT NULL, 
        edate INTEGER NOT NULL, 
        dosage INTEGER NOT NULL
      )''');
    await db.execute('''CREATE TABLE IF NOT EXISTS remarks(
        mid INTEGER,
        remarks TEXT NOT NULL,
  		  FOREIGN KEY(mid) REFERENCES medinfo(mid)
      )''');
    await db.execute('''CREATE TABLE IF NOT EXISTS schedule(
        mid INTEGER, 
        mname TEXT NOT NULL,  
        med_datetime INTEGER NOT NULL,
        dosage INTEGER NOT NULL,
  		  FOREIGN KEY (mid) REFERENCES medinfo(mid)
      )''');
    await db.execute('''CREATE TABLE IF NOT EXISTS medlog(
        mid INTEGER, 
        take_time INT NOT NULL,
        exp_time INT NOT NULL,
        snoozed BOOL NOT NULL,
        FOREIGN KEY (mid) REFERENCES medinfo(mid)
        )''');
  }

  Future<MedInfo> addToMedInfo(MedInfo entry) async {
    final db = await instance.database;
    final id = await db.insert('medinfo', entry.toJson());
    return entry.copy(mid: id);
  }

  Future<List<MedInfo>> getMedInfo() async {
    final db = await instance.database;
    var list = await db.query('medinfo');
    if (list.isNotEmpty) {
      return list.map((e) => MedInfo.fromJson(e)).toList();
    }
    return [];
  }

  Future<int> deleteMedInfo(String? name) async {
    final db = await instance.database;
    if (name != null) {
      return await db.delete('medinfo', where: "mname = ?", whereArgs: [name]);
    } else {
      return await db.delete('medinfo');
    }
  }

  Future<int> getmid(String name) async {
    Database db = await SDataBase.instance.database;
    var data = await db.rawQuery('''
    SELECT mid FROM medinfo WHERE mname = "$name"
    ''');
    var value = data.first.values.first;
    return value as int;
  }

  Future<void> addToRemarks(Remark entry) async {
    Database db = await SDataBase.instance.database;
    await db.insert('remarks', entry.toJson());
  }

  Future<List<Remark>> getRemarks(int mid) async {
    Database db = await SDataBase.instance.database;
    var list = await db.query('remarks', where: "mid = ?", whereArgs: [mid]);
    if (list.isNotEmpty) {
      return list.map((e) => Remark.fromJson(e)).toList();
    }
    return [];
  }

  Future<void> addToSchedule(Schedule entry) async {
    Database db = await SDataBase.instance.database;
    await db.insert('schedule', entry.toJson());
  }

  Future<List<Schedule>> getSchedule() async {
    Database db = await SDataBase.instance.database;
    var list = await db.query('schedule');
    if (list.isNotEmpty) {
      return list.map((e) => Schedule.fromJson(e)).toList();
    }
    return [];
  }

  Future<int> deleteSchedule(String? name) async {
    final db = await instance.database;
    if (name != null) {
      return await db.delete('schedule', where: "mname = ?", whereArgs: [name]);
    } else {
      return await db.delete('schedule');
    }
  }

  Future<void> addToMedlog(MedLog entry) async {
    Database db = await SDataBase.instance.database;
    await db.insert('medlog', entry.toJson());
  }

  Future<List<MedLog>> getMedlog() async {
    Database db = await SDataBase.instance.database;
    var list = await db.query('medlog');
    if (list.isNotEmpty) {
      return list.map((e) => MedLog.fromJson(e)).toList();
    }
    return [];
  }
}
