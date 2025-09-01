import 'package:flutter/material.dart';
import 'package:darzi/colors.dart'; // aapke color file ka path

class AnimatedSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color enabledTrackColor;

  AnimatedSwitch({
    required this.value,
    required this.enabledTrackColor,
    required this.onChanged,
  });

  @override
  _AnimatedSwitchState createState() => _AnimatedSwitchState();
}

class _AnimatedSwitchState extends State<AnimatedSwitch> {
  late bool isEnabled;
  final Duration animationDuration = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    isEnabled = widget.value;
  }

  @override
  void didUpdateWidget(covariant AnimatedSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      setState(() {
        isEnabled = widget.value; // parent se value change hone par update
      });
    }
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
        height: 25,
        width: 50,
        duration: animationDuration,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: isEnabled
              ? AppColors.newUpdatedColor // ON color
              :widget.enabledTrackColor, // OFF color
        ),
        child: AnimatedAlign(
          duration: animationDuration,
          alignment:
          isEnabled ? Alignment.centerRight : Alignment.centerLeft,
          curve: Curves.easeInOut,
          child: Container(
            width: 22,
            height: 22,
            margin: EdgeInsets.all(1.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
