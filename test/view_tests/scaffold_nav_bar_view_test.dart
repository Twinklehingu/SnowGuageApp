import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SnowGauge/views/scaffold_nav_bar_view.dart';

void main() {
  testWidgets('ScaffoldNavBar widget test', (WidgetTester tester) async {
    final GlobalKey<ScaffoldNavBarState> scaffoldNavBarKey =
    GlobalKey<ScaffoldNavBarState>();

    await tester.pumpWidget(
      MaterialApp(
        home: ScaffoldNavBar(
          key: scaffoldNavBarKey,
          location: '/login',
          child: Container(), // Initial location for testing
        ),
      ),
    );

    final ScaffoldNavBarState state = scaffoldNavBarKey.currentState!;

    expect(find.byType(ScaffoldNavBar), findsOneWidget);
    expect(state.currentIndex, 0); // Initial index should be 0 (for '/login')
  });
}
