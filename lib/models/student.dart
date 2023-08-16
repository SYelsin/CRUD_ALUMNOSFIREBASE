import 'dart:convert';

class Student {
  Student(
      {required this.apellidos,
      required this.direccion,
      required this.edad,
      required this.estado,
      required this.nombre,
      required this.sexo,
      this.foto,
      this.id});

  String apellidos;
  String direccion;
  int edad;
  bool estado;
  String nombre;
  String sexo;
  String? foto;
  String? id;

  factory Student.fromJson(String str) => Student.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Student.fromMap(Map<String, dynamic> json) => Student(
        apellidos: json["apellidos"],
        direccion: json["direccion"],
        edad: json["edad"],
        estado: json["estado"],
        nombre: json["nombre"],
        sexo: json["sexo"],
        foto: json["foto"],
      );

  Map<String, dynamic> toMap() => {
        "apellidos": apellidos,
        "direccion": direccion,
        "edad": edad,
        "estado": estado,
        "nombre": nombre,
        "sexo": sexo,
        "foto": foto,
      };

  Student copy() => Student(
        apellidos: this.apellidos,
        direccion: this.direccion,
        edad: this.edad,
        estado: this.estado,
        nombre: this.nombre,
        sexo: this.sexo,
        foto: this.foto,
        id: this.id,
      );
}
