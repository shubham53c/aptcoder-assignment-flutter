import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_models/google_auth_view_model.dart';
import '../dashboard/dashboard.dart';
import '../login/login_view.dart';

class DefaultView extends StatefulWidget {
  const DefaultView({super.key});

  @override
  State<DefaultView> createState() => _DefaultViewState();
}

class _DefaultViewState extends State<DefaultView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      try {
        if (!mounted) return;
        await Provider.of<GoogleAuthViewModel>(
          context,
          listen: false,
        ).signInInit();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<GoogleAuthViewModel>(context);
    return StreamBuilder<User?>(
      stream: viewModel.userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Material(
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final User? user = snapshot.data;
        if (user != null) {
          return const Dashboard();
        }
        return const LoginView();
      },
    );
  }
}
