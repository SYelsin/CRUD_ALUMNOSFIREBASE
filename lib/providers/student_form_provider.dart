import 'package:flutter/material.dart';
import 'package:alumnos/models/models.dart';

class StudentFormProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  Student student;

  StudentFormProvider( this.student );

  updateAvailability( bool value ) {
    print(value);
    this.student.estado = value;
    notifyListeners();
  }


  bool isValidForm() {

    print( student.nombre );
    print( student.apellidos);
    print( student.estado );

    return formKey.currentState?.validate() ?? false;
  }

}