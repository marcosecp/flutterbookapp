import 'package:flutter/material.dart';
import 'package:flutterbook/brew/brew.dart';

class BrewTile extends StatelessWidget {
  final Brew brew;

  BrewTile({this.brew});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: ListTile(
          title: Text(brew.name),
          leading: CircleAvatar(
            backgroundImage: AssetImage('images/coffee_icon.png'),
            radius: 35,
            backgroundColor: Colors.brown[brew.strength],
          ),
          subtitle: Text('Takes ${brew.sugars} sugar(s)',),
        ),
      ),
    );
  }
}
