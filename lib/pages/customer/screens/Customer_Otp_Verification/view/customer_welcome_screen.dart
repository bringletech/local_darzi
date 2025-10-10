// import 'package:darzi/colors.dart';
// import 'package:darzi/l10n/app_localizations.dart';
// import 'package:flutter/material.dart';
//
// class WelcomeScreen extends StatefulWidget {
//   const WelcomeScreen({Key? key}) : super(key: key);
//
//   @override
//   State<WelcomeScreen> createState() => _WelcomeScreenState();
// }
//
// class _WelcomeScreenState extends State<WelcomeScreen> {
//   bool hideNumber = true;
//   final TextEditingController nameController =
//   TextEditingController(text: "Joe Goldberg");
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 10),
//               const Text(
//                 "Welcome!",
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               const Text(
//                 "First what we can call you?",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.black,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 "We’d like to get you know you.",
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.blue.shade700,
//                   decoration: TextDecoration.underline,
//                 ),
//               ),
//               const SizedBox(height: 30),
//               Text(
//                 AppLocalizations.of(context)!.enter_name,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.black87,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               TextField(
//                 controller: nameController,
//                 decoration: InputDecoration(
//                   contentPadding:
//                   const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide(color: AppColors.newUpdateColor),
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: AppColors.newUpdateColor),
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: AppColors.newUpdateColor, width: 1.5),
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   hintText: AppLocalizations.of(context)!.enter_name,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Checkbox(
//                     value: hideNumber,
//                     activeColor: Colors.orange,
//                     onChanged: (value) {
//                       setState(() {
//                         hideNumber = value ?? false;
//                       });
//                     },
//                   ),
//                   Expanded(
//                     child: RichText(
//                       text: const TextSpan(
//                         children: [
//                           TextSpan(
//                             text: "Hide My Number ",
//                             style: TextStyle(
//                                 color: Colors.black87,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                           TextSpan(
//                             text:
//                             "(This will not hide your number from Customer you add.)",
//                             style: TextStyle(
//                               color: Colors.black87,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const Spacer(),
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.newUpdateColor,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(6)),
//                   ),
//                   onPressed: () {
//                     // Next button pressed
//                   },
//                   child: const Text(
//                     "Next",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/apiData/model/customer_register_response_model.dart';
import 'package:darzi/apiData/model/tailor_registration_response_model.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/l10n/app_localizations.dart';
import 'package:darzi/pages/customer/screens/customer_dashboard/view/customer_dashboard_new.dart';
import 'package:darzi/pages/tailor/screens/tailor_dashboard/view/tailor_dashboard_new.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerWelcomeScreen extends StatefulWidget {
  final String phoneNumber;
  final Locale locale;
  const CustomerWelcomeScreen(this.phoneNumber, {super.key, required this.locale});

  @override
  State<CustomerWelcomeScreen> createState() => _CustomerWelcomeScreenState();
}

class _CustomerWelcomeScreenState extends State<CustomerWelcomeScreen> {
  bool isLoading = false; // ✅ Loader state
  String userName = "",deviceToken = "";
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDeviceToken();
    //checkIfFirstTime();
  }

  Future<void> getDeviceToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    deviceToken = prefs.getString('deviceToken')!;
    print("My Device Token Value is: $deviceToken");
  }


  Future<void> submitData() async {
    setState(() => isLoading = true);

    try {
      var map = {
        'mobileNo': widget.phoneNumber,
        'name': userName,
        'device_fcm_token': deviceToken,
      };
      print("📤 Sending data to API: $map");

      Customer_Register_Response_Model model =
      await CallService().customer_registeration(map);

      setState(() => isLoading = false);

      String message = model.message ?? "Registration completed successfully!";

      if (model.status == true && model.customer != null) {
        // ✅ Show success toast
        // Fluttertoast.showToast(
        //   msg: message,
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.CENTER,
        //   backgroundColor: AppColors.newUpdateColor,
        //   textColor: Colors.white,
        //   fontSize: 16.0,
        // );

        // ✅ Save in SharedPreferences
        String id = model.customer!.id.toString();
        String mobileNo = model.customer!.mobileNo.toString();
        String accessToken = model.customer!.token.toString();
        String userType = model.customer!.type.toString();
        String name = model.customer!.name.toString();
        print("Customer's Details $message");
        print("Customer's Details $id");
        print("Customer's Details $mobileNo");
        print("Customer's Details $accessToken");
        print("Customer's Details $userType");
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("userId", id);
        await prefs.setString('userMobileNumber',mobileNo);
        await prefs.setString("userToken", accessToken);
        await prefs.setString("userName", name);
        await prefs.setString("userType", userType);

        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CustomerDashboardNew(locale: widget.locale)),
        );
      } else {
        // ❌ Registration failed
        Fluttertoast.showToast(
          msg: message.isNotEmpty
              ? message
              : "Registration failed. Please try again.",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double screenWidth = size.width;
    final double screenHeight = size.height;

    double getFontSize(double baseSize) {
      return baseSize * (screenWidth / 375);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.015,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.015),
                  Text(
                    AppLocalizations.of(context)!.welcome,
                    style: TextStyle(
                      fontSize: getFontSize(28),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  Text(
                    AppLocalizations.of(context)!.first_what_we_can_call_you,
                    style: TextStyle(
                      fontSize: getFontSize(18),
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Text(
                    AppLocalizations.of(context)!.get_you_know_you,
                    style: TextStyle(
                      fontSize: getFontSize(14),
                      color: AppColors.newUpdatedColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Text(
                    AppLocalizations.of(context)!.enter_name,
                    style: TextStyle(
                      fontSize: getFontSize(16),
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: screenHeight * 0.018,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.newUpdateColor),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.newUpdateColor),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.newUpdateColor, width: 1.5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      hintText: AppLocalizations.of(context)!.enter_name,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: screenHeight * 0.06,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.newUpdateColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: isLoading
                          ? null // Loader होने पर disable
                          : () {
                        // Name field से डेटा लो
                        userName = nameController.text.trim();

                        // ✅ Validation: Empty name check
                        if (userName.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(context)!.enter_name, // Multi-language key
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return; // Stop execution, API call नहीं होगी
                        }

                        // ✅ Validation पास → API कॉल
                        submitData();
                      },
                      child: isLoading
                          ? SizedBox(
                        height: screenHeight * 0.03,
                        width: screenHeight * 0.03,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : Text(
                        AppLocalizations.of(context)!.next,
                        style: TextStyle(
                          fontSize: getFontSize(16),
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.025),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

