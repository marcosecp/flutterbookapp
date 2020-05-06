import 'package:flutter/material.dart';
import 'package:flutterbook/models/user.dart';
import 'package:flutterbook/services/database.dart';
import 'package:flutterbook/shared/constants.dart';
import 'package:flutterbook/shared/loading.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2','3', '4 '];
  String _currentName;
  String _currentSugars;
  int _currentStrength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text('Update your brew settings', style: TextStyle(color: Colors.white, fontSize: 22, fontFamily: 'Roboto'),),
                  SizedBox(height: 20,),
                  TextFormField(
                    initialValue: userData.name,
                    decoration: textInputDecoration.copyWith(hintText: 'Enter your Name'),
                    validator: (val) => val.isEmpty ? 'Please enter a name' : null,
                    onChanged: (val) => setState(() => _currentName = val),
                  ),
                  SizedBox(height: 20,),
                  DropdownButtonFormField(
                    value: _currentSugars ?? userData.sugars,
                    onChanged: (val) => setState(() => _currentSugars = val),
                    decoration: textInputDecoration,
                    items: sugars.map((sugar){
                      return DropdownMenuItem(
                        value: sugar,
                        child: Text('$sugar sugars',),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20,),
                  Text('Strength of your coffee', style: TextStyle(color: Colors.white, fontSize: 18),),
                  Slider(
                    inactiveColor: Colors.brown[_currentStrength ?? userData.strength],
                    activeColor: Colors.brown[_currentStrength ?? userData.strength],
                    value: (_currentStrength ?? userData.strength).toDouble(),
                    min: 100,
                    max: 900,
                    divisions: 8,
                    onChanged: (val) => setState(() => _currentStrength = val.round()),
                  ),
                  SizedBox(height: 40,),
                  RaisedButton(
                    color: Colors.yellow,
                    child: Text(
                      'Update', style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await DatabaseService(uid:  user.uid).updateUserDate(
                            _currentSugars ?? userData.sugars,
                            _currentName ?? userData.name,
                            _currentStrength ?? userData.strength
                        );
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            );
          } else {
            return Loading();
          }
      }
    );
  }
}
