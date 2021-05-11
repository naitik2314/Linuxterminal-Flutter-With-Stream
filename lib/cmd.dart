import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  final firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;
  TextEditingController command = TextEditingController();
  var input;
  @override
  void initState() {
    super.initState();
    firestoreInstance.collection("Users").doc(firebaseUser.uid).set({
      "Result": "",
      "statusCode": "",
    });
  }

  getOutput(input) async {
    var url = 'http://5a130c7819ba.ngrok.io/cgi-bin/cmd.py?x=$input';
    var result = await http.get(url);
    var output = json.decode(result.body);

    await firestoreInstance.collection("Users").doc(firebaseUser.uid).set({
      "Result": output['Result'],
      "statusCode": output['statusCode']
    }).then((_) => print("Sucess"));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 50.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 15, 8, 8),
                      child: Center(
                          child: Text("Linux Terminal",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold))),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: TextFormField(
                        controller: command,
                        decoration: InputDecoration(
                          labelText: "Enter Linux command",
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Form Field Value Required';
                          }
                          input = value;
                          return null;
                        },
                      ),
                    ),
                    Center(
                        child: RaisedButton(
                      color: Colors.green,
                      child: Text("Execute Command"),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          getOutput(input);
                        }
                      },
                    ))
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              StreamBuilder(
                stream: firestoreInstance
                    .collection("Users")
                    .doc(firebaseUser.uid)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData)
                    return Text("No Data");
                  else {
                    var info = snapshot.data.data();
                    // print(info['ContainerID']);
                    return SingleChildScrollView(
                      child: Container(
                        width: (MediaQuery.of(context).size.width) * 0.95,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 1, 20, 200),
                          child: Text(
                            (info['Result'] != null) ? info['Result'] : "",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.black87,
                                style: BorderStyle.solid)),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
