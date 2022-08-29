import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier{
  final _googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    try{
      final GoogleUser = await _googleSignIn.signIn();
      if (GoogleUser == null) return;
      _user = GoogleUser;

      final googleAuth = await GoogleUser.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch(e){
      print(e.toString());
    }
    notifyListeners();
  }

  Future googleLogut() async{
    await _googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}