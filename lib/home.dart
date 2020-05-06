import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterbook/brew/brew_list.dart';
import 'package:flutterbook/brew/brew.dart';
import 'package:flutterbook/brew/settings_form.dart';
import 'package:flutterbook/notes/notes.dart';
import 'package:flutterbook/services/auth.dart';
import 'package:flutterbook/services/database.dart';
import 'package:flutterbook/shared/loading.dart';
import 'package:flutterbook/tasks/tasks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'appointments/appointments.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          decoration: BoxDecoration(color: Colors.indigo[400]),
          padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
          child: SettingsForm(),

        );
      });
    }

    return StreamProvider<List<Brew>>.value(
      value: DatabaseService().brews,
      child: DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: false,
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(FontAwesomeIcons.coffee, color: Colors.white, size: 18,),
                  label: Text('settings', style: TextStyle(color: Colors.white, fontSize: 12),),
                  onPressed: () {
                    _showSettingsPanel();
                  },
                ),
                IconButton(
                    onPressed: () async {
                      await _auth.signOut();
                    },
                    icon: Icon(FontAwesomeIcons.user, color: Colors.white, size: 18,),
                    ),

              ],
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
                Appointments(),
                Container(
                    child: BrewList(),
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('images/coffee2.jpg'), fit: BoxFit.cover),
                ),),
                Notes(),
                Tasks(),
              ],
            ),
          ),
        ),
    );
  }

}
