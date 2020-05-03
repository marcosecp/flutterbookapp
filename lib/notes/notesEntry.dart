import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'notesDBWorker.dart';
import 'notesModel.dart' show NotesModel, notesModel;

class NotesEntry extends StatelessWidget {
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _contentEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  NotesEntry() {
    _titleEditingController.addListener(() {
      notesModel.entityBeingEdited.title = _titleEditingController.text;
    });
    _contentEditingController.addListener(() {
      notesModel.entityBeingEdited.content = _contentEditingController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (notesModel.entityBeingEdited != null) {
      _titleEditingController.text = notesModel.entityBeingEdited.title;
      _contentEditingController.text = notesModel.entityBeingEdited.content;
    }
    return ScopedModel(
      model: notesModel,
      child: ScopedModelDescendant<NotesModel>(
        builder: (BuildContext inContext, Widget child, NotesModel inModel) {
          return Scaffold(
            bottomNavigationBar: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: <Widget>[
                  FlatButton(
                    child: Text('Cancel', style: TextStyle(fontSize: 20),),
                    onPressed: () {
                      FocusScope.of(inContext).requestFocus(FocusNode());
                      inModel.setStackIndex(0);
                    },
                  ),
                  Spacer(),
                  FlatButton(
                      child: Text('Save', style: TextStyle(fontSize: 20),),
                      onPressed : () { _save(inContext, notesModel); }
                  ),
                ],
              ),
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.title),
                    title: TextFormField(
                      decoration: InputDecoration(hintText: 'Title'),
                      controller: _titleEditingController,
                      validator: (String inValue) {
                        if (inValue.length == 0) {
                          return 'Please enter a title';
                        }
                        return null;
                      }
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.content_paste),
                    title: TextFormField(
                      keyboardType:  TextInputType.multiline,
                        maxLines: 9,
                        style: TextStyle(fontFamily: 'Roboto',),
                        decoration: InputDecoration(hintText: 'Content'),
                        controller: _contentEditingController,
                        validator: (String inValue) {
                          if (inValue.length == 0) {
                            return 'Please enter content';
                          }
                          return null;
                        }
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.color_lens),
                    title: Row(
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            decoration: ShapeDecoration(
                              shape: Border.all(width: 18, color: Colors.red[300]) + Border.all(width: 6, color: notesModel.color == 'red' ? Colors.red[300]: Theme.of(inContext).canvasColor)
                            ),
                          ),
                          onTap: () {
                            notesModel.entityBeingEdited.color = "red";
                            notesModel.setColor("red");
                          },
                        ),
                        Spacer(),
                        GestureDetector(
                          child: Container(
                            decoration: ShapeDecoration(
                                shape: Border.all(width: 18, color: Colors.blue[300]) + Border.all(width: 6, color: notesModel.color == 'blue' ? Colors.blue[300]: Theme.of(inContext).canvasColor)
                            ),
                          ),
                          onTap: () {
                            notesModel.entityBeingEdited.color = 'blue';
                            notesModel.setColor('blue');
                          },
                        ),
                        Spacer(),
                        GestureDetector(
                          child: Container(
                            decoration: ShapeDecoration(
                                shape: Border.all(width: 18, color: Colors.green[300]) + Border.all(width: 6, color: notesModel.color == 'green' ? Colors.green[300]: Theme.of(inContext).canvasColor)
                            ),
                          ),
                          onTap: () {
                            notesModel.entityBeingEdited.color = 'green';
                            notesModel.setColor('green');
                          },
                        ),
                        Spacer(),
                        GestureDetector(
                          child: Container(
                            decoration: ShapeDecoration(
                                shape: Border.all(width: 18, color: Colors.yellow[300]) + Border.all(width: 6, color: notesModel.color == 'yellow' ? Colors.yellow[300]: Theme.of(inContext).canvasColor)
                            ),
                          ),
                          onTap: () {
                            notesModel.entityBeingEdited.color = 'yellow';
                            notesModel.setColor('yellow');
                          },
                        ),
                        Spacer(),
                        GestureDetector(
                          child: Container(
                            decoration: ShapeDecoration(
                                shape: Border.all(width: 18, color: Colors.indigoAccent) + Border.all(width: 6, color: notesModel.color == 'purple' ? Colors.indigoAccent: Theme.of(inContext).canvasColor)
                            ),
                          ),
                          onTap: () {
                            notesModel.entityBeingEdited.color = 'purple';
                            notesModel.setColor('purple');
                          },
                        ),
                        Spacer(),
                        GestureDetector(
                          child: Container(
                            decoration: ShapeDecoration(
                                shape: Border.all(width: 18, color: Colors.grey) + Border.all(width: 6, color: notesModel.color == 'grey' ? Colors.grey: Theme.of(inContext).canvasColor)
                            ),
                          ),
                          onTap: () {
                            notesModel.entityBeingEdited.color = 'grey';
                            notesModel.setColor('grey');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _save(BuildContext inContext, NotesModel inModel) async {

    print("## NotesEntry._save()");

    if (!_formKey.currentState.validate()) { return; }

    if (inModel.entityBeingEdited.id == null) {
      await NotesDBWorker.db.create(notesModel.entityBeingEdited);

    } else {
      await NotesDBWorker.db.update(notesModel.entityBeingEdited);

    }

    notesModel.loadData("notes", NotesDBWorker.db);
    inModel.setStackIndex(0);

    Scaffold.of(inContext).showSnackBar(
        SnackBar(
            backgroundColor : Colors.green,
            duration : Duration(seconds : 2),
            content : Text("Note saved", textAlign: TextAlign.center, style: TextStyle(fontSize: 25, color: Colors.white),)
        )
    );
  }
}
