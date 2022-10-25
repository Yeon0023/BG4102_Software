import 'package:flutter/material.dart';

class ProfileEditInfo extends StatelessWidget {
  final String labeltext;
  final String labeltextpls;
  String title;
  Icon icon;

  ProfileEditInfo({
    Key? key,
    required this.labeltext,
    required this.labeltextpls,
    required this.title,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            prefixIcon:
            icon,
            hintStyle: TextStyle(color: Colors.white),
            errorStyle:
            TextStyle(color: Colors.redAccent),
            focusedBorder: OutlineInputBorder(
                borderSide:
                BorderSide(color: Colors.white)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                )),
            labelText: labeltext,
            labelStyle: TextStyle(color: Colors.white)),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return labeltextpls;
          }
          return null;
        },
        onChanged: (value) {
          title = value;
        }
        );
  }
}
