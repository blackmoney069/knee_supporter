import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.person,
                  size: 100,
                  color: Colors.green,
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(200)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Lovish Bains",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.green[400],
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5),
              ),
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
    );
  }
}
