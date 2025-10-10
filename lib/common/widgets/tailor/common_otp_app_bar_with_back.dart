import 'package:darzi/colors.dart';
import 'package:flutter/material.dart';

class CustomOtpAppBarWithBack extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color color;
  final String? subtitle;
  final Widget? leadingIcon;
  final double height;
  final bool hasBackButton;
  final VoidCallback? onBackButtonPressed;
  final double elevation;

  const CustomOtpAppBarWithBack({
    super.key,
    required this.title,
    required this.color,
    this.subtitle,
    this.leadingIcon,
    this.height = 120.0,
    this.hasBackButton = false,
    this.onBackButtonPressed,
    this.elevation = 4.0,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.newUpdateColor,
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SafeArea(
          child: Stack(
            children: [
              if (hasBackButton)
              Positioned(
                  top: 0,
                  left: 0,
                  child:GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 1, color: Colors.black),
                      ),
                      child:  Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 12.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (leadingIcon != null) leadingIcon!,
                      const SizedBox(width: 8),
                      Text(
                        title,
                        style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w400,fontSize: 24,color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

