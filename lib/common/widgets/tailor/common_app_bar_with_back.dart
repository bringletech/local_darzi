import 'package:flutter/material.dart';

class CustomAppBarWithBack extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final Widget? leadingIcon;
  final Color? color;
  final double height;
  final bool hasBackButton;
  final VoidCallback? onBackButtonPressed;
  final double elevation;

  CustomAppBarWithBack({
    Key? key,
    required this.title,
    this.subtitle,
    this.leadingIcon,
    this.color,
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SafeArea(
          child: Row(
            children: [
              if (hasBackButton)
                GestureDetector(
                  onTap: onBackButtonPressed,
                  child: Container(
                    padding: EdgeInsets.only(left: 4),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 1, color: Colors.black),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      size: 14.0,
                    ),
                  ),
                ),
              const Spacer(), // Back button left align aur title center maintain karega
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leadingIcon != null) leadingIcon!,
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const Spacer(), // Equal spacing maintain karega
            ],
          ),
        ),
      ),
    );
  }
}
