import 'package:flutter/material.dart';
import 'package:flutterbook/authenticate/register.dart';
import 'package:flutterbook/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggle() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView: toggle);
    } else {
      return Register(toggleView: toggle);
    }
  }
}
