import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final IconData? prefixIconData;
  final IconData? suffixIconData;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final bool readOnly;
  final String? Function(String?)? validatorFunction;
  final TextInputType? textInputType;
  final Function()? suffixIconOnTap;
  final void Function(String)? onChanged;
  final int? maxLength;
  final String? labelText;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.controller,
    this.prefixIconData,
    this.suffixIconData,
    this.obscureText = false,
    this.readOnly = false,
    this.suffixIconOnTap,
    this.textInputType,
    this.validatorFunction,
    this.onChanged,
    this.inputFormatters,
    this.maxLength,
    this.labelText,
  });

  OutlineInputBorder textFieldBorderDecoration([bool focusedBorder = false]) {
    final textFieldDecoration = BoxDecoration(
      border: Border.fromBorderSide(
        BorderSide(color: Colors.black.withValues(alpha: 0.45), width: 1.15),
      ),
      borderRadius: const BorderRadius.all(Radius.circular(15.0)),
    );
    return OutlineInputBorder(
      borderSide: textFieldDecoration.border!.top.copyWith(
        color: focusedBorder
            ? Colors.black
            : textFieldDecoration.border!.top.color,
      ),
      borderRadius: textFieldDecoration.borderRadius as BorderRadius,
    );
  }

  @override
  Widget build(BuildContext context) {
    final borderDecoration = textFieldBorderDecoration();
    return TextFormField(
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: primaryColor,
      obscureText: obscureText,
      onChanged: onChanged,
      keyboardType: textInputType,
      validator: validatorFunction,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      readOnly: readOnly,
      decoration: InputDecoration(
        hintStyle: TextStyle(color: Theme.of(context).hintColor),
        enabledBorder: borderDecoration,
        border: borderDecoration,
        focusedBorder: textFieldBorderDecoration(true),
        prefixIcon: prefixIconData == null
            ? null
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Icon(prefixIconData),
              ),
        suffixIcon: suffixIconData == null
            ? null
            : InkWell(
                onTap: suffixIconOnTap ?? () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Icon(
                    suffixIconData,
                    color: obscureText ? null : primaryColor,
                  ),
                ),
              ),
        hintText: hintText,
        labelText: labelText,
      ),
    );
  }
}
