import 'package:flutter/material.dart';
import 'package:flutterbook/appointments/appointmentsEntry.dart';
import 'package:flutterbook/appointments/appointmentsList.dart';
import 'package:flutterbook/notes/notesModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'appointmentsDBWorker.dart';
import 'appointmentsModel.dart' show AppointmentsModel, appointmentsModel;

class Appointments extends StatelessWidget {

  Appointments() {
    notesModel.loadData('notes', AppointmentsDBWorker.db);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppointmentsModel>(
        model: appointmentsModel,
        child: ScopedModelDescendant<AppointmentsModel>(
            builder: (BuildContext context, Widget child, AppointmentsModel inModel) {
              return IndexedStack(
                  index: inModel.stackIndex,
                  children: [AppointmentsList(), AppointmentsEntry()]
              );
            }
        )
    );
  }
}
