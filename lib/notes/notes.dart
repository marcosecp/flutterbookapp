import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'notesDBWorker.dart';
import 'notesList.dart';
import 'notesEntry.dart';
import 'notesModel.dart' show NotesModel, notesModel;

class Notes extends StatelessWidget {

  Notes() {
    notesModel.loadData('notes', NotesDBWorker.db);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<NotesModel>(
        model: notesModel,
        child: ScopedModelDescendant<NotesModel>(
            builder: (BuildContext context, Widget child, NotesModel inModel) {
          return IndexedStack(
            index: inModel.stackIndex,
            children: [NotesList(), NotesEntry()]
          );
        }
        )
    );
  }
}
