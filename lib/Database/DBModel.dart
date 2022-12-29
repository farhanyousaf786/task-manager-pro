import 'package:sqflite/sqflite.dart'; // sqflite for database
import 'package:path/path.dart';
import 'package:taskreminder/Database/TaskModel.dart'; // the path package

class DatabaseConnect {
  Database? _database;

  // create a getter and open a connection to database
  Future<Database> get database async {
    // this is the location of our database in device. ex - data/data/....
    final dbpath = await getDatabasesPath();
    // this is the name of our database.
    const dbname = 'taskDB.db';
    // this joins the dbpath and dbname and creates a full path for database.
    // ex - data/data/taskDB.db
    final path = join(dbpath, dbname);

    // open the connection
    _database = await openDatabase(path, version: 1, onCreate: _createDB);
    // we will create the _createDB function separately

    return _database!;
  }

  // the _create db function
  // this creates Tables in our database
  Future<void> _createDB(Database db, int version) async {
    // make sure the columns we create in our table match the todo_model field.
    await db.execute('''
      CREATE TABLE taskDB(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        task TEXT,
        subTask TEXT,
        category TEXT,
        date TEXT,
        time TEXT
      )
    ''');
  }

  // function to add data into our database
  Future<void> insertBpRecord(TaskModel taskModel) async {
    // get the connection to database
    final db = await database;
    // insert the taskDB
    await db.insert(
      'taskDB', // the name of our table
      taskModel.toMap(), // the function we created in our todo_model
      conflictAlgorithm:
          ConflictAlgorithm.replace, // this will replace the duplicate entry
    );
  }

  // function to delete a  taskDB from our database
  Future<void> deleteBpRecord(TaskModel taskModel) async {
    final db = await database;
    // delete the taskDB from database based on its id.
    await db.delete(
      'taskDB',
      where: 'id == ?', // this condition will check for id in taskDB list
      whereArgs: [taskModel.id],
    );
  }

  // function to fetch all the taskDB data from our database
  Future<List<TaskModel>> getBpRecord() async {
    final db = await database;
    // query the database and save the taskDB as list of maps
    List<Map<String, dynamic>> items = await db.query(
      'taskDB',
      orderBy: 'id DESC',
    ); // this will order the list by id in descending order.
    // so the latest taskDB will be displayed on top.

    // now convert the items from list of maps to list of taskDB

    return List.generate(
      items.length,
      (i) => TaskModel(
          id: items[i]['id'],
          task: items[i]['task'],
          subTask: items[i]['subTask'],
          category: items[i]['category'],
          date: items[i]['date'],
          time: items[i]['time']), // this is in Text format right now. let's convert it to dateTime format
    );
  }

  // ------- not included in video--------

  // function for updating a taskDB in todoList
  Future<void> updateBpRecord(int id, String isComplete) async {
    final db = await database;

    await db.update(
      'taskDB', // table name
      {
        //
        'isComplete': isComplete, // data we have to update
      }, //
      where: 'id == ?', // which Row we have to update
      whereArgs: [id],
    );
  }
}
