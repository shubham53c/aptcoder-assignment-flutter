import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../di/database_service.dart';
import '../models/student.dart';
import '../models/student_document.dart';

class DatabaseViewModel with ChangeNotifier {
  late final DatabaseService _databaseService;

  StudentDocument? _studentDocument;

  DatabaseViewModel(this._databaseService);

  Stream<QuerySnapshot> get getStudents => _databaseService.getStudents;

  StudentDocument? get studentDocument => _studentDocument;

  void setSelectedStudent(
    StudentDocument? studentDocument, [
    bool refresh = false,
  ]) {
    _studentDocument = studentDocument;
    if (refresh) notifyListeners();
  }

  Future<void> updateStudent(String studentDocId, Student student) async {
    try {
      await _databaseService.updateStudent(studentDocId, student);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> createStudent(Student student) async {
    try {
      final res = await checkStudentStatus(student.email);
      if (res != null) throw Exception("Email already registered!");
      await _databaseService.createStudent(student);
    } catch (_) {
      rethrow;
    }
  }

  Future<QueryDocumentSnapshot<Object?>?> getStudentDetailsByEmail(String email) async {
    try {
      return await _databaseService.getStudentDetailsByEmail(email);
    } catch (_) {
      rethrow;
    }
  }

  Future<bool?> checkStudentStatus(String email) async {
    try {
      return await _databaseService.checkStudentStatus(email);
    } catch (_) {
      rethrow;
    }
  }
}
