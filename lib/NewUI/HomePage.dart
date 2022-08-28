import 'package:KneeSupporter/NewUI/DataPage.dart';
import 'package:KneeSupporter/NewUI/SetupPage.dart';
import 'package:KneeSupporter/NewUI/UserPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;


  final screens = [
    SetupPage(),
    DataPage(),
    UserPage()
  ];

  void _onClick(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Knee Supporter App",
          style: TextStyle(fontFamily: "Silkscreen", color: Colors.green),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Setup"),
          BottomNavigationBarItem(
              icon: Icon(Icons.data_saver_off_rounded), label: "Data"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "User"),
        ],
        onTap: _onClick,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        elevation: 0,
      ),
    );
  }
}
