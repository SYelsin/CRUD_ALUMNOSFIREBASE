import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:alumnos/models/models.dart';
import 'package:alumnos/screens/screens.dart';

import 'package:alumnos/services/services.dart';
import 'package:alumnos/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<StudentsService>(context);

    if (productsService.isLoading) return LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: Text('Alumnos'),
      ),
      body: ListView.builder(
          itemCount: productsService.student.length,
          itemBuilder: (BuildContext context, int index) => GestureDetector(
                onTap: () {
                  productsService.selectedStudent =
                      productsService.student[index].copy();
                  Navigator.pushNamed(context, 'product');
                },
                child: StudentCard(
                  student: productsService.student[index],
                ),
              )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          productsService.selectedStudent = new Student(
              estado: false,
              apellidos: '',
              direccion: '',
              sexo: '',
              nombre: '',
              edad: 0);
          Navigator.pushNamed(context, 'product');
        },
      ),
    );
  }
}
