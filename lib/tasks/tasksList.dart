import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutterbook/tasks/tasksDBWorker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'tasksModel.dart' show Task, TasksModel, tasksModel;

class TasksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<TasksModel>(
      model: tasksModel,
      child: ScopedModelDescendant<TasksModel>(builder:
          (BuildContext inBuildContext, Widget child, TasksModel inModel) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            elevation: 8,
            splashColor: Colors.yellow,
            child: Icon(
              FontAwesomeIcons.plus,
              color: Colors.white,
            ),
            onPressed: () {
              tasksModel.entityBeingEdited = Task();
              tasksModel.setChosenDate(null);
              tasksModel.setStackIndex(1);
            },
          ),
          body: ListView.builder(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              itemCount: tasksModel.entityList.length,
              itemBuilder: (BuildContext inBuildContext, int inIndex) {
                Task task = tasksModel.entityList[inIndex];
                String sDueDate;
                if (task.dueDate != null) {
                  List dateParts = task.dueDate.split(',');
                  DateTime dueDate = DateTime(int.parse(dateParts[0]),
                      int.parse(dateParts[1]), int.parse(dateParts[2]));
                  sDueDate =
                      DateFormat.yMMMd("en_US").format(dueDate.toLocal());
                }
                return Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: "Delete",
                        color: Colors.red,
                        icon: FontAwesomeIcons.trash,
                        onTap: () => _deleteTask(context, task),
                      ),
                    ],
                    child: ListTile(
                      leading: Checkbox(
                        value: task.completed == "true" ? true : false,
                        onChanged: (inValue) async {
                          task.completed = inValue.toString();
                          await TasksDBWorker.db.update(task);
                          tasksModel.loadData('tasks', TasksDBWorker.db);
                        },
                      ),
                      title: Text(
                        '${task.description}',
                        style: task.completed == "true"
                            ? TextStyle(
                            color: Theme
                                .of(context)
                                .disabledColor,
                            decoration: TextDecoration.lineThrough)
                            : TextStyle(
                            color:
                            Theme
                                .of(context)
                                .textTheme
                                .title
                                .color),
                      ),
                      subtitle: task.dueDate == null
                          ? null
                          : Text(
                        sDueDate,
                        style: task.completed == 'true'
                            ? TextStyle(
                            color: Theme
                                .of(context)
                                .disabledColor,
                            decoration: TextDecoration.lineThrough)
                            : TextStyle(
                            color: Theme
                                .of(context)
                                .textTheme
                                .title
                                .color),
                      ),
                      onTap: () async {
                        if (task.completed == "true") {
                          return;
                        }
                        tasksModel.entityBeingEdited =
                        await TasksDBWorker.db.get(task.id);
                        if (tasksModel.entityBeingEdited.dueDate == null) {
                          tasksModel.setChosenDate(null);
                        } else {
                          tasksModel.setChosenDate(sDueDate);
                        }
                        tasksModel.setStackIndex(1);
                      },
                    ),
                );
              }),
        );
      }
      ),
    );
  }

    Future _deleteTask(BuildContext context, Task inTask) {
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext inAlertContext) {
            return AlertDialog(
              title: Text('Delete Task'),
              content:
              Text('Are yout sure you want to delete ${inTask.description}?'),
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
                    await TasksDBWorker.db.delete(inTask.id);
                    Navigator.of(inAlertContext).pop();
                    Scaffold.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                      content: Text('Task deleted'),
                    ));
                    tasksModel.loadData("tasks", TasksDBWorker.db);
                  },
                ),
              ],
            );
          });
    }
}
