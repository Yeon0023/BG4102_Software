import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class customAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double fontSize;
  final List<Widget>? actions;
  final Widget? leading;

  const customAppbar({
    super.key,
    required this.title,
    required this.fontSize,
    required this.actions,
    required this.leading,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.teal[900],
      ),
      elevation: 0,
      backgroundColor: Colors.teal[900],
      title: Text(title),
      titleTextStyle: GoogleFonts.lobster(fontSize: fontSize),
      centerTitle: true,
      leading: leading,
      actions: actions,
    );
  }
}
