import 'package:flutter/material.dart';

import '../../core/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? actionButton;
  final bool showMenuIcon;
  final String? title;
  const CustomAppBar({
    super.key,
    this.title,
    this.actionButton,
    this.showMenuIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      foregroundColor: Colors.white,
      backgroundColor: primaryColor,
      title: Text(
        title ?? appName,
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      leading: showMenuIcon
          ? IconButton(onPressed: () {}, icon: Icon(Icons.menu))
          : null,
      actions: actionButton != null ? [actionButton!] : null,
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
