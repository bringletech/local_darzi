import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/apiData/model/login_model.dart';
import 'package:darzi/apiData/model/otp_verification_model.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/common/widgets/tailor/common_otp_app_bar_with_back.dart';
import 'package:darzi/pages/tailor/screens/tailor_dashboard/view/tailor_dashboard_new.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../l10n/app_localizations.dart';


class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final String name;
  final Locale locale;
  const OtpVerificationPage(this.phoneNumber, this.name,{super.key,required this.locale});

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  // Create separate TextEditingController for each OTP field
  List<TextEditingController> otpControllers =
  List.generate(6, (index) => TextEditingController());
  int _secondsRemaining = 30;
  bool isLoading = false;
  String otp  = "",phoneNumber = "",name="";
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    phoneNumber = widget.phoneNumber;
    name = widget.name;
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<void> resendOtp() async {
    _secondsRemaining = 30;
    startTimer();
    phoneNumber = widget.phoneNumber;
    print("My Phone Number is $phoneNumber");
    for (var controller in otpControllers) {
      controller.clear();
    }
    callTailorLoginApi(phoneNumber,name);
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in otpControllers) {
      controller.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomOtpAppBarWithBack(
        title: AppLocalizations.of(context)!.otpVerify,
        hasBackButton: false,
        elevation: 2.0,
        color:AppColors.newUpdateColor,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 80),
            Text(AppLocalizations.of(context)!.otpSentMessage ,style: TextStyle(
                fontFamily: 'Poppins',fontSize: 16,fontWeight: FontWeight.w400,color: Color(0xff606268)),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "+91-XXXXXX${phoneNumber.substring(phoneNumber.length-4)}",
                  style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54),
                ),
                SizedBox(width: 5,),
                GestureDetector(
                  onTap: (){
                    _showEditNumberDialog(context, phoneNumber);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.edit,
                    style: TextStyle(
                        color: AppColors.newUpdateColor,
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  6, (index) => otpInputField(otpControllers[index], index)),
            ),
            const SizedBox(height: 40),
            const SizedBox(height: 20),
            _secondsRemaining > 0
                ? Text(
              "00:${_secondsRemaining.toString().padLeft(2, '0')}",
              style: TextStyle(fontSize: 14, color: AppColors.newUpdateColor),
            )
                : TextButton(
              onPressed: resendOtp,

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.receiveCode,textAlign: TextAlign.center, style: TextStyle(

                      fontFamily: 'Inter',fontWeight: FontWeight.w400,color:  Color(0xff454545), fontSize: 14),),
                  Text(
                    AppLocalizations.of(context)!.resend,
                    style: TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.w400,color: Colors.blue, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _showEditNumberDialog(BuildContext context1, String currentPhoneNumber) async {
    TextEditingController numberController = TextEditingController(text: currentPhoneNumber);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.editPhoneNumber),
          //title: const Text("Edit Phone Number"),
          content: TextField(
            controller: numberController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              //labelText: "Phone Number",
              labelText: AppLocalizations.of(context)!.phoneNumber,
              hintText: AppLocalizations.of(context)!.enterNumber,
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 47,
                  width: 120,
                  child: Card(
                    color: AppColors.newUpdateColor,
                    elevation: 4,
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(8),
                    ),
                    child: TextButton(
                      onPressed: () {
                        String updatedNumber = numberController.text;
                        Navigator.of(context).pop(updatedNumber);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.buttonContinue,
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white), // Styled like in the 3rd function
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 47,
                  width: 110,
                  child: Card(
                    color: Colors.white,
                    elevation: 4,
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(8),
                      side: BorderSide(color: AppColors.newUpdateColor, width: 1.5),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child:  Text(
                        AppLocalizations.of(context)!.cancel,
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: AppColors.newUpdateColor), // Styled like in the 3rd function
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    ).then((updatedNumber) {
      if (updatedNumber != null && updatedNumber is String && updatedNumber.isNotEmpty) {
        setState(() {
          phoneNumber = updatedNumber; // Update the phone number in the parent widget
        });
        callTailorLoginApi(phoneNumber,name); // Call the login API with the updated phone number
      }
    });
  }
  // Each input field now has its own controller and takes up a flexible width
  Widget otpInputField(TextEditingController controller, int index) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1, // Restrict input to a single digit
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            counterText: '', // Hides the character count below the box
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              if (index < otpControllers.length - 1) {
                FocusScope.of(context).nextFocus();
              } else {
                otp = otpControllers.map((c) => c.text).join();
                if (otp.length == 6) {
                  submitOTP();
                }
              }
            } else if (value.isEmpty) {
              if (index > 0) {
                FocusScope.of(context).previousFocus();
              }
            }
          },
        ),
      ),
    );
  }
  void submitOTP() {
    otp = otpControllers.map((controller) => controller.text).join();
    if (otp.length == 6) {
      print("OTP Submitted: $otp");
      callTailorOtpVerifyApi(otp,phoneNumber);
      // You can call your backend API here to verify the OTP
    } else {
      Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.warningMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.newUpdateColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
  Future<void> callTailorOtpVerifyApi(String otp,String phoneNumber) async {
    var map = <String, dynamic>{};
    map['mobileNo'] = phoneNumber;
    map['otp'] = otp;
    isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      OtpVerificationResponseModel model =
      await CallService().tailorOtpVerification(map);
      isLoading = false;
      String message = model.message.toString();
      String id = model.data!.id.toString();
      String mobileNo = model.data!.mobileNo.toString();
      String accessToken = model.data!.accessToken.toString();
      String userType = model.data!.type.toString();
      print("Tailor's Details $message");
      print("Tailor's Details $id");
      print("Tailor's Details $mobileNo");
      print("Tailor's Details $accessToken");
      print("Tailor's Details $userType");
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("userId", id);
      await prefs.setString('userMobileNumber',mobileNo);
      await prefs.setString("userToken", accessToken);
      await prefs.setString("userType", userType);
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.newUpdateColor,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TailorDashboardNew(locale: widget.locale)),
      ); // Handle button press
    });
  }

  void callTailorLoginApi(String phoneNumber, String name) {
    var map =  <String, dynamic>{};
    map['mobileNo'] = phoneNumber;
    map['name'] = name;
    print("Map value is$map");
    isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      LoginResponseModel model = await CallService().userLogin(map);
      isLoading = false;
      String message = model.message.toString();
      String otp = model.otp.toString();
      print("Otp Value is $otp");
      showCustomToast(context, message, 10);
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.newUpdateColor,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }
  void showCustomToast(BuildContext context, String message, int durationInSeconds) {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    // Remove toast after the given duration
    Future.delayed(Duration(seconds: durationInSeconds), () {
      overlayEntry.remove();
    });
  }
}
