import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/student.dart';
import '../../models/student_document.dart';
import '../../view_models/database_view_model.dart';
import '../../view_models/google_auth_view_model.dart';
import '../widgets/custom_app_bar.dart';
import './quick_link_card.dart';
import './resource_card.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with WidgetsBindingObserver {
  Future<void> _checkStudentStatus() async {
    try {
      final databaseViewModel = Provider.of<DatabaseViewModel>(
        context,
        listen: false,
      );
      final authViewModel = Provider.of<GoogleAuthViewModel>(
        context,
        listen: false,
      );
      final email = authViewModel.currentUser?.email ?? "";
      final status = await databaseViewModel.checkStudentStatus(email);
      if (status != true) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              status == false
                  ? "Your account is inactive. Please contact admin."
                  : "Student profile not found. Please contact admin.",
            ),
          ),
        );
        await authViewModel.signOut();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkStudentStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkStudentStatus();
    }
  }

  Future<void> _signOut() async {
    try {
      await Provider.of<GoogleAuthViewModel>(context, listen: false).signOut();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    );
  }

  Future<void> _viewMyProfile() async {
    try {
      final authViewModel = Provider.of<GoogleAuthViewModel>(
        context,
        listen: false,
      );
      final databaseViewModel = Provider.of<DatabaseViewModel>(
        context,
        listen: false,
      );
      final email = authViewModel.currentUser?.email ?? "";
      final temp = await databaseViewModel.getStudentDetailsByEmail(email);
      databaseViewModel.setSelectedStudent(
        StudentDocument(docId: temp!.id, student: temp.data() as Student),
      );
      if (!mounted) return;
      Navigator.of(context).pushNamed("/my-profile");
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Student Dashboard"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _sectionTitle('Explore Free Resources'),
            const SizedBox(height: 12),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: const [
                ResourceCard(
                  icon: Icons.picture_as_pdf,
                  title: 'PDF Documents',
                  url:
                      "https://ontheline.trincoll.edu/images/bookdown/sample-local-pdf.pdf",
                ),
                ResourceCard(
                  icon: Icons.video_library,
                  title: 'Video Lectures',
                  url:
                      "https://file-examples.com/storage/fe9ac71cd36947f5692af78/2017/04/file_example_MP4_480_1_5MG.mp4",
                ),
                ResourceCard(
                  icon: Icons.slideshow,
                  title: 'PPT Presentations',
                  url:
                      "https://file-examples.com/wp-content/storage/2017/08/file_example_PPT_250kB.ppt",
                ),
                ResourceCard(
                  icon: Icons.play_circle_fill,
                  title: 'Learning Videos',
                  url:
                      "https://www.youtube.com/results?search_query=flutter+tutorial",
                ),
              ],
            ),

            const SizedBox(height: 24),
            _sectionTitle('Quick Links'),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: QuickLinkCard(
                    icon: Icons.person,
                    title: 'My Profile',
                    onTap: _viewMyProfile,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: QuickLinkCard(
                    icon: Icons.power_settings_new,
                    title: 'Logout',
                    onTap: _signOut,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
