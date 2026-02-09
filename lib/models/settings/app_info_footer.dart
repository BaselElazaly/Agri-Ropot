import 'package:flutter/material.dart';

class AppInfoFooter extends StatelessWidget {
  const AppInfoFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 377,
      height: 63,
      child: Text(
        'Agri Lens User Agreement and Statement About Agri Lens Privacy\n'
        'Agri Lens. All Rights Reserved. © 2024-2025',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          fontSize: 14,
          height: 1.2,
          color: Color(0xFF494949),
        ),
      ),
    );
  }
}
