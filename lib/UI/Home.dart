import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int RouteIndex = 0;
  static List<Container> routes = <Container>[
    Container(
      child: Center(child: Text("Home")),
    ),
    Container(
      child: Center(child: Text("user")),
    ),
    Container(
      child: Center(child: Text("TIme")),
    ),
    Container(
      child: Center(child: Text("history")),
    ),
  ];

  void _ontap(int index){
    setState(() {
      RouteIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: routes.elementAt(RouteIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'User',
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
              icon: Icon(Icons.schedule),
              label: 'Reminders',
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
              icon: Icon(Icons.auto_graph),
              label: 'History',
              backgroundColor: Colors.green),
        ],
        onTap: _ontap,
        currentIndex: RouteIndex,
        elevation: 0,
      ),
    );
  }
}
