// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorSnowGaugeDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$SnowGaugeDatabaseBuilder databaseBuilder(String name) =>
      _$SnowGaugeDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$SnowGaugeDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$SnowGaugeDatabaseBuilder(null);
}

class _$SnowGaugeDatabaseBuilder {
  _$SnowGaugeDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$SnowGaugeDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$SnowGaugeDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<SnowGaugeDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$SnowGaugeDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$SnowGaugeDatabase extends SnowGaugeDatabase {
  _$SnowGaugeDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  RecordingDao? _recordingDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Recording` (`id` INTEGER NOT NULL, `user_id` TEXT NOT NULL, `recording_date` INTEGER NOT NULL, `number_of_runs` INTEGER NOT NULL, `max_speed` REAL NOT NULL, `average_speed` REAL NOT NULL, `total_distance` REAL NOT NULL, `total_vertical` REAL NOT NULL, `max_elevation` REAL NOT NULL, `min_elevation` REAL NOT NULL, `duration` INTEGER NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  RecordingDao get recordingDao {
    return _recordingDaoInstance ??= _$RecordingDao(database, changeListener);
  }
}

class _$RecordingDao extends RecordingDao {
  _$RecordingDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _recordingInsertionAdapter = InsertionAdapter(
            database,
            'Recording',
            (Recording item) => <String, Object?>{
                  'id': item.id,
                  'user_id': item.userId,
                  'recording_date':
                      _dateTimeConverter.encode(item.recordingDate),
                  'number_of_runs': item.numberOfRuns,
                  'max_speed': item.maxSpeed,
                  'average_speed': item.averageSpeed,
                  'total_distance': item.totalDistance,
                  'total_vertical': item.totalVertical,
                  'max_elevation': item.maxElevation,
                  'min_elevation': item.minElevation,
                  'duration': item.duration
                },
            changeListener),
        _recordingUpdateAdapter = UpdateAdapter(
            database,
            'Recording',
            ['id'],
            (Recording item) => <String, Object?>{
                  'id': item.id,
                  'user_id': item.userId,
                  'recording_date':
                      _dateTimeConverter.encode(item.recordingDate),
                  'number_of_runs': item.numberOfRuns,
                  'max_speed': item.maxSpeed,
                  'average_speed': item.averageSpeed,
                  'total_distance': item.totalDistance,
                  'total_vertical': item.totalVertical,
                  'max_elevation': item.maxElevation,
                  'min_elevation': item.minElevation,
                  'duration': item.duration
                },
            changeListener),
        _recordingDeletionAdapter = DeletionAdapter(
            database,
            'Recording',
            ['id'],
            (Recording item) => <String, Object?>{
                  'id': item.id,
                  'user_id': item.userId,
                  'recording_date':
                      _dateTimeConverter.encode(item.recordingDate),
                  'number_of_runs': item.numberOfRuns,
                  'max_speed': item.maxSpeed,
                  'average_speed': item.averageSpeed,
                  'total_distance': item.totalDistance,
                  'total_vertical': item.totalVertical,
                  'max_elevation': item.maxElevation,
                  'min_elevation': item.minElevation,
                  'duration': item.duration
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Recording> _recordingInsertionAdapter;

  final UpdateAdapter<Recording> _recordingUpdateAdapter;

  final DeletionAdapter<Recording> _recordingDeletionAdapter;

  @override
  Future<List<Recording>> getAllRecordings() async {
    return _queryAdapter.queryList('SELECT * FROM Recording',
        mapper: (Map<String, Object?> row) => Recording(
            row['id'] as int,
            row['user_id'] as String,
            _dateTimeConverter.decode(row['recording_date'] as int),
            row['number_of_runs'] as int,
            row['max_speed'] as double,
            row['average_speed'] as double,
            row['total_distance'] as double,
            row['total_vertical'] as double,
            row['max_elevation'] as double,
            row['min_elevation'] as double,
            row['duration'] as int));
  }

  @override
  Stream<List<Recording>> watchRecordingById(String id) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM Recording WHERE user_id = ?1',
        mapper: (Map<String, Object?> row) => Recording(
            row['id'] as int,
            row['user_id'] as String,
            _dateTimeConverter.decode(row['recording_date'] as int),
            row['number_of_runs'] as int,
            row['max_speed'] as double,
            row['average_speed'] as double,
            row['total_distance'] as double,
            row['total_vertical'] as double,
            row['max_elevation'] as double,
            row['min_elevation'] as double,
            row['duration'] as int),
        arguments: [id],
        queryableName: 'Recording',
        isView: false);
  }

  @override
  Future<void> insertRecording(Recording recording) async {
    await _recordingInsertionAdapter.insert(
        recording, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateRecording(Recording user) async {
    await _recordingUpdateAdapter.update(user, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteRecording(Recording user) async {
    await _recordingDeletionAdapter.delete(user);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
