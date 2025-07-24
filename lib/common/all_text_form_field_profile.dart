import 'package:flutter/material.dart';

class AllProfileTextFormField extends StatelessWidget {
  TextEditingController ?mController;
  var hintText;
  bool readOnly;
  AllProfileTextFormField({super.key, this.hintText, this.mController,required this.readOnly});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        elevation: 10,
        shadowColor: Colors.black.withOpacity(1.0),
        borderRadius: BorderRadius.circular(30),
        child: TextFormField(
          readOnly: readOnly,
          controller: mController,
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: EdgeInsets.only(left: 15.0),
            hintStyle: const TextStyle(
                fontFamily: 'Inter',
              fontSize: 18,
              color: Color(0xff454545),
              fontWeight: FontWeight.w400
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
