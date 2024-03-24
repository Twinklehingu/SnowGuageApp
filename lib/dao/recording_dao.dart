import 'package:floor/floor.dart';
import 'package:SnowGauge/entities/recording_entity.dart';

@dao
abstract class RecordingDao {
  // Create
  @insert
  Future<void> insertRecording(Recording recording);

  // Read
  @Query('SELECT * FROM Recording')
  Future<List<Recording>> getAllRecordings();

  @Query('SELECT * FROM Recording WHERE user_id = :id')
  Stream<List<Recording>> watchRecordingById(String id);

  // Update
  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateRecording(Recording user);

  // Delete
  @delete
  Future<void> deleteRecording(Recording user);
}
