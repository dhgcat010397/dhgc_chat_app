// import 'package:dhgc_notes_app/src/features/home/data/models/note_model.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// class DatabaseHelper {
//   // This class will contain methods to interact with the database
//   // For example, methods to initialize the database, create tables, etc.
//   static final DatabaseHelper instance = DatabaseHelper._init();
//   static Database? _database;

//   DatabaseHelper._init();

//   final String _tableNotes = 'notes';
//   final String _columnId = 'id';
//   final String _columnTitle = 'title';
//   final String _columnContent = 'content';
//   final String _columnCreatedAt = 'created_at';
//   final String _columnModifiedAt = 'modified_at';

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDB('notes_app.db');
//     return _database!;
//   }

//   Future<Database> _initDB(String filePath) async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, filePath);
//     return await openDatabase(path, version: 1, onCreate: _createDB);
//   }

//   Future<void> close() async {
//     if (_database != null) {
//       await _database!.close();
//       _database = null;
//     }
//   }

//   Future _createDB(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE $_tableNotes (
//         $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
//         $_columnTitle TEXT NOT NULL,
//         $_columnContent TEXT NOT NULL,
//         $_columnCreatedAt TEXT NOT NULL,
//         $_columnModifiedAt TEXT NOT NULL
//       )
//     ''');
//   }

//   // Note operations
//   Future<List<NoteModel>> getNotes() async =>
//       (await _database!.query(
//         _tableNotes,
//         orderBy: '$_columnModifiedAt DESC',
//       )).map((e) => NoteModel.fromJson(e)).toList();

//   Future<List<NoteModel>> filterNotesByTitle(String query) async =>
//       (await _database!.query(
//         _tableNotes,
//         where: 'title LIKE ?',
//         whereArgs: ['%$query%'],
//         orderBy: '$_columnModifiedAt DESC',
//       )).map((e) => NoteModel.fromJson(e)).toList();

//   Future<NoteModel?> getNoteById(int id) async {
//     final notes = await _database!.query(
//       _tableNotes,
//       where: 'id = ?',
//       whereArgs: [id],
//     );

//     if (notes.isNotEmpty) {
//       return NoteModel.fromJson(notes.first);
//     } else {
//       return null;
//     }
//   }

//   Future<int> createNote(NoteModel note) async =>
//       await _database!.insert(_tableNotes, note.toJson());

//   Future<int> updateNote(NoteModel note) async => await _database!.update(
//     _tableNotes,
//     note.toJson(),
//     where: 'id = ?',
//     whereArgs: [note.id],
//   );

//   Future<int> deleteNote(int id) async =>
//       await _database!.delete(_tableNotes, where: 'id = ?', whereArgs: [id]);
// }
