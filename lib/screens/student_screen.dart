import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:alumnos/providers/student_form_provider.dart';
import 'package:alumnos/services/students_service.dart';
import 'package:alumnos/ui/input_decorations.dart';
import 'package:alumnos/widgets/widgets.dart';

class StudentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final studentsService = Provider.of<StudentsService>(context);

    return ChangeNotifierProvider(
      create: (_) => StudentFormProvider(studentsService.selectedStudent),
      child: _StudentScreenBody(studentsService: studentsService),
    );
  }
}

class _StudentScreenBody extends StatelessWidget {
  const _StudentScreenBody({
    Key? key,
    required this.studentsService,
  }) : super(key: key);

  final StudentsService studentsService;

  @override
  Widget build(BuildContext context) {
    final studentForm = Provider.of<StudentFormProvider>(context);
    final student = studentForm.student;
    return Scaffold(
      appBar: AppBar(
        title:
            Text(student.id == null ? 'Nuevo Estudiante' : 'Editar Estudiante'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 5,
              margin: EdgeInsets.all(15),
              child: Column(
                children: [
                  Stack(
                    children: [
                      ProductImage(url: studentsService.selectedStudent.foto),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: InkWell(
                          onTap: () async {
                            final picker = new ImagePicker();
                            final PickedFile? pickedFile =
                                await picker.getImage(
                                    source: ImageSource.gallery,
                                    //source: ImageSource.camera,
                                    imageQuality: 100);
                            print(pickedFile);

                            if (pickedFile == null) {
                              print('No seleccionó nada');
                              return;
                            }

                            studentsService
                                .updateSelectedStudentImage(pickedFile.path);
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.indigo,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.camera_alt_outlined,
                                size: 28, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  _StudentForm(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (student.id != null)
                        ElevatedButton(
                          onPressed: studentsService.isSaving
                              ? null
                              : () async {
                                  try {
                                    await studentsService
                                        .deleteStudent(studentForm.student);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Estudiante eliminado exitosamente.'),
                                      ),
                                    );

                                    Navigator.pop(
                                        context); // Volver a la página anterior
                                  } catch (error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Error al eliminar estudiante.'),
                                      ),
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            primary: Colors
                                .red, // Color rojo para indicar eliminación
                          ),
                          child: Text('Eliminar'),
                        ),
                      SizedBox(width: 15),
                      FloatingActionButton(
                        onPressed: studentsService.isSaving
                            ? null
                            : () async {
                                if (!studentForm.isValidForm()) return;

                                final String? imageUrl =
                                    await studentsService.uploadImage();

                                if (imageUrl != null) {
                                  studentForm.student.foto = imageUrl;
                                }

                                await studentsService
                                    .saveOrCreateProduct(studentForm.student);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Estudiante ${studentForm.student.id != null ? 'actualizado' : 'creado'} exitosamente.',
                                    ),
                                  ),
                                );

                                Navigator.pop(context);
                              },
                        child: studentsService.isSaving
                            ? CircularProgressIndicator(color: Colors.white)
                            : Icon(Icons.send),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _StudentForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final studentForm = Provider.of<StudentFormProvider>(context);
    final student = studentForm.student;

    return Padding(
      padding: EdgeInsets.all(15),
      child: Form(
        key: studentForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              initialValue: student.nombre,
              onChanged: (value) => student.nombre = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El nombre es obligatorio';
                }
                return null;
              },
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Nombre del estudiante',
                labelText: 'Nombre:',
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              initialValue: student.apellidos,
              onChanged: (value) => student.apellidos = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Los apellidos son obligatorios';
                }
                return null;
              },
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Apellidos del estudiante',
                labelText: 'Apellidos:',
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              initialValue: student.direccion,
              onChanged: (value) => student.direccion = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'La dirección es obligatoria';
                }
                return null;
              },
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Dirección del estudiante',
                labelText: 'Dirección:',
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              initialValue: '${student.edad}',
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              onChanged: (value) => student.edad = int.tryParse(value) ?? 0,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Edad del estudiante',
                labelText: 'Edad:',
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: student.id == null ? 'Seleccionar' : student.sexo,
              onChanged: (value) {
                if (value != 'Seleccionar') {
                  student.sexo = value!;
                }
              },
              items: ['Seleccionar', 'Masculino', 'Femenino']
                  .map((sexo) => DropdownMenuItem(
                        value: sexo,
                        child: Text(sexo),
                      ))
                  .toList(),
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Sexo del estudiante',
                labelText: 'Sexo:',
              ),
              validator: (value) {
                if (value == 'Seleccionar') {
                  return 'Por favor, selecciona un sexo';
                }
                return null; // Retorna null si la validación es exitosa
              },
            ),
            SizedBox(height: 20),
            SwitchListTile.adaptive(
              value: student.estado,
              title: Text('Activo'),
              activeColor: Colors.indigo,
              onChanged: studentForm.updateAvailability,
            ),
          ],
        ),
      ),
    );
  }
}
