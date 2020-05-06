import 'package:flutter/material.dart';
import 'package:flutterbook/authenticate/authenticate.dart';
import 'package:flutterbook/home.dart';
import 'package:flutterbook/models/user.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }

  }
}
