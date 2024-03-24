import 'package:SnowGauge/utilities/dependencies.dart';
import 'package:SnowGauge/views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../test_utils/firebase_mock_setup.dart';
import '../test_utils/login_view_test.mocks.dart';

@GenerateMocks([FirebaseAuth, UserCredential, User])
void main() async {

  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  group('LoginView Widget Tests', () {
    testWidgets('Test signing a user up',
            (WidgetTester tester) async {
          final mockFirebaseAuth = MockFirebaseAuth();
          final mockCredential = MockUserCredential();
          MockUser mockUser = MockUser();

          registerDependencies(mockFirebaseAuth);

          when(mockCredential.user).thenReturn(mockUser);
          final futureCred = Future.value(mockCredential);

          when(mockFirebaseAuth.createUserWithEmailAndPassword(email: 'test@email.com', password: '123456'))
              .thenAnswer((_) => futureCred);

          when(mockFirebaseAuth.currentUser).thenReturn(null);

          await tester.pumpWidget(MaterialApp(
                home: LoginView(auth: mockFirebaseAuth),
              ),
          );

          final emailField = find.ancestor(
            of: find.text('Email'),
            matching: find.byType(TextFormField),
          );

          await tester.enterText(emailField, "test@email.com");
          expect(find.text('test@email.com') , findsOneWidget);

          final passwordField = find.ancestor(
            of: find.text('Password'),
            matching: find.byType(TextFormField),
          );

          await tester.enterText(passwordField, "123456");
          expect(find.text('123456') , findsOneWidget);

          await tester.tap(find.text('Sign up'));
          await tester.pumpAndSettle();
        });
    testWidgets('Test signup error display',
            (WidgetTester tester) async {
          final mockFirebaseAuth = MockFirebaseAuth();
          final mockCredential = MockUserCredential();
          MockUser mockUser = MockUser();

          when(mockCredential.user).thenReturn(mockUser);
          final futureCred = Future.value(mockCredential);

          when(mockFirebaseAuth.createUserWithEmailAndPassword(email: 'test@email.com', password: '123456'))
              .thenThrow(FirebaseAuthException(code: '1', message: 'test error'));

          await tester.pumpWidget(MaterialApp(
                home: LoginView(auth: mockFirebaseAuth),
              ),
          );

          final emailField = find.ancestor(
            of: find.text('Email'),
            matching: find.byType(TextFormField),
          );

          await tester.enterText(emailField, "test@email.com");
          expect(find.text('test@email.com') , findsOneWidget);

          final passwordField = find.ancestor(
            of: find.text('Password'),
            matching: find.byType(TextFormField),
          );

          await tester.enterText(passwordField, "123456");
          expect(find.text('123456') , findsOneWidget);

          await tester.tap(find.text('Sign up'));
          await tester.pumpAndSettle();

          expect(find.text('1'), findsOneWidget);
        });
    testWidgets('Test signing a user in',
            (WidgetTester tester) async {
          final mockFirebaseAuth = MockFirebaseAuth();
          final mockCredential = MockUserCredential();
          MockUser mockUser = MockUser();

          when(mockCredential.user).thenReturn(mockUser);
          final futureCred = Future.value(mockCredential);

          when(mockFirebaseAuth.signInWithEmailAndPassword(email: 'test@email.com', password: '123456'))
              .thenAnswer((_) => futureCred);

          await tester.pumpWidget(MaterialApp(
                home: LoginView(auth: mockFirebaseAuth),
              ),
          );

          final emailField = find.ancestor(
            of: find.text('Email'),
            matching: find.byType(TextFormField),
          );

          await tester.enterText(emailField, "test@email.com");
          expect(find.text('test@email.com') , findsOneWidget);

          final passwordField = find.ancestor(
            of: find.text('Password'),
            matching: find.byType(TextFormField),
          );

          await tester.enterText(passwordField, "123456");
          expect(find.text('123456') , findsOneWidget);

          await tester.tap(find.text('Sign in'));
          await tester.pumpAndSettle();
        });
    testWidgets('Test sign in error display',
            (WidgetTester tester) async {
          final mockFirebaseAuth = MockFirebaseAuth();
          final mockCredential = MockUserCredential();
          MockUser mockUser = MockUser();

          when(mockCredential.user).thenReturn(mockUser);
          final futureCred = Future.value(mockCredential);

          when(mockFirebaseAuth.signInWithEmailAndPassword(email: 'test@email.com', password: '123456'))
              .thenThrow(FirebaseAuthException(code: '1', message: 'test error'));

          await tester.pumpWidget(MaterialApp(
                home: LoginView(auth: mockFirebaseAuth),
              ),
          );

          final emailField = find.ancestor(
            of: find.text('Email'),
            matching: find.byType(TextFormField),
          );

          await tester.enterText(emailField, "test@email.com");
          expect(find.text('test@email.com') , findsOneWidget);

          final passwordField = find.ancestor(
            of: find.text('Password'),
            matching: find.byType(TextFormField),
          );

          await tester.enterText(passwordField, "123456");
          expect(find.text('123456') , findsOneWidget);

          await tester.tap(find.text('Sign in'));
          await tester.pumpAndSettle();

          expect(find.text('1'), findsOneWidget);
        });
  });
}
