import 'package:SnowGauge/utilities/dependencies.dart';
import 'package:SnowGauge/view_models/recording_view_model.dart';
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

  group('RecordActivityView Widget Tests', () {
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
                home: RecordActivityView(auth: mockFirebaseAuth),
              ),
            ),
          );

          expect(find.text('You must be signed in to use this feature'), findsOneWidget);
        });

    testWidgets('Test recording workflow',
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

          // when(mockRecordingViewModel.isRecording).thenReturn(false);

          await tester.pumpWidget(
            ChangeNotifierProvider<RecordingViewModel>.value(
              value: mockRecordingViewModel,
              child: MaterialApp(
                home: RecordActivityView(auth: mockFirebaseAuth),
              ),
            ),
          );

          expect(find.text('Record Activity'), findsOneWidget);
          expect(find.text('Not Recording'), findsOneWidget);

          await tester.tap(find.text('Start Recording'));
          await tester.pumpAndSettle();

          expect(find.text('Recording...'), findsOneWidget);

          await tester.tap(find.text('Pause'));
          await tester.pumpAndSettle();

          expect(find.text('Paused'), findsOneWidget);

          await tester.tap(find.text('Resume'));
          await tester.pumpAndSettle();

          expect(find.text('Stop Recording'), findsOneWidget);

          await tester.tap(find.text('Stop Recording'));
          await tester.pumpAndSettle();

          expect(find.text('Save Recording?'), findsOneWidget);

          await tester.tap(find.text('Discard'));
          await tester.pumpAndSettle();

          expect(find.text('Recording Discarded!'), findsOneWidget);

          await tester.tap(find.text('OK'));
          await tester.pumpAndSettle();

          await tester.tap(find.text('Start Recording'));
          await tester.pumpAndSettle();

          expect(find.text('Recording...'), findsOneWidget);
          expect(find.text('Stop Recording'), findsOneWidget);

          await tester.tap(find.text('Stop Recording'));
          await tester.pumpAndSettle();

          expect(find.text('Save Recording?'), findsOneWidget);

          // await tester.tap(find.text('Save'));
          // await tester.pumpAndSettle();
          //
          // await tester.tap(find.text('Start Recording'));
        });
  });
}
