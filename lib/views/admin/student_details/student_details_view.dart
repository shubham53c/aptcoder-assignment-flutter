import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../view_models/database_view_model.dart';
import './info_row.dart';

class StudentDetailsView extends StatefulWidget {
  final bool myProfile;
  const StudentDetailsView({super.key, this.myProfile = false});

  @override
  State<StudentDetailsView> createState() => _StudentDetailsViewState();
}

class _StudentDetailsViewState extends State<StudentDetailsView> {
  DatabaseViewModel? _viewModel;

  @override
  void dispose() {
    _viewModel?.setSelectedStudent(null);
    super.dispose();
  }

  static Widget _section({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = Provider.of<DatabaseViewModel>(context, listen: false);
    final viewModel = Provider.of<DatabaseViewModel>(context);
    final studentDoc = viewModel.studentDocument;
    final student = studentDoc?.student;
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.myProfile ? "My" : "Student"} Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(
                student?.name.isNotEmpty == true
                    ? student!.name[0].toUpperCase()
                    : '?',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${student?.name}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              '${student?.studentId}',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              '${student?.course} • ${student?.year}',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 24),

            // Contact Information
            _section(
              title: 'Contact Information',
              children: [
                InfoRow(icon: Icons.email, value: '${student?.email}'),
                InfoRow(icon: Icons.phone, value: '+91-${student?.mobile}'),
              ],
            ),

            // Academic Details
            _section(
              title: 'Academic Details',
              children: [
                InfoRow(
                  icon: Icons.school,
                  value: 'Course: ${student?.course}',
                ),
                InfoRow(
                  icon: Icons.book,
                  value: 'Department: ${student?.department}',
                ),
                InfoRow(
                  icon: Icons.calendar_today,
                  value: 'Enrollment Year: ${student?.enrollmentYear}',
                ),
                InfoRow(icon: Icons.star, value: 'CGPA: ${student?.cgpa}'),
              ],
            ),

            if (!widget.myProfile) ...[
              // Account Status Section
              _section(
                title: 'Account Status',
                children: [
                  Row(
                    children: [
                      Icon(
                        student?.isActive == true
                            ? Icons.verified
                            : Icons.block,
                        size: 18,
                        color: student?.isActive == true
                            ? Colors.green
                            : Colors.red,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          student?.isActive == true ? 'Active' : 'Inactive',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Switch(
                        value: student?.isActive ?? true,
                        onChanged: (value) async {
                          try {
                            final updatedAt = Timestamp.now();
                            final updatedStudent = student?.copyWith(
                              isActive: value,
                              updatedAt: updatedAt,
                            );
                            await viewModel.updateStudent(
                              studentDoc!.docId,
                              updatedStudent!,
                            );
                            if (!mounted) return;
                            setState(() {
                              student?.isActive = value;
                              student?.updatedAt = updatedAt;
                            });
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed("/edit-student"),
                  child: const Text('Edit Student'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
