import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldNavBar extends StatefulWidget {
  final String location;
  final Widget child;

  const ScaffoldNavBar({
    super.key,
    required this.child,
    required this.location
  });

  @override
  State<ScaffoldNavBar> createState() => ScaffoldNavBarState();
}

class ScaffoldNavBarState extends State<ScaffoldNavBar> {
  int currentIndex = 0;
  static const String route1 = '/login';
  static const String route2 = '/record-activity';
  static const String route3 = '/history';
  static const String route4 = '/map';

  static const List<MyCustomBottomNavBarItem> tabs = [
    MyCustomBottomNavBarItem(
      icon: Icon(Icons.list_alt_outlined),
      activeIcon: Icon(Icons.list_alt),
      label: 'LOGIN',
      initialLocation: route1,
    ),
    MyCustomBottomNavBarItem(
      icon: Icon(Icons.downhill_skiing_outlined),
      activeIcon: Icon(Icons.downhill_skiing),
      label: 'RECORD',
      initialLocation: route2,
    ),
    MyCustomBottomNavBarItem(
      icon: Icon(Icons.list_alt_outlined),
      activeIcon: Icon(Icons.list_alt),
      label: 'HISTORY',
      initialLocation: route3,
    ),
    MyCustomBottomNavBarItem(
      icon: Icon(Icons.location_on_outlined),
      activeIcon: Icon(Icons.location_on),
      label: 'MAP',
      initialLocation: route4,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    const labelStyle = TextStyle(fontFamily: 'Roboto');
    return Scaffold(
      body: SafeArea(child: widget.child),
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: labelStyle,
        unselectedLabelStyle: labelStyle,

        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          _goOtherTab(context, index);
        },
        currentIndex: widget.location == route1
            ? 0
            : widget.location == route2
            ? 1
            : widget.location == route3
            ? 2
            : 3,
        items: tabs,
      ),
    );
  }

  void _goOtherTab(BuildContext context, int index) {
    if (index == currentIndex) return;
    GoRouter router = GoRouter.of(context);
    String location = tabs[index].initialLocation;

    setState(() {
      currentIndex = index;
    });
    router.go(location);
  }
}

class MyCustomBottomNavBarItem extends BottomNavigationBarItem {
  final String initialLocation;

  const MyCustomBottomNavBarItem(
      {required this.initialLocation,
        required Widget icon,
        String? label,
        Widget? activeIcon})
      : super(icon: icon, label: label, activeIcon: activeIcon ?? icon);
}
