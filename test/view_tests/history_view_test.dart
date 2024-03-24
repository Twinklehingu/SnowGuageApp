import 'package:SnowGauge/entities/recording_entity.dart';
import 'package:SnowGauge/utilities/dependencies.dart';
import 'package:SnowGauge/utilities/id_generator.dart';
import 'package:SnowGauge/view_models/recording_view_model.dart';
import 'package:SnowGauge/views/history_view.dart';
import 'package:SnowGauge/views/recording_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import '../test_utils/mock_recording_view_model.dart';
import '../test_utils/firebase_mock_setup.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() async {

  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  group('HistoryView Widget Tests', () {
    testWidgets('Widget shows "You must be signed in" when user is not signed in',
            (WidgetTester tester) async {
          final mockFirebaseAuth = MockFirebaseAuth();
          final mockRecordingViewModel = MockRecordingViewModel();

          registerDependencies(mockFirebaseAuth);

          when(mockFirebaseAuth.currentUser).thenReturn(null);

          await tester.pumpWidget(
            ChangeNotifierProvider<RecordingViewModel>.value(
              value: mockRecordingViewModel,
              child: MaterialApp(
                home: HistoryView(auth: mockFirebaseAuth),
              ),
            ),
          );

          expect(find.text('You must be signed in to use this feature'), findsOneWidget);
        });

    testWidgets('Widget shows historical recordings when present',
            (WidgetTester tester) async {
          final mockFirebaseAuth = MockFirebaseAuth();
          final mockRecordingViewModel = MockRecordingViewModel();

          final tUser = MockUser(
            isAnonymous: false,
            uid: 'user_id',
            email: 'user@example.com',
            displayName: 'Test User',
          );

          when(mockFirebaseAuth.currentUser).thenReturn(tUser);

          await tester.pumpWidget(
            ChangeNotifierProvider<RecordingViewModel>.value(
              value: mockRecordingViewModel,
              child: MaterialApp(
                home: HistoryView(auth: mockFirebaseAuth),
              ),
            ),
          );
          expect(find.text('Recording Date: '), findsNothing);

          Recording historicalRecord = Recording(
              IdGenerator.generateId(),  // id
              'user_id',                    // userId
              DateTime.now(),            // recordingDate
              3,                         // numberOfRuns
              10.0,                       // maxSpeed
              2.0,                       // averageSpeed
              3.0,                       // totalDistance
              4.0,                       // totalVertical
              5,                         // maxElevation
              5,                         // minElevation
              5                          // duration
          );

          mockRecordingViewModel.recordingHistory.add(historicalRecord);

          await tester.pumpWidget(
            ChangeNotifierProvider<RecordingViewModel>.value(
              value: mockRecordingViewModel,
              child: MaterialApp(
                home: HistoryView(auth: mockFirebaseAuth),
              ),
            ),
          );

          expect(find.text('Number of Runs: 3'), findsOneWidget);
        });
  });
}
