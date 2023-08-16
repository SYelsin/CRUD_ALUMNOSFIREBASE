import 'package:flutter/material.dart';
import 'package:alumnos/models/models.dart';

class StudentCard extends StatelessWidget {
  final Student student;

  const StudentCard({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 20),
        width: double.infinity,
        height: 180,
        decoration: _cardBorders(),
        child: Row(
          children: [
            _ProfileImage(student.foto),
            SizedBox(width: 10),
            Expanded(
              child: _StudentDetails(
                title: student.nombre,
                direccion: student.direccion,
                age: student.edad,
                available: student.estado,
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardBorders() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      );
}

class _StudentDetails extends StatelessWidget {
  final String title;
  final String direccion;
  final int age;
  final bool available;

  const _StudentDetails({
    required this.title,
    required this.direccion,
    required this.age,
    required this.available,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: _buildBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            direccion,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          SizedBox(height: 5),
          Text(
            '$age años',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          SizedBox(height: 10),
          Center(
            child: _AvailabilityTag(available: available),
          ),
        ],
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      );
}

class _AvailabilityTag extends StatelessWidget {
  final bool available;

  const _AvailabilityTag({required this.available});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: available ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        available ? 'Activo' : 'Inactivo',
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ProfileImage extends StatelessWidget {
  final String? url;

  const _ProfileImage(this.url);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      margin: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[300],
      ),
      child: url == null
          ? Icon(Icons.person, size: 60, color: Colors.grey[600])
          : ClipOval(
              child: Image.network(
                url!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
    );
  }
}
