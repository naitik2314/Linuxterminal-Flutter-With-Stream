import 'cmd.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void loi(BuildContext context) {
    var alertDialog = AlertDialog(
        title: Text("Log out of app?"),
        content: Text("Are you sure you want to log out of the app!"),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel")),
          FlatButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, 'SignIn', (route) => false);
              },
              child: Text("Log Out"))
        ]);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Linux Terminal App"),
          backgroundColor: Colors.black,
          actions: [
            IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  loi(context);
                })
          ],
        ),
        body: Body());
  }
}
