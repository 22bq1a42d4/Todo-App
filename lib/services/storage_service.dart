// lib/services/storage_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart'; // NEW: Added for hashing
import 'package:path_provider/path_provider.dart';
import '../models/task.dart';

class StorageService {
  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/database.json');
    print('DATABASE SAVED AT: ${file.path}');
    return file;
  }

  // --- SECURITY: One-Way Password Hashing ---
  String _hashPassword(String password) {
    var bytes = utf8.encode(password); // Convert password to bytes
    var digest = sha256.convert(bytes); // Generate SHA-256 hash
    return digest.toString(); // Return the scrambled string
  }

  // Reads the entire database file
  Future<Map<String, dynamic>> readDatabase() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) {
        return {'users': {}}; // Return our clean base structure
      }
      final contents = await file.readAsString();
      return jsonDecode(contents);
    } catch (e) {
      return {'users': {}};
    }
  }

  // Writes the entire database back to the file
  Future<void> _writeDatabase(Map<String, dynamic> data) async {
    final file = await _localFile;
    // Formatting with 2 spaces makes the JSON readable in a text editor!
    await file.writeAsString(const JsonEncoder.withIndent('  ').convert(data));
  }

  // Handles User Signup
  Future<bool> registerUser(String username, String password) async {
    final db = await readDatabase();

    // Check if the users object exists, if not create it
    if (db['users'] == null) db['users'] = {};

    if (db['users'].containsKey(username)) return false; // User already exists!

    // Hash the password BEFORE saving!
    final hashedPassword = _hashPassword(password);

    // Save with the clean, nested structure
    db['users'][username] = {'passwordHash': hashedPassword, 'tasks': []};

    await _writeDatabase(db);
    return true;
  }

  // Handles User Login
  Future<bool> loginUser(String username, String password) async {
    final db = await readDatabase();
    if (db['users'] == null || !db['users'].containsKey(username)) return false;

    // Hash the password the user just typed...
    final hashedAttempt = _hashPassword(password);
    // ...and compare it to the hash saved in the database!
    final savedHash = db['users'][username]['passwordHash'];

    return hashedAttempt == savedHash;
  }

  // Loads just the tasks for the logged-in user
  Future<List<Task>> loadTasksForUser(String username) async {
    final db = await readDatabase();
    if (db['users'] != null && db['users'].containsKey(username)) {
      final List<dynamic> taskList = db['users'][username]['tasks'];
      return taskList.map((item) => Task.fromJson(item)).toList();
    }
    return [];
  }

  // Saves updated tasks for the logged-in user
  Future<void> saveTasksForUser(String username, List<Task> tasks) async {
    final db = await readDatabase();
    if (db['users'] != null && db['users'].containsKey(username)) {
      db['users'][username]['tasks'] = tasks.map((t) => t.toJson()).toList();
      await _writeDatabase(db);
    }
  }
}
