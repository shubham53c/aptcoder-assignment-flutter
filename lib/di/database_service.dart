import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/student.dart';

const _studentCollectionRef = "students";

class DatabaseService {
  final _firebaseFirestore = FirebaseFirestore.instance;
  late final CollectionReference _studentsRef;

  DatabaseService() {
    _studentsRef = _firebaseFirestore
        .collection(_studentCollectionRef)
        .withConverter<Student>(
          fromFirestore: (snapshot, _) => Student.fromJson(snapshot.data()!),
          toFirestore: (student, _) => student.toJson(),
        );
  }

  Stream<QuerySnapshot> get getStudents => _studentsRef.snapshots();

  Future<void> createStudent(Student student) async {
    try {
      await _studentsRef.add(student);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> updateStudent(String studentDocId, Student student) async {
    try {
      await _studentsRef.doc(studentDocId).update(student.toJson());
    } catch (_) {
      rethrow;
    }
  }

  Future<QueryDocumentSnapshot<Object?>?> getStudentDetailsByEmail(
    String email,
  ) async {
    try {
      final snapshot = await _studentsRef
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      if (snapshot.docs.isEmpty) {
        return null;
      }
      return snapshot.docs.first;
    } catch (_) {
      rethrow;
    }
  }

  Future<bool?> checkStudentStatus(String email) async {
    try {
      final snapshot = await _studentsRef
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      if (snapshot.docs.isEmpty) {
        return null;
      }
      return snapshot.docs.first['is_active'] == true;
    } catch (_) {
      rethrow;
    }
  }
}
