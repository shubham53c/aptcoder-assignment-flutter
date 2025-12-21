import 'package:flutter/material.dart';

import '../../core/constants.dart';

class CustomElevatedButton extends StatelessWidget {
  final String buttonText;
  final bool isLoading;
  final void Function()? onPressed;
  const CustomElevatedButton({
    super.key,
    required this.buttonText,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: 30.0,
          vertical: 10.0,
        ),
        foregroundColor: Colors.white,
        backgroundColor: primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
        ),
      ),
      onPressed: isLoading ? () {} : onPressed,
      child: Text(buttonText),
    );
  }
}