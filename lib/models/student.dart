import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  String name;
  String studentId;
  String course;
  String year;
  String email;
  String mobile;
  String department;
  int enrollmentYear;
  double cgpa;
  bool isActive;
  Timestamp createdAt;
  Timestamp updatedAt;

  Student({
    required this.name,
    required this.studentId,
    required this.course,
    required this.year,
    required this.email,
    required this.mobile,
    required this.department,
    required this.enrollmentYear,
    required this.cgpa,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  Student.fromJson(Map<String, Object?> json)
    : this(
        name: json['name']! as String,
        studentId: json['student_id']! as String,
        course: json['course']! as String,
        year: json['year']! as String,
        email: json['email']! as String,
        mobile: json['mobile_no']! as String,
        department: json['department']! as String,
        enrollmentYear: json['enrollment_year']! as int,
        cgpa: json['cgpa']! as double,
        isActive: json['is_active']! as bool,
        createdAt: json['created_at']! as Timestamp,
        updatedAt: json['updated_at']! as Timestamp,
      );

  Student copyWith({
    String? name,
    String? studentId,
    String? course,
    String? year,
    String? email,
    String? mobile,
    String? department,
    int? enrollmentYear,
    double? cgpa,
    bool? isActive,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return Student(
      name: name ?? this.name,
      studentId: studentId ?? this.studentId,
      course: course ?? this.course,
      year: year ?? this.year,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      department: department ?? this.department,
      enrollmentYear: enrollmentYear ?? this.enrollmentYear,
      cgpa: cgpa ?? this.cgpa,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, Object?> toJson() {
    return {
      "name": name,
      "student_id": studentId,
      "course": course,
      "year": year,
      "email": email,
      "mobile_no": mobile,
      "department": department,
      "enrollment_year": enrollmentYear,
      "cgpa": cgpa,
      "is_active": isActive,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }
}
