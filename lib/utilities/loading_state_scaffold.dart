import 'package:flutter/material.dart';

class LoadingState extends StatelessWidget {
  final Widget child;
  const LoadingState({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Material(child: Center(child: child,),),);
  }
}
