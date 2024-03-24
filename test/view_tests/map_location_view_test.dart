import 'dart:async';

import 'package:SnowGauge/utilities/dependencies.dart';
import 'package:SnowGauge/views/login_view.dart';
import 'package:SnowGauge/views/map_location_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../test_utils/firebase_mock_setup.dart';
import '../test_utils/login_view_test.mocks.dart';

@GenerateMocks([FirebaseAuth, UserCredential, User])
void main() async {
  group('MapLocationView Widget Tests', () {
    testWidgets('Test display of map',
    (WidgetTester tester) async {
      final GlobalKey<MapLocationViewState> mapLocationViewKey =
      GlobalKey<MapLocationViewState>();

      await tester.pumpWidget(MaterialApp(
        home: MapLocationView(key: mapLocationViewKey),
      ));

      final MapLocationViewState state = mapLocationViewKey.currentState!;
      final Completer<GoogleMapController> controller = state.mapController;

      // Verify that the controller is not null
      expect(controller, isNotNull);
        });
  });
}
