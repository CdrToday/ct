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
  final String communityTable = 'CREATE TABLE Communities (id INTEGER PRIMARY KEY, key TEXT, value INTEGER)';
  final String blackListTable = 'CREATE TABLE BlackList (id INTEGER PRIMARY KEY, key TEXT, value Text)';

  Database db;
  open() async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + 'sqflite.db';

    // await deleteDatabase(path);
    // return;
    
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

  
  ///@settings
  updateSettings(String key, String value) async {
    await db.transaction((txn) async {
        var res = await txn.rawUpdate(
          'UPDATE Settings SET VALUE = ? WHERE key = ?', [value, key]
        );

        if (res == 0) {
          await txn.rawInsert(
            'INSERT INTO Settings(key, value) VALUES(?, ?)',
            [key, value]
          );
        }
    });
  }

  getSettings() async {
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

  ///@communities
  refreshCommunity(String key) async {
    int current;
    try {
      current = (
        await db.rawQuery('SELECT key, value FROM Communities WHERE key = $key')
      )[0]['value'];
    } catch(err) {
      current = 0;
    }
    
    await db.transaction((txn) async {
        var res = await txn.rawUpdate(
          'UPDATE Communities SET VALUE = ? WHERE key = ?', [current + 1, key]
        );
        
        if (res == 0) {
          await txn.rawInsert(
            'INSERT INTO Communities(key, value) VALUES(?, ?)',
            [key, 1]
          );
        }
    });
  }

  getCommunities() async {
    var list;
    try {
      list = await db.rawQuery('SELECT * FROM "Communities"');
    } catch(err) {
      list = [];
    }

    var res = {};
    for (var i in list) {
      res.putIfAbsent(i['key'], () => i['value']);
    }
    
    return res;
  }
}
