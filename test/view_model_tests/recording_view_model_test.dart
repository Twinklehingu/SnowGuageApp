import 'package:SnowGauge/entities/recording_entity.dart';
import 'package:SnowGauge/utilities/dependencies.dart';
import 'package:SnowGauge/utilities/id_generator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/annotations.dart';
import 'package:SnowGauge/view_models/recording_view_model.dart';
import 'package:SnowGauge/dao/recording_dao.dart';
import 'package:mockito/mockito.dart';
import '../test_utils/firebase_mock_setup.dart';
import '../view_tests/history_view_test.dart';
import '../test_utils/recording_view_model_test.mocks.dart';
import '../test_utils/recording_view_model_test.mocks.dart';
import 'package:SnowGauge/dao/recording_dao.dart';
import 'package:SnowGauge/entities/recording_entity.dart';

@GenerateMocks([RecordingDao, GeolocatorPlatform, Stream<Position>, Position, LocationSettings, ])
void main() async {

  setupFirebaseAuthMocks();
  const LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.best,
    distanceFilter: 0, // number of meters the user must move to update location
  );

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  group('RecordingViewModel', () {
    late RecordingViewModel viewModel;
    late MockRecordingDao mockRecordingDao;
    final mockFirebaseAuth = MockFirebaseAuth();
    final mockGeolocatorPlatform = MockGeolocatorPlatform();

    registerDependencies(mockFirebaseAuth);

    setUp(() async {
      await getIt.allReady();
      mockRecordingDao = MockRecordingDao();
      viewModel = RecordingViewModel(mockFirebaseAuth);
      viewModel.setRecordingDao(mockRecordingDao);
    });

    test('startRecording updates isRecording and initializes a new recording', () {
      var stream = MockStream<MockPosition>();

      when(mockGeolocatorPlatform.getPositionStream(locationSettings: locationSettings))
          .thenAnswer((_) => stream);
      viewModel.startRecording(locationSettings);
      expect(viewModel.isRecording, true);
      expect(viewModel.record.userId, isNotEmpty);
      expect(viewModel.record.numberOfRuns, 0);
      expect(viewModel.record.maxSpeed, 0.0);
      expect(viewModel.record.averageSpeed, 0.0);
      expect(viewModel.record.totalDistance, 0.0);
      expect(viewModel.record.totalVertical, 0.0);
      expect(viewModel.record.maxElevation, 0.0);
      expect(viewModel.record.minElevation, 0.0);
      expect(viewModel.record.duration, 0);
    });

    test('stopRecording updates isRecording', () {
      var stream = MockStream<MockPosition>();
      when(mockGeolocatorPlatform.getPositionStream(locationSettings: locationSettings))
          .thenAnswer((_) => stream);
      viewModel.startRecording(locationSettings);
      viewModel.stopRecording();
      expect(viewModel.isRecording, false);
    });

    test('togglePause toggles isPaused', () {
      expect(viewModel.isPaused, false);
      viewModel.togglePause();
      expect(viewModel.isPaused, true);
      viewModel.togglePause();
      expect(viewModel.isPaused, false);
    });

    test('request permission gets permission', () {
      when(mockGeolocatorPlatform.requestPermission()).thenAnswer((_) => Future.value(LocationPermission.whileInUse));
      expect(viewModel.permissionGranted, false);
      viewModel.setGeolocatorPlatform(mockGeolocatorPlatform);
      viewModel.requestPermission();
      when(mockGeolocatorPlatform.requestPermission()).thenAnswer((_) => Future.value(LocationPermission.denied));
      viewModel.requestPermission();
    });

    test('start recording runs correctly on play and pause', () {
      viewModel.isRecording = true;
      viewModel.isPaused = false;

      var stream = MockStream<MockPosition>();

      when(mockGeolocatorPlatform.getPositionStream(locationSettings: locationSettings))
          .thenAnswer((_) => stream);
      viewModel.startRecording(locationSettings);
    });

    test('discard recording clears the recording', () {
      Recording record = Recording(
          IdGenerator.generateId(),  // id
          'userId',                    // userId
          DateTime.now(),            // recordingDate
          1,                         // numberOfRuns
          0.0,                       // maxSpeed
          0.0,                       // averageSpeed
          0.0,                       // totalDistance
          0.0,                       // totalVertical
          0,                         // maxElevation
          0,                         // minElevation
          0                          // duration
      );

      viewModel.record = record;
      expect(viewModel.record, equals(record));
      viewModel.discardRecording();
      expect(viewModel.record, isNot(record));
    });

    test('saveRecording saves and restarts recording', () {
      Recording record = Recording(
          IdGenerator.generateId(),  // id
          'userId',                    // userId
          DateTime.now(),            // recordingDate
          1,                         // numberOfRuns
          0.0,                       // maxSpeed
          0.0,                       // averageSpeed
          0.0,                       // totalDistance
          0.0,                       // totalVertical
          0,                         // maxElevation
          0,                         // minElevation
          0                          // duration
      );

      viewModel.record = record;
      expect(viewModel.record, equals(record));
      viewModel.saveRecording();
      expect(viewModel.record, isNot(record));
    });

    test('update elevation correctly changes the elevation', () {
      MockPosition mockNewPosition = MockPosition();
      when(mockNewPosition.altitude).thenReturn(100);
      viewModel.isGoingDown = false;
      viewModel.maximumElevation = 0;
      viewModel.minimumElevation = 100000;
      viewModel.currentElevation = 200;
      viewModel.updateElevation(mockNewPosition);
      expect(viewModel.isGoingDown, true);
      expect(viewModel.currentElevation, 100);
      when(mockNewPosition.altitude).thenReturn(200);
      viewModel.updateElevation(mockNewPosition);
    });

    test('update speed correctly changes the speed', () {
      MockPosition mockNewPosition = MockPosition();
      MockPosition mockPreviousPosition = MockPosition();
      when(mockNewPosition.speed).thenReturn(50);
      when(mockNewPosition.latitude).thenReturn(42.1);
      when(mockNewPosition.longitude).thenReturn(-122.1);
      when(mockNewPosition.timestamp).thenReturn(DateTime.now());
      when(mockPreviousPosition.latitude).thenReturn(42);
      when(mockPreviousPosition.longitude).thenReturn(-122);
      when(mockPreviousPosition.timestamp).thenReturn(DateTime.now().subtract(Duration(days: 1)));
      viewModel.maxSpeed = 20;
      viewModel.previousTime = DateTime.now().subtract(Duration(days: 1));
      viewModel.previousPosition = mockPreviousPosition;

      viewModel.updateSpeed(mockNewPosition);

      expect(viewModel.maxSpeed, 50);
    });

    test('update speed correctly changes the speed', () {
      MockPosition mockNewPosition = MockPosition();
      MockPosition mockPreviousPosition = MockPosition();
      when(mockNewPosition.speed).thenReturn(50);
      when(mockNewPosition.latitude).thenReturn(42.1);
      when(mockNewPosition.longitude).thenReturn(-122.1);
      when(mockNewPosition.timestamp).thenReturn(DateTime.now());
      when(mockPreviousPosition.latitude).thenReturn(42);
      when(mockPreviousPosition.longitude).thenReturn(-122);
      when(mockPreviousPosition.timestamp).thenReturn(DateTime.now().subtract(Duration(days: 1)));
      viewModel.maxSpeed = 20;
      viewModel.previousTime = DateTime.now().subtract(Duration(days: 1));
      viewModel.previousPosition = mockPreviousPosition;

      viewModel.updateSpeed(mockNewPosition);

      expect(viewModel.maxSpeed, 50);
    });
  });
}

