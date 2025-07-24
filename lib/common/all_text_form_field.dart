import 'package:flutter/material.dart';

class AllTextFormField extends StatelessWidget {
  TextEditingController ?mController;
  bool readOnly;
  var hintText;
  final TextInputType inputType;
  AllTextFormField({super.key, required this.readOnly,this.hintText, this.mController,required this.inputType});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        elevation: 10,
        shadowColor: Colors.black.withOpacity(1.0),
        borderRadius: BorderRadius.circular(30),
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
