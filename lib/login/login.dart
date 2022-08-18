import 'package:flutter/material.dart';

class loginPage extends StatelessWidget {
  const loginPage({Key? key}) : super(key: key);

  @override
  // void initState(){
  //   super.initState()
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Text("Welcome!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 60,
            fontFamily: "Silkscreen"
          ),
        ),
      ),
    );
  }
}
