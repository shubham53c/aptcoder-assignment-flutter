import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants.dart';
import '../../../models/student.dart';
import '../../../models/student_document.dart';
import '../../../view_models/database_view_model.dart';
import '../../widgets/custom_app_bar.dart';
import './student_list_item.dart';

class StudentsListingView extends StatefulWidget {
  const StudentsListingView({super.key});

  @override
  State<StudentsListingView> createState() => _StudentsListingViewState();
}

class _StudentsListingViewState extends State<StudentsListingView> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<DatabaseViewModel>(context, listen: false);
    return Scaffold(
      backgroundColor: bgColor,
      appBar: CustomAppBar(
        title: "Manage students",
        showMenuIcon: false,
        actionButton: TextButton.icon(
          onPressed: () {
            Navigator.of(context).pushNamed("/create-student");
          },
          label: Text("Create", style: TextStyle(color: Colors.white)),
          icon: Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: StreamBuilder(
        stream: viewModel.getStudents,
        builder: (context, snapshot) {
          final students = snapshot.data?.docs ?? [];
          if (snapshot.connectionState == .waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (students.isEmpty) {
            return const Center(child: Text("No data available"));
          }
          return ListView.separated(
            itemBuilder: (ctx, i) {
              final student = students[i].data() as Student;
              final studentDocId = students[i].id;
              return StudentListItem(
                studentDocument: StudentDocument(
                  docId: studentDocId,
                  student: student,
                ),
              );
            },
            separatorBuilder: (ctx, i) => Divider(),
            itemCount: students.length,
          );
        },
      ),
    );
  }
}
