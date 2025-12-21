import 'package:flutter/material.dart';

class CustomLoginButton extends StatelessWidget {
  final Color buttonColor;
  final Widget buttonIcon;
  final String buttonText;
  final Color buttonTextColor;
  final void Function()? onTap;
  const CustomLoginButton({
    super.key,
    required this.buttonColor,
    required this.buttonIcon,
    required this.buttonText,
    required this.onTap,
    required this.buttonTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buttonIcon,
            const SizedBox(width: 12),
            Text(
              buttonText,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: buttonTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
