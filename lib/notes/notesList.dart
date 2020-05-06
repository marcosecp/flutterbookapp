import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'notesDBWorker.dart';
import 'notesModel.dart' show Note, NotesModel, notesModel;

class NotesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return ScopedModel<NotesModel>(
      model: notesModel,
      child: ScopedModelDescendant<NotesModel>(
          builder: (BuildContext context, Widget child, NotesModel inModel) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            elevation: 8,
            splashColor: Colors.yellow,
            child: Icon(
              FontAwesomeIcons.plus,
              color: Colors.white,
            ),
            onPressed: () {
              notesModel.entityBeingEdited = Note();
              notesModel.setColor(null);
              notesModel.setStackIndex(1);
            },
          ),
          body: ListView.builder(
              itemCount: notesModel.entityList.length,
              itemBuilder: (BuildContext inBuildContext, int inIndex) {
                Note note = notesModel.entityList[inIndex];
                Color color = Colors.white;
                switch (note.color) {
                  case 'red':
                    color = Colors.red[200];
                    break;
                  case 'green':
                    color = Colors.green[200];
                    break;
                  case 'blue':
                    color = Colors.blue[200];
                    break;
                  case 'yellow':
                    color = Colors.yellow[200];
                    break;
                  case 'grey':
                    color = Colors.grey;
                    break;
                  case 'purple':
                    color = Colors.indigo[200];
                    break;
                }
                return Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: FontAwesomeIcons.trash,
                        onTap: () {
                          _deleteNote(context, note);
                        },
                      ),
                    ],
                    child: Card(
                      elevation: 10,
                      color: color,
                      child: ListTile(
                        title: Text(
                          '${note.title}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontFamily: 'RobotoSlab',
                          ),
                        ),
                        subtitle: Text(
                          '${note.content}',
                          style: TextStyle(
                              color: Colors.black87, fontFamily: 'Roboto',),
                        ),
                        onTap: () async {
                          notesModel.entityBeingEdited =
                              await NotesDBWorker.db.get(note.id);
                          notesModel
                              .setColor(notesModel.entityBeingEdited.color);
                          notesModel.setStackIndex(1);
                        },
                      ),
                    ),
                  ),
                );
              }),
        );
      }),
    );
  }

  Future _deleteNote(BuildContext inContext, Note inNote) {
    return showDialog(
        context: inContext,
        barrierDismissible: false,
        builder: (BuildContext inAlertContext) {
          return AlertDialog(
            title: Text('Delete Note'),
            content: Text('Are yout sure you want to delete ${inNote.title}?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(inAlertContext).pop();
                },
              ),
              FlatButton(
                child: Text('Delete'),
                onPressed: () async {
                  await NotesDBWorker.db.delete(inNote.id);
                  Navigator.of(inAlertContext).pop();
                  Scaffold.of(inContext).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 2),
                    content: Text('Note deleted'),
                  ));
                  notesModel.loadData("notes", NotesDBWorker.db);
                },
              ),
            ],
          );
        });
  }
}
