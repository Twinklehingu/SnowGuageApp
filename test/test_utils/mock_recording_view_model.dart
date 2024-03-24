import 'package:SnowGauge/entities/recording_entity.dart';
import 'package:SnowGauge/utilities/id_generator.dart';
import 'package:SnowGauge/view_models/recording_view_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/mockito.dart';

import 'recording_view_model_test.mocks.dart';

class MockRecordingViewModel extends Mock implements RecordingViewModel {
  @override
  bool isRecording = false;
  @override
  Recording record = Recording(
      IdGenerator.generateId(),  // id
      'user_id',                    // userId
      DateTime.now(),            // recordingDate
      0,                         // numberOfRuns
      0.0,                       // maxSpeed
      0.0,                       // averageSpeed
      0.0,                       // totalDistance
      0.0,                       // totalVertical
      0,                         // maxElevation
      0,                         // minElevation
      0                          // duration
  );
  @override
  bool permissionGranted = false;
  @override
  bool isPaused = false;
  @override
  List<Recording> recordingHistory = [];

  @override
  Future<void> requestPermission() async {
    permissionGranted = true;
  }
  @override
  void startRecording(LocationSettings locationSettings) {
    isRecording = true;
  }

  @override
  void stopRecording() {
    isRecording = false;
  }

  @override
  void togglePause() {
    if (isPaused) {
      isPaused = false;
    } else {
      isPaused = true;
    }
  }

  @override
  void discardRecording() {
  }

  @override
  void saveRecording() {}
}