import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../models/student.dart';
import '../../../models/student_document.dart';
import '../../../view_models/database_view_model.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/custom_app_bar.dart';

const _invalidInputMsg = "Please enter valid input";

class CreateStudentView extends StatefulWidget {
  final bool edit;
  const CreateStudentView({super.key, this.edit = false});

  @override
  State<CreateStudentView> createState() => _CreateStudentViewState();
}

class _CreateStudentViewState extends State<CreateStudentView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _courseController = TextEditingController();
  final _yearController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileNoController = TextEditingController();
  final _departmentController = TextEditingController();
  final _enrollmentYearController = TextEditingController();
  final _cgpaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _editFormSetup();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _studentIdController.dispose();
    _courseController.dispose();
    _yearController.dispose();
    _emailController.dispose();
    _mobileNoController.dispose();
    _departmentController.dispose();
    _enrollmentYearController.dispose();
    _cgpaController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    try {
      if (_formKey.currentState?.validate() == true) {
        final viewModel = Provider.of<DatabaseViewModel>(
          context,
          listen: false,
        );
        final selectedStudent = viewModel.studentDocument;
        final student = selectedStudent?.student;
        final timestampNow = Timestamp.now();
        final payload = Student(
          name: _nameController.text.trim(),
          studentId: _studentIdController.text.trim(),
          course: _courseController.text.trim(),
          year: _yearController.text.trim(),
          email: _emailController.text.trim(),
          mobile: _mobileNoController.text.trim(),
          department: _departmentController.text.trim(),
          enrollmentYear: int.parse(_enrollmentYearController.text.trim()),
          cgpa: double.parse(_cgpaController.text.trim()),
          isActive: widget.edit ? student!.isActive : true,
          createdAt: widget.edit ? student!.createdAt : timestampNow,
          updatedAt: timestampNow,
        );
        if (widget.edit) {
          await viewModel.updateStudent(selectedStudent!.docId, payload);
        } else {
          await viewModel.createStudent(payload);
        }
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Profile ${widget.edit ? "updation" : "creation"} successful!!",
            ),
          ),
        );
        Navigator.of(context).pop();
        if (widget.edit) {
          viewModel.setSelectedStudent(
            StudentDocument(docId: selectedStudent!.docId, student: payload),
            true,
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _editFormSetup() {
    if (!widget.edit) return;
    final viewModel = Provider.of<DatabaseViewModel>(context, listen: false);
    final selectedStudent = viewModel.studentDocument;
    final student = selectedStudent?.student;
    if (student == null || !mounted) return;
    setState(() {
      _nameController.text = student.name;
      _studentIdController.text = student.studentId;
      _courseController.text = student.course;
      _yearController.text = student.year;
      _emailController.text = student.email;
      _mobileNoController.text = student.mobile;
      _departmentController.text = student.department;
      _enrollmentYearController.text = student.enrollmentYear.toString();
      _cgpaController.text = student.cgpa.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.edit ? "Edit Student" : "Create Student",
        showMenuIcon: false,
        actionButton: TextButton.icon(
          onPressed: _submitForm,
          label: Text("Save", style: TextStyle(color: Colors.white)),
          icon: Icon(Icons.save, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 22.0,
              children: [
                AppTextField(
                  controller: _nameController,
                  fieldTitle: "Name*",
                  fieldHint: "Full name",
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                  ],
                  validatorFunction: (val) {
                    if (val?.trim().isNotEmpty == true) {
                      return null;
                    }
                    return _invalidInputMsg;
                  },
                ),
                AppTextField(
                  controller: _studentIdController,
                  fieldTitle: "Student ID*",
                  fieldHint: "MCA30091234",
                  validatorFunction: (val) {
                    if (val?.trim().isNotEmpty == true) {
                      return null;
                    }
                    return _invalidInputMsg;
                  },
                ),
                AppTextField(
                  controller: _courseController,
                  fieldTitle: "Course*",
                  fieldHint: "MCA",
                  validatorFunction: (val) {
                    if (val?.trim().isNotEmpty == true) {
                      return null;
                    }
                    return _invalidInputMsg;
                  },
                ),
                AppTextField(
                  controller: _yearController,
                  fieldTitle: "Year*",
                  fieldHint: "2nd Year",
                  validatorFunction: (val) {
                    if (val?.trim().isNotEmpty == true) {
                      return null;
                    }
                    return _invalidInputMsg;
                  },
                ),
                AppTextField(
                  controller: _emailController,
                  fieldTitle: "Email*",
                  fieldHint: "student@example.com",
                  validatorFunction: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return _invalidInputMsg;
                    }
                    final emailRegex = RegExp(
                      r'^[\w\.-]+@([\w-]+\.)+[a-zA-Z]{2,}$',
                    );
                    if (!emailRegex.hasMatch(val.trim())) {
                      return _invalidInputMsg;
                    }
                    return null;
                  },
                ),
                AppTextField(
                  controller: _mobileNoController,
                  fieldTitle: "Mobile No.*",
                  fieldHint: "0223234567",
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 10,
                  validatorFunction: (val) {
                    if (val?.trim().length == 10) {
                      return null;
                    }
                    return _invalidInputMsg;
                  },
                ),
                AppTextField(
                  controller: _departmentController,
                  fieldTitle: "Department*",
                  fieldHint: "Computer Applications",
                  validatorFunction: (val) {
                    if (val?.trim().isNotEmpty == true) {
                      return null;
                    }
                    return _invalidInputMsg;
                  },
                ),
                AppTextField(
                  controller: _enrollmentYearController,
                  fieldTitle: "Enrollment Year*",
                  fieldHint: "2019",
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validatorFunction: (val) {
                    if (val?.trim().isNotEmpty == true) {
                      return null;
                    }
                    return _invalidInputMsg;
                  },
                ),
                AppTextField(
                  controller: _cgpaController,
                  fieldTitle: "CGPA*",
                  fieldHint: "0.0",
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d{0,1}$'),
                    ),
                  ],
                  validatorFunction: (val) {
                    if (val?.trim().isNotEmpty == true) {
                      return null;
                    }
                    return _invalidInputMsg;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
