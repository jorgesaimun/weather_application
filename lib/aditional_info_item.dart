import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AditionalInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String info;
  const AditionalInfoItem({
    super.key,
    required this.icon,
    required this.label,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 32,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(label),
        const SizedBox(
          height: 8,
        ),
        Text(
          info,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
