 import 'package:flutter/material.dart';
import 'package:flutterbook/services/auth.dart';
import 'package:flutterbook/shared/constants.dart';
import 'package:flutterbook/shared/loading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register ({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.indigo[100],
      appBar: AppBar(
        centerTitle: false,
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () {
                widget.toggleView();
              },
              icon: Icon(FontAwesomeIcons.user, color: Colors.yellow,),
              label: Text('Sign up', style: TextStyle(color: Colors.white),))
        ],
        backgroundColor: Colors.indigo[400],
        elevation: 0.0,
        title: Text('Sign up to FlutterBook'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20,),
              TextFormField(
                decoration: textInputDecoration,
                validator: (val) => val.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                },
              ),
              SizedBox(height: 20,),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Password'),
                validator: (val) => val.length < 6 ? 'Enter an password 6+ chars long' : null,
                obscureText: true,
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
              ),
              SizedBox(height: 20,),
              RaisedButton(
                color: Colors.yellow,
                child: Text(
                  'Register', style: TextStyle(color: Colors.black),
                ),
                onPressed: () async {
                  if(_formKey.currentState.validate()) {
                    setState(() {
                      loading = true;
                    });
                    dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                    if (result == null) {
                      setState(() {
                        error = 'please supply a valid email';
                        print(error);
                        loading = false;
                      });
                    }
                  }
                },
              ),
              SizedBox(height: 12,),
              Text(error, style: TextStyle(color: Colors.red, fontSize: 14),)
            ],
          ),
        ),
      ),
    );
  }
}
