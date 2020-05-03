import 'package:flutter/material.dart';
import 'package:flutterbook/notes/notes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.indigo[400],
        accentColor: Colors.indigo[400],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.indigo[900],
        accentColor: Colors.indigo[900],
      ),
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
//            backgroundColor: Colors.indigo[900],
            title: Text('Flutter Book', style: TextStyle(fontFamily: 'RobotoSlab', fontSize: 28),),
            bottom: TabBar(
              indicatorColor: Colors.yellow,
              tabs: <Widget>[
                Tab(icon: Icon(FontAwesomeIcons.calendarDay,), text: 'Appointments'),
                Tab(icon: Icon(FontAwesomeIcons.solidAddressBook), text: 'Contacts'),
                Tab(icon: Icon(FontAwesomeIcons.solidStickyNote), text: 'Notes'),
                Tab(icon: Icon(FontAwesomeIcons.tasks), text: 'Tasks'),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              Container(),
              Container(),
              Notes(),
              Container(),
            ],
          ),
        ),
      ),
    );
  }
}