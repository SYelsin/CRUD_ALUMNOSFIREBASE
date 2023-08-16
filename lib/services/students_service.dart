import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:alumnos/models/models.dart';
import 'package:http/http.dart' as http;

class StudentsService extends ChangeNotifier {
  final String _baseUrl = 'alumnos-16b81-default-rtdb.firebaseio.com';
  final List<Student> student = [];
  late Student selectedStudent;

  File? newPictureFile;

  bool isLoading = true;
  bool isSaving = false;
  bool isNew = false;

  StudentsService() {
    this.loadProducts();
  }

  Future<List<Student>> loadProducts() async {
    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'alumnos.json');
    final resp = await http.get(url);

    final Map<String, dynamic> productsMap = json.decode(resp.body);

    productsMap.forEach((key, value) {
      final tempProduct = Student.fromMap(value);
      tempProduct.id = key;
      this.student.add(tempProduct);
    });

    this.isLoading = false;
    isNew = false;
    notifyListeners();

    return this.student;
  }

  Future saveOrCreateProduct(Student student) async {
    isSaving = true;
    notifyListeners();

    if (student.id == null) {
      // Es necesario crear
      await this.createProduct(student);
    } else {
      // Actualizar
      await this.updateProduct(student);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Student student) async {
    final url = Uri.https(_baseUrl, 'alumnos/${student.id}.json');
    final resp = await http.put(url, body: student.toJson());
    final decodedData = resp.body;

    //TODO: Actualizar el listado de productos
    final index =
        this.student.indexWhere((element) => element.id == student.id);
    this.student[index] = student;

    return student.id!;
  }

  Future<String> createProduct(Student student) async {
    final url = Uri.https(_baseUrl, 'alumnos.json');
    final resp = await http.post(url, body: student.toJson());
    final decodedData = json.decode(resp.body);

    student.id = decodedData['name'];

    this.student.add(student);

    return student.id!;
  }

  Future<void> deleteStudent(Student student) async {
    final url = Uri.https(_baseUrl, 'alumnos/${student.id}.json');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        // Elimina el estudiante del listado local en el servicio
        this.student.removeWhere(
            (s) => s.id == student.id); // Cambio en la variable local
      } else {
        throw Exception('Error al eliminar estudiante');
      }
    } catch (error) {
      throw Exception('Error al eliminar estudiante: $error');
    }
  }

  void updateSelectedStudentImage(String path) {
    this.selectedStudent.foto = path;
    this.newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (this.newPictureFile == null) return null;

    this.isSaving = true;
    notifyListeners();

    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/drzs5gcqs/image/upload?upload_preset=zafmxljx');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('algo salio mal');
      print(resp.body);
      return null;
    }

    this.newPictureFile = null;

    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];
  }
}
