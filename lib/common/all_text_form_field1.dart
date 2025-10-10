import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class AllTextFormField1 extends StatelessWidget {
  final TextEditingController? mController;
  final bool readOnly;
  final String? hintText;
  final TextInputType inputType;

  const AllTextFormField1({
    super.key,
    required this.readOnly,
    this.hintText,
    this.mController,
    required this.inputType,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4, // shadow
      borderRadius: BorderRadius.circular(6),
      child: TextFormField(
        keyboardType: inputType,
        readOnly: readOnly,
        controller: mController,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: EdgeInsets.only(left: 15.0),
          hintStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            color: Color(0xff454545),
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}

