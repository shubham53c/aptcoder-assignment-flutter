import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/student_document.dart';
import '../../../view_models/database_view_model.dart';

class StudentListItem extends StatelessWidget {
  final StudentDocument studentDocument;

  const StudentListItem({super.key, required this.studentDocument});

  @override
  Widget build(BuildContext context) {
    final student = studentDocument.student;
    return InkWell(
      onTap: () {
        final viewModel = Provider.of<DatabaseViewModel>(
          context,
          listen: false,
        );
        viewModel.setSelectedStudent(studentDocument);
        Navigator.of(context).pushNamed("/student-details");
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            CircleAvatar(
              radius: 22,
              child: Text(
                student.name.isNotEmpty ? student.name[0].toUpperCase() : '?',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),

            // Student Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ID: ${student.studentId} • ${student.year}',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    student.email,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            // Arrow
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
