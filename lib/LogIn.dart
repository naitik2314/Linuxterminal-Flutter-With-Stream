import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isUserCorrect = false;

  loginUser({String email, String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushNamedAndRemoveUntil(context, 'Home', (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        _showDialog('No User found');
        setState(() {
          isLoading = false;
        });
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        _showDialog('Wrong password provided');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _showDialog(String errorInfo) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(errorInfo),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Close"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: CircularProgressIndicator(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Log In Page"),
          backgroundColor: Colors.black,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
              SizedBox(height: 80.0),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text("Log In",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    )),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'EMAIL',
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green))),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter Email id';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: 'PASSWORD ',
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green))),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Password';
                      }
                      return null;
                    }),
              ),
              SizedBox(height: 50.0),
              Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  height: 40.0,
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    shadowColor: Colors.greenAccent,
                    color: Colors.green,
                    elevation: 4.0,
                    child: GestureDetector(
                      onTap: () {
                        if (_formKey.currentState.validate()) {
                          loginUser(
                              email: emailController.text,
                              password: passwordController.text);
                        }
                        setState(() {
                          isLoading = true;
                        });
                        Future.delayed(const Duration(seconds: 5), () {
                          if (mounted) {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        });
                      },
                      child: Center(
                        child: Text(
                          'LoginIn',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'),
                        ),
                      ),
                    ),
                  )),
              SizedBox(height: 15.0),
              Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  height: 40.0,
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    shadowColor: Colors.greenAccent,
                    color: Colors.green,
                    elevation: 4.0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, 'SignUp');
                      },
                      child: Center(
                        child: Text(
                          'REGISTER USING EMAIL',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'),
                        ),
                      ),
                    ),
                  )),
            ]),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
