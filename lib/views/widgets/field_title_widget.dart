import 'package:flutter/material.dart';

class FieldTitleWidget extends StatelessWidget {
  final String fieldTitle;
  const FieldTitleWidget({
    super.key,
    required this.fieldTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        fieldTitle,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}