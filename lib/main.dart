import 'package:KneeSupporter/NewUI/HomePage.dart';
import 'package:KneeSupporter/NewUI/SignInPage.dart';
import 'package:KneeSupporter/NewUI/signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(new ExampleApplication());
}

class ExampleApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
          home: SigninPage(),
          theme: ThemeData(primarySwatch: Colors.green),
        ),
      );
}
