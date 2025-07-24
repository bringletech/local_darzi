import 'package:darzi/common/widgets/customer/common_text_Field/commont_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBarCustomerWithOutBack extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final Widget? leadingIcon;
  final double height;
  final bool hasBackButton;
  final VoidCallback? onBackButtonPressed;
  final double elevation;

  const CustomAppBarCustomerWithOutBack({
    Key? key,
    required this.title,
    this.subtitle,
    this.leadingIcon,
    this.height = 120.0,
    this.hasBackButton = false,
    this.onBackButtonPressed,
    this.elevation = 4.0,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: elevation / 2,
            blurRadius: elevation,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end, // Align items to the bottom
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 40,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (leadingIcon != null) leadingIcon!,
                            const SizedBox(width: 8),
                            Text(
                              title,
                              style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w400,fontSize: 24,),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        // Place the filter icon next to the text


                      ],
                    ),
                    SizedBox(height: 20,)
                  ],
                ),
              ),],
          ),
        ),
      ),

    );
  }
}

