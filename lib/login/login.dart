// ignore_for_file: prefer_const_constructors

import 'package:KneeSupporter/HomePage/homepage.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';



class loginPage extends StatelessWidget {
  const loginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      navigateAfterSeconds: HomePage(),
      title: Text("Welcome!",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 60,
            fontFamily: "Silkscreen"
        ),),
      backgroundColor: Colors.green,
      loadingText: Text("Loading Data!",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 20,
            fontFamily: "Silkscreen"
        ),),
      loaderColor: Colors.black,
    );
  }
}





