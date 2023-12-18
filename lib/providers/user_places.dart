//import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_features_app/models/place.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path_provider/path_provider.dart' as syspaths;

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath(); //used to access the content
  final db = await sql.openDatabase(path.join(dbPath, 'places.db'),
      onCreate: (db, version) {
    return db.execute(
        'CREATE TABLE user_places(id TEXT PRIMARY KEY , title TEXT , image TEXT , lat REAL , lng REAL , address TEXT)');
  },
      version:
          1 //this should change whenever query is changed so that a new database file is created always
      );

  return db;
}

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final places = data.map((row) {
      return Place(
        id: row['id'] as String,
        title: row['title'] as String,
        image: File(row['image'] as String),
        location: PlaceLocation(
            latitude: row['lat'] as double,
            longitude: row['lng'] as double,
            address: row['address'] as String),
      );
    }).toList();

    state = places;
  }

  void addPlace(String title, File image, PlaceLocation location) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filename = path.basename(image.path);

    final copiedImage = await image.copy('${appDir.path}/$filename');

    final newPlace =
        Place(title: title, image: copiedImage, location: location);

    final db = await _getDatabase();
    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'lat': newPlace.location.latitude,
      'lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    });

    state = [newPlace, ...state];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
  (ref) => UserPlacesNotifier(),
);


/* 
1.path package:

Purpose: Helps with working with file and directory paths.
Use Case: Useful when you need to manipulate file or directory paths in your Dart code.
dart:io library:

2. dart:io package:
Purpose: Part of Dart's core libraries, provides classes for input and output operations, including file and directory handling.
Use Case: Used for tasks related to reading from and writing to files, interacting with directories, and other input/output operations.
sqflite package:

3.'sqflite' package
Purpose: A Dart library for SQLite, which is a lightweight relational database.
Use Case: Useful when you need to work with a local database, storing structured data on the device.
sqlite_api library (part of sqflite package):

4. 'sqflite_api' package
Purpose: Defines the core SQLite APIs for database interactions.
Use Case: Used in conjunction with the sqflite package for performing SQLite database operations, such as querying and updating data.
path_provider package:

5. 'path_provider' package
Purpose: Helps Flutter apps access commonly used file system locations on the device.
Use Case: Useful when you need to save files in specific directories, such as documents or temporary directories, and want a cross-platform solution for retrieving these directories.
*/