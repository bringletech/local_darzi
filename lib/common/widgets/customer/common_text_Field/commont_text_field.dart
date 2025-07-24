import 'package:darzi/colors.dart';
import 'package:darzi/constants/string_constant.dart';
import 'package:darzi/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

Widget buildTextField(String labelText, TextEditingController controller) {
  return SizedBox(
    width: 350,
    height: 60,
    child: Material(
      elevation: 10,
      shadowColor: Colors.black.withOpacity(1.0),
      borderRadius: BorderRadius.circular(30),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
              fontFamily: 'Inter',
              color: Color(0xFF454545),
              fontSize: 18,
              fontWeight: FontWeight.w400),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    ),
  );
}


// Method to build Row with TextField or Button
Widget buildRowField(String labelText, String hintText,
    {bool isButton = false, TextEditingController? controller}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // Label
      Expanded(
        flex: 2,
        child: Text(
          labelText,
          style: TextStyle(
            fontFamily: 'Popins',
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      SizedBox(width: 8), // Space between label and field

      // TextField or Button
      Expanded(
        flex: 3,
        child: isButton
            ? GestureDetector(
                onTap: () {
                  // Handle Image Picker logic
                },
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.white),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 4.0,
                        blurRadius: 4.0,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          hintText,
                          style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              color: Colors.red,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Icon(Icons.add_circle_outline_sharp,
                            size: 15, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              )
            : TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: UnderlineInputBorder(),
                ),
              ),
      ),
    ],
  );
}


// Method to build notification fields
Widget buildNotificationFields(Locale? locale) {
  return Padding(
      padding: EdgeInsets.all(10),
      child: LayoutBuilder(builder: (context, constraints) {
        return Padding(
            padding: const EdgeInsets.all(8),
            child: ListView(
              children: [
                Container(
                  height: 75,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40.0), // Corner radius for card
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Shadow color with opacity
                        spreadRadius: 2, // How much the shadow spreads
                        blurRadius: 8,   // How blurry the shadow is
                        offset: Offset(0, 4), // Shadow position (x, y)
                      ),
                    ],
                  ),
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0), // Match the Container radius
                    ),
                    elevation: 0, // Turn off Card's default elevation
                    child: ListTile(
                      title: Text(
                        AppLocalizations.of(context)!.newOrder,
                        style: TextStyle(
                          color: Color(0xFFFF0006),
                          fontSize: 17,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500, // Title color
                        ),
                      ),
                      subtitle: Text(
                        AppLocalizations.of(context)!.newOrdersDetails,
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 11,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w300, // Subtitle color
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 75,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40.0), // Corner radius for card
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Shadow color with opacity
                        spreadRadius: 2, // How much the shadow spreads
                        blurRadius: 8,   // How blurry the shadow is
                        offset: Offset(0, 4), // Shadow position (x, y)
                      ),
                    ],
                  ),
                  child: Card(
                    color: Colors.white,
                    shape: StadiumBorder(
                      //<-- 3. SEE HERE
                      side: BorderSide(
                        color: Colors.transparent,
                        width: 2.0,
                      ),
                    ),
                    elevation: 0,
                    child: ListTile(
                      // minTileHeight: 30,
                      title: Text(
                        AppLocalizations.of(context)!.appointment_reminder,
                        style: TextStyle(
                            color: Color(0xFF0066FF),
                            fontSize: 17,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500), // Title color
                      ),
                      subtitle: Text(
                        AppLocalizations.of(context)!.appointmentReminderDetails,
                        style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 11,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w300), // Subtitle color
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 75,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40.0), // Corner radius for card
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Shadow color with opacity
                        spreadRadius: 2, // How much the shadow spreads
                        blurRadius: 8,   // How blurry the shadow is
                        offset: Offset(0, 4), // Shadow position (x, y)
                      ),
                    ],
                  ),
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0), // Match the Container radius
                    ),
                    elevation: 0, // Turn off Card's default elevation
                    child: ListTile(
                      title: Text(
                        AppLocalizations.of(context)!.newOrder,
                        style: TextStyle(
                          color: Color(0xFFFF0006),
                          fontSize: 17,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500, // Title color
                        ),
                      ),
                      subtitle: Text(
                        AppLocalizations.of(context)!.newOrdersDetails,
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 11,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w300, // Subtitle color
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 75,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40.0), // Corner radius for card
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Shadow color with opacity
                        spreadRadius: 2, // How much the shadow spreads
                        blurRadius: 8,   // How blurry the shadow is
                        offset: Offset(0, 4), // Shadow position (x, y)
                      ),
                    ],
                  ),
                  child: Card(
                    color: Colors.white,
                    shape: StadiumBorder(
                      //<-- 3. SEE HERE
                      side: BorderSide(
                        color: Colors.transparent,
                        width: 2.0,
                      ),
                    ),
                    elevation: 0,
                    child: ListTile(
                      // minTileHeight: 30,
                      title: Text(
                        AppLocalizations.of(context)!.appointment_reminder,
                        style: TextStyle(
                            color: Color(0xFF0066FF),
                            fontSize: 17,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500), // Title color
                      ),
                      subtitle: Text(
                        AppLocalizations.of(context)!.appointmentReminderDetails,
                        style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 11,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w300), // Subtitle color
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
              ],
            ));
      }));
}

Widget buildSaveButton(BuildContext context) {
  bool isPressed = false;

  return StatefulBuilder(
    builder: (context, setState) {
      return GestureDetector(
        onTapDown: (_) {
          setState(() {
            isPressed = true;
          });
        },
        onTapUp: (_) async {},
        onTapCancel: () {
          setState(() {
            isPressed = false;
          });
        },
        child: Container(
          width: 350,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isPressed
                  ? AppColors.Gradient1
                  : [Colors.white, Colors.white],
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.primaryRed, width: 2),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  StringConstant.saveDetails,
                  style: TextStyle(
                    color: isPressed ? Colors.white : AppColors.primaryRed,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 19,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}


