import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants.dart';
import '../widgets/custom_elevated_button.dart';
import '../widgets/custom_text_form_field.dart';

class AdminPortalAccessDialog extends StatefulWidget {
  const AdminPortalAccessDialog({super.key});

  @override
  State<AdminPortalAccessDialog> createState() =>
      _AdminPortalAccessDialogState();
}

class _AdminPortalAccessDialogState extends State<AdminPortalAccessDialog> {
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0, top: 10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: .min,
            children: [
              ListTile(
                leading: Icon(Icons.lock),
                title: Text("Admin Portal"),
                subtitle: Text("Enter pin to continue"),
                trailing: IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: Navigator.of(context).pop,
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: _formKey,
                  child: CustomTextFormField(
                    hintText: "Admin PIN",
                    obscureText: _obscureText,
                    suffixIconData: Icons.remove_red_eye,
                    suffixIconOnTap: () =>
                        setState(() => _obscureText = !_obscureText),
                    controller: _controller,
                    maxLength: 4,
                    textInputType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validatorFunction: (value) {
                      if (value != adminPassword) {
                        return 'Invalid PIN';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              CustomElevatedButton(
                buttonText: "Enter",
                onPressed: () {
                  if (_formKey.currentState?.validate() == true) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed("/manage-students");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
