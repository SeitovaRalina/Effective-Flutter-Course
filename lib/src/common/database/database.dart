import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'database.g.dart';

class MenuCategories extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class MenuItems extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get imageUrl => text().nullable()();
  IntColumn get categoryId => integer().references(MenuCategories, #id)();

  @override
  Set<Column> get primaryKey => {id};
}

class MenuItemPrices extends Table {
  IntColumn get itemId => integer().references(MenuItems, #id)();
  TextColumn get currency => text()();
  RealColumn get value => real()();

  @override
  Set<Column> get primaryKey => {itemId, currency};
}

class Locations extends Table {
  TextColumn get address => text()();
  RealColumn get lat => real()();
  RealColumn get lng => real()();

  @override
  Set<Column> get primaryKey => {address};
}

@DriftDatabase(tables: [MenuCategories, MenuItems, MenuItemPrices, Locations])
class MenuDb extends _$MenuDb {
  MenuDb() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
