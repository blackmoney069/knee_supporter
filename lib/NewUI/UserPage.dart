import 'package:KneeSupporter/NewUI/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(user!.photoURL!),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                user.displayName!,
                style: TextStyle(
                  fontFamily: "Oswald",
                    fontSize: 20,
                    color: Colors.black54,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2),
              ),
            ),
          Text(
            user.email!,
            style: TextStyle(
                fontFamily: "Oswald",
                fontSize: 10,
                color: Colors.black54,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2),
          ),
            Divider(),
            Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey[100]),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(28, 8, 8, 8.0),
                        child: Icon(Icons.settings, size: 20),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(28, 8, 8, 8.0),
                        child: Text("Settings",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 18)),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey[100]),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(28, 8, 8, 8.0),
                        child: Icon(Icons.edit, size: 20),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(28, 8, 8, 8.0),
                        child: Text("Edit Details",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 18)),
                      )
                    ],
                  ),
                ),
              )
            ]),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Made with ❤ at IIT Jammu", style: TextStyle(
                color: Colors.black,
              ),),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
          provider.googleLogut();
        },
        child: const Icon(Icons.logout),
        backgroundColor: Colors.green,
      ),
    );
  }
}



