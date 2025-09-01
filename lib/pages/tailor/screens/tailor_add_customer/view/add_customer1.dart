import 'package:flutter/material.dart';

class MeasurementField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType inputType;

  const MeasurementField({
    super.key,
    required this.label,
    required this.controller,
    required this.inputType,
  });

  @override
  State<MeasurementField> createState() => _MeasurementFieldState();
}

class _MeasurementFieldState extends State<MeasurementField> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 70, // Label ka fixed width
          child: Text(
            widget.label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(width: 6),
        Expanded( // 👈 yaha Flexible + SizedBox(width:100) ki jagah Expanded use kiya
          child: Material(
            elevation: 2, // shadow
            borderRadius: BorderRadius.circular(6),
            child: TextField(
              controller: widget.controller,
              keyboardType: widget.inputType,
              decoration: InputDecoration(
                hintText: "0",
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
