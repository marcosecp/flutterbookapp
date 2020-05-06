import 'package:flutter/material.dart';
import 'package:flutterbook/tasks/tasksDBWorker.dart';
import 'package:flutterbook/tasks/tasksModel.dart' show TasksModel, tasksModel;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutterbook/utils.dart' as utils;

class TasksEntry extends StatelessWidget {
  final TextEditingController _descriptionEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TasksEntry() {
    _descriptionEditingController.addListener(() {
      tasksModel.entityBeingEdited.description = _descriptionEditingController.text;
    });
  }

  @override
  Widget build(BuildContext inContext) {
    if (tasksModel.entityBeingEdited != null) {
      _descriptionEditingController.text = tasksModel.entityBeingEdited.description;
    }
    return ScopedModel(
      model: tasksModel,
      child: ScopedModelDescendant<TasksModel>(
        builder: (BuildContext inContext, Widget child, TasksModel inModel) {
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
                      onPressed : () { _save(inContext, tasksModel); }
                  ),
                ],
              ),
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: Icon(FontAwesomeIcons.tasks),
                    title: TextFormField(
                        keyboardType : TextInputType.multiline,
                        maxLines : 4,
                        decoration: InputDecoration(hintText: 'Description'),
                        controller: _descriptionEditingController,
                        validator: (String inValue) {
                          if (inValue.length == 0) {
                            return 'Please enter a description';
                          }
                          return null;
                        }
                    ),
                  ),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.calendarDay),
                    title: Text("Due Date", ),
                    subtitle: Text(
                      tasksModel.chosenDate == null ? '' : tasksModel.chosenDate
                    ),
                    trailing: IconButton(
                      icon: Icon(FontAwesomeIcons.edit),
                      color: Colors.blue,
                      onPressed: () async {
                        String chosenDate = await utils.selectDate(
                          inContext, tasksModel, tasksModel.entityBeingEdited.dueDate
                        );
                        if (chosenDate != null) {
                          tasksModel.entityBeingEdited.dueDate = chosenDate;
                        }
                      },
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
  void _save(BuildContext inContext, TasksModel inModel) async {

    if (!_formKey.currentState.validate()) { return; }

    if (inModel.entityBeingEdited.id == null) {
      await TasksDBWorker.db.create(tasksModel.entityBeingEdited);

    } else {
      await TasksDBWorker.db.update(tasksModel.entityBeingEdited);
    }

    tasksModel.loadData('tasks', TasksDBWorker.db);
    inModel.setStackIndex(0);

    Scaffold.of(inContext).showSnackBar(
        SnackBar(
            backgroundColor : Colors.green,
            duration : Duration(seconds : 2),
            content : Text("Task saved", textAlign: TextAlign.center, style: TextStyle(fontSize: 25, color: Colors.white),)
        )
    );
  }
}
