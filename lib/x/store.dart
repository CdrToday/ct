import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> getString(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String value = prefs.getString(key) ?? '';
  return value;
}

void setString(String key, dynamic value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

void clear() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}


class CtDatabase {
  final String settingsTable = 'CREATE TABLE Settings (id INTEGER PRIMARY KEY, key TEXT, value Text)';
  final String communityTable = 'CREATE TABLE CommunityOrder (id INTEGER PRIMARY KEY, key TEXT, value INTEGER)';
  final String blackListTable = 'CREATE TABLE BlackList (id INTEGER PRIMARY KEY, key TEXT, value Text)';

  Database db;
  open() async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + 'sqflite.db';
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (
        Database db, int version
      ) async {
        // create the tables;
        await db.execute(settingsTable);
        await db.execute(communityTable);
        await db.execute(blackListTable);
      }
    );
  }
  
  updateSettings(String key, String value) async {
    await db.transaction((txn) async {
        var res = await txn.rawUpdate(
          'UPDATE Settings SET VALUE = ? WHERE key = ?', [value, key]
        );

        if (res == 0) {
          var _res = await txn.rawInsert(
            'INSERT INTO Settings(key, value) VALUES(?, ?)',
            [key, value]
          );
        }
    });

    await db.close();
  }

  getSettings() async {
    List<Map> list = await db.rawQuery('SELECT * FROM Settings');
    String longArticle;

    try {
      var res = await db.rawQuery(
        'SELECT key, value FROM Settings WHERE key = "longArticle"'
      );
      longArticle = res[0]['value'];
    } catch(err) {
      await db.transaction((txn) async {
          await txn.rawInsert(
            'INSERT INTO Settings(key, value) VALUES(?, ?)',
            ['longArticle', 'false']
          );
      });
      longArticle = 'false';
    }
    
    return {
      'longArticle': longArticle
    };
  }
}
