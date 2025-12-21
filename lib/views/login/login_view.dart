import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../view_models/google_auth_view_model.dart';
import '../admin/admin_portal_access_dialog.dart';
import './custom_login_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  Future<void> _googleSignInFlow() async {
    try {
      await Provider.of<GoogleAuthViewModel>(context, listen: false).signIn();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<GoogleAuthViewModel>(context);
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Image.asset("assets/login_page_asset.png", fit: BoxFit.cover),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 30.0,
                  horizontal: 20.0,
                ),
                child: Column(
                  children: [
                    if (viewModel.supportsAuthenticate)
                      CustomLoginButton(
                        buttonTextColor: Colors.black87,
                        buttonColor: Colors.white,
                        buttonIcon: Image.asset(
                          'assets/google_logo.png',
                          height: 24,
                        ),
                        buttonText: 'Student Login',
                        onTap: _googleSignInFlow,
                      ),
                    const SizedBox(height: 20),
                    CustomLoginButton(
                      buttonTextColor: Colors.white,
                      buttonColor: primaryColor,
                      buttonIcon: Icon(Icons.lock_outline, color: Colors.white),
                      buttonText: 'Admin Portal',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => const AdminPortalAccessDialog(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
