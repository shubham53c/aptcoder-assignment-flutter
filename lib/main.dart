import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './core/constants.dart';
import './di/auth_service.dart';
import './view_models/google_auth_view_model.dart';
import './firebase_options.dart';
import './views/default/default_view.dart';
import './views/admin/students_listing/students_listing_view.dart';
import './views/admin/student_details/student_details_view.dart';
import './views/admin/create_student/create_student_view.dart';
import './di/database_service.dart';
import './view_models/database_view_model.dart';

final _databaseEngine = DatabaseService();
final _authEngine = AuthService(_databaseEngine);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GoogleAuthViewModel(_authEngine)),
        ChangeNotifierProvider(
          create: (_) => DatabaseViewModel(_databaseEngine),
        ),
      ],
      child: MaterialApp(
        title: appName,
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.orange)),
        routes: {
          "/": (_) => const DefaultView(),
          "/manage-students": (_) => const StudentsListingView(),
          "/student-details": (_) => const StudentDetailsView(),
          "/create-student": (_) => const CreateStudentView(),
          "/edit-student": (_) => const CreateStudentView(edit: true),
          "/my-profile": (_) => const StudentDetailsView(myProfile: true),
        },
      ),
    );
  }
}
