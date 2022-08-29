import 'package:KneeSupporter/NewUI/HomePage.dart';
import 'package:KneeSupporter/NewUI/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SigninWidget extends StatelessWidget {
  const SigninWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.grey, //or set color with: Color(0xFF0000FF)
    ));

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.grey,
          width: MediaQuery.of(context).size.width,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      "Welcome!",
                      style: TextStyle(
                        fontFamily: "Silkscreen",
                        fontSize: 50,
                      ),
                    ),
                    Text(
                      "Please sign in to continue!",
                      style: TextStyle(
                        fontFamily: "Silkscreen",
                        fontSize: 13,
                      ),
                    )
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);
                    provider.googleLogin();
                  },
                  icon: FaIcon(FontAwesomeIcons.google),
                  label: Text("Sign in with Google"),
                )
              ]),
        ),
      ),
    );
  }
}

class SigninPage extends StatelessWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (context, snapshot) {
        if(snapshot.connectionState==ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }
        else if (snapshot.hasError){
          return Center(child: Text("Something went wrong"),);
        }
        else if(snapshot.hasData){
          return HomePage();
        }
        return SigninWidget();
      },
      stream: FirebaseAuth.instance.authStateChanges(),
    );
  }
}
