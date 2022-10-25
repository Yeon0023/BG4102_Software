import 'package:flutter/material.dart';

class ProfileInfo extends StatelessWidget {
  final String info;
  final String title;

  const ProfileInfo({
    Key? key,
    required this.info,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            info,
            style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Open Sans',
                color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
                fontSize: 16,
                height: 1.4,
                fontWeight: FontWeight.bold,
                fontFamily: 'Open Sans'),
          ),
        ],
      ),
    );
  }
}
