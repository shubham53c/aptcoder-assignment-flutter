import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './field_title_widget.dart';
import './custom_text_form_field.dart';

class AppTextField extends StatelessWidget {
  final String fieldTitle;
  final String fieldHint;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? textInputType;
  final int? maxLength;
  final String? Function(String?)? validatorFunction;

  const AppTextField({
    super.key,
    this.controller,
    this.inputFormatters,
    this.textInputType,
    this.maxLength,
    this.validatorFunction,
    required this.fieldTitle,
    required this.fieldHint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldTitleWidget(fieldTitle: fieldTitle),
        const SizedBox(height: 10.0),
        CustomTextFormField(
          hintText: fieldHint,
          controller: controller,
          inputFormatters: inputFormatters,
          textInputType: textInputType,
          maxLength: maxLength,
          validatorFunction: validatorFunction,
        ),
      ],
    );
  }
}
