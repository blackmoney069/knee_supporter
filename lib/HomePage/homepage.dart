import 'package:KneeSupporter/BluetoothFunc/classicConnectedDevices.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Knee Supporter App")),
        elevation: 0,
      ),
      body: BluetoothFunc(),
    );
  }
}


