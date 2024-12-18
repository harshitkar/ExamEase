import 'package:flutter/material.dart';

class OptionTile extends StatelessWidget {
  final String optionText;

  OptionTile({required this.optionText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
        ),
        child: Text(
          optionText,
          style: const TextStyle(
            color: Color(0xFF0A1D37),
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}