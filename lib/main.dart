import 'package:flutter/material.dart';
import 'package:flutterbook/appointments/appointments.dart';
import 'package:flutterbook/models/user.dart';
import 'package:flutterbook/notes/notes.dart';
import 'package:flutterbook/services/auth.dart';
import 'package:flutterbook/tasks/tasks.dart';
import 'package:flutterbook/wrapper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'utils.dart' as utils;
import 'package:path_provider/path_provider.dart';


void main() {
    WidgetsFlutterBinding.ensureInitialized();
    startMeUp() async {
    Directory docsDir = await getApplicationDocumentsDirectory();
    utils.docsDir = docsDir;
    runApp(FlutterBook());
  }
  startMeUp();
}

class FlutterBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.brown[900],
          accentColor: Colors.brown[400],
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.indigo[900],
          accentColor: Colors.indigo[900],
        ),
        home: Wrapper(),
      ),
    );
  }
}