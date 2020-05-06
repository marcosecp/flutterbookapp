import 'package:flutter/material.dart';
import 'package:flutterbook/appointments/appointmentsDBWorker.dart';
import 'package:flutterbook/appointments/appointmentsModel.dart'
    show AppointmentsModel, appointmentsModel;
import 'package:scoped_model/scoped_model.dart';
import 'package:flutterbook/utils.dart' as utils;

class AppointmentsEntry extends StatelessWidget {
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _descriptionEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AppointmentsEntry() {
    _titleEditingController.addListener(() {
      appointmentsModel.entityBeingEdited.title = _titleEditingController.text;
    });
    _descriptionEditingController.addListener(() {
      appointmentsModel.entityBeingEdited.description = _descriptionEditingController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (appointmentsModel.entityBeingEdited != null) {
      _titleEditingController.text = appointmentsModel.entityBeingEdited.title;
      _descriptionEditingController.text = appointmentsModel.entityBeingEdited.description;
    }
    return ScopedModel(
      model: appointmentsModel,
      child: ScopedModelDescendant<AppointmentsModel>(
        builder:
            (BuildContext inContext, Widget child, AppointmentsModel inModel) {
          return Scaffold(
            bottomNavigationBar: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      FocusScope.of(inContext).requestFocus(FocusNode());
                      inModel.setStackIndex(0);
                    },
                  ),
                  Spacer(),
                  FlatButton(
                      child: Text(
                        'Save',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        _save(inContext, appointmentsModel);
                      }),
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
                        }),
                  ),
                  ListTile(
                    leading: Icon(Icons.content_paste),
                    title: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 9,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                        ),
                        decoration: InputDecoration(hintText: 'Description'),
                        controller: _descriptionEditingController,
                        validator: (String inValue) {
                          if (inValue.length == 0) {
                            return 'Please enter content';
                          }
                          return null;
                        }),
                  ),
                  ListTile(
                      leading: Icon(Icons.today),
                      title: Text("Date"),
                      subtitle: Text(appointmentsModel.chosenDate == null
                          ? ""
                          : appointmentsModel.chosenDate),
                      trailing: IconButton(
                          icon: Icon(Icons.edit),
                          color: Colors.blue,
                          onPressed: () async {
                            // Request a date from the user.  If one is returned, store it.
                            String chosenDate = await utils.selectDate(
                                inContext,
                                appointmentsModel,
                                appointmentsModel.entityBeingEdited.apptDate);
                            if (chosenDate != null) {
                              appointmentsModel.entityBeingEdited.apptDate =
                                  chosenDate;
                            }
                          })),
                  // Appointment Time.
                  ListTile(
                    leading: Icon(Icons.alarm),
                    title: Text("Time"),
                    subtitle: Text(appointmentsModel.apptTime == null
                        ? ""
                        : appointmentsModel.apptTime),
                    trailing: IconButton(
                        icon: Icon(Icons.edit),
                        color: Colors.blue,
                        onPressed: () => _selectTime(inContext)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future _selectTime(BuildContext inContext) async {
    // Default to right now, assuming we're adding an appointment.
    TimeOfDay initialTime = TimeOfDay.now();

    // If editing an appointment, set the initialTime to the current apptTime, if any.
    if (appointmentsModel.entityBeingEdited.apptTime != null) {
      List timeParts = appointmentsModel.entityBeingEdited.apptTime.split(",");
      // Create a DateTime using the hours, minutes and a/p from the apptTime.
      initialTime = TimeOfDay(
          hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
    }

    // Now request the time.
    TimeOfDay picked =
        await showTimePicker(context: inContext, initialTime: initialTime);

    // If they didn't cancel, update it on the appointment being edited as well as the apptTime field in the model so
    // it shows on the screen.
    if (picked != null) {
      appointmentsModel.entityBeingEdited.apptTime =
          "${picked.hour},${picked.minute}";
      appointmentsModel.setApptTime(picked.format(inContext));
    }
  }

  void _save(BuildContext inContext, AppointmentsModel inModel) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    if (inModel.entityBeingEdited.id == null) {
      await AppointmentsDBWorker.db.create(appointmentsModel.entityBeingEdited);
    } else {
      await AppointmentsDBWorker.db.update(appointmentsModel.entityBeingEdited);
    }

    appointmentsModel.loadData("appointments", AppointmentsDBWorker.db);

    inModel.setStackIndex(0);

    // Show SnackBar.
    Scaffold.of(inContext).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        content: Text(
          "Appointment saved",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25, color: Colors.white),
        )));
  } /* End _save(). */
}
