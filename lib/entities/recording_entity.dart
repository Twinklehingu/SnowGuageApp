import 'package:floor/floor.dart';

@Entity(
)
class Recording {
  @primaryKey
  final int id;
  @ColumnInfo(name: 'user_id')
  String userId;
  // stored as millisecondsFromEpoch
  @ColumnInfo(name: 'recording_date')
  DateTime recordingDate;
  @ColumnInfo(name: 'number_of_runs')
  int numberOfRuns;
  // speed stored in meters per second
  @ColumnInfo(name: 'max_speed')
  double maxSpeed;
  @ColumnInfo(name: 'average_speed')
  double averageSpeed;
  // stored in meters
  @ColumnInfo(name: 'total_distance')
  double totalDistance;
  // stored in meters
  @ColumnInfo(name: 'total_vertical')
  double totalVertical;
  @ColumnInfo(name: 'max_elevation')
  double maxElevation;
  @ColumnInfo(name: 'min_elevation')
  double minElevation;
  // stored in whole seconds
  int duration;

  Recording(
      this.id,
      this.userId,
      this.recordingDate,
      this.numberOfRuns,
      this.maxSpeed,
      this.averageSpeed,
      this.totalDistance,
      this.totalVertical,
      this.maxElevation,
      this.minElevation,
      this.duration
      );
}
