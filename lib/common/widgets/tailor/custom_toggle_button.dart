import 'package:darzi/colors.dart';
import 'package:flutter/material.dart';

class AnimatedSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color enabledTrackColor;
  AnimatedSwitch({required this.value,required this.enabledTrackColor,required this.onChanged});

  @override
  _AnimatedSwitchState createState() => _AnimatedSwitchState();
}

class _AnimatedSwitchState extends State<AnimatedSwitch> {
  late bool isEnabled;
  final animationDuration = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    isEnabled = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isEnabled = !isEnabled;
          widget.onChanged(isEnabled);
        });
      },
      child: AnimatedContainer(
        height: 20,
        width: 45,
        duration: animationDuration,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: isEnabled ? Color(0xff808080) : AppColors.newUpdateColor,
        ),
        child: AnimatedAlign(
          duration: animationDuration,
          alignment: isEnabled ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 19,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }}