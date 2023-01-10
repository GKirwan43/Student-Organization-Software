import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWheel extends StatelessWidget {
  const LoadingWheel({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(child: SpinKitCubeGrid(color: Colors.blue, size: 50)));
  }
}
