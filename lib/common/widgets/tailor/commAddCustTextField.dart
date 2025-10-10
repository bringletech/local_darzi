import 'package:flutter/material.dart';

class Commonaddcusttextfield extends StatelessWidget {
  final String hintText;
  final String text;
  final TextEditingController controller;
  final TextInputType inputType;
  const Commonaddcusttextfield({super.key, required this.text, required this.hintText, required this.controller,required this.inputType});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            width: 70,
            child: Text(
              text,
              style: TextStyle(fontSize: 14,fontFamily: 'Poppins', fontWeight: FontWeight.w600),
            ),
          ),
          //SizedBox(width: 70,),
          Container(
            width: 250,
            //padding: EdgeInsets.only(left:10,right: 10),
            child: Material(
              elevation: 10,
              shadowColor: Colors.black.withOpacity(1.0),
              borderRadius: BorderRadius.circular(30),
              child: TextField(
                keyboardType: inputType,
                controller: controller,
                decoration: InputDecoration(
                    hintText: hintText,
                    contentPadding: EdgeInsets.only(right: 160.0),
                    hintStyle: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: Color(0xffA9A9A9),
                        fontWeight: FontWeight.w400
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none
                    ),
                    filled: true,
                    fillColor: Colors.white
                  //border: UnderlineInputBorder(),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}