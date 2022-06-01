import 'package:flutter_sqlite/alarm.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbProvider {
  static Database? databese;
  static final String tablename = 'alarm';

  static Future<void> _createTable(Database db,int version) async {
    await db.execute('CREATE TABLE $tablename(id INTEGER PRIMARY KEY AUTOINCREMENT, alarm_time TEXT,is_active INTEGER)');
  }

  static Future<Database> initDb() async {
    String path = join(await getDatabasesPath(),'alarm_app.db');
    return await openDatabase(path,version: 1,onCreate: _createTable);
  }

  static Future<Database?> setDb() async {
    if (databese == null){
      databese = await initDb();
      return databese;
    } else {
      return databese;
    }
  }

  static Future<int> insertData(Alarm alarm) async {
    await databese!.insert(tablename, {
      'alarm_time': alarm.alarmTime.toString(),
      'is_active' : alarm.isActive ? 0 : 1
    });
    final List<Map<String,dynamic>> maps = await databese!.query(tablename);
    return maps.last['id'];
  }

  static Future<List<Alarm>> getData() async {
    final List<Map<String,dynamic>> maps = await databese!.query(tablename);
    print(maps);
    if(maps.length == 0){
      return [];
    }else {
      List<Alarm> alarmList = List.generate(maps.length, (index) => Alarm(
        id: maps[index]['id'],
        alarmTime: DateTime.parse(maps[index]['alarm_time']),
        isActive: maps[index]['is_active'] == 0 ? true : false
      ));
      return alarmList;
    }
  }

  static Future<void> updateData(Alarm alarm) async {
    await databese!.update(tablename, {
      'alarm_time': alarm.alarmTime.toString(),
      'is_active' : alarm.isActive ? 0 : 1
    },
      where: 'id = ?',
      whereArgs: [alarm.id]
    );
  }

  static Future<void> deleteData(int id) async {
    await databese!.delete(tablename,where: 'id = ?',whereArgs: [id]);
  }

}