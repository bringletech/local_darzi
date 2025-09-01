import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/apiData/model/login_model.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/common/widgets/tailor/common_otp_app_bar_with_back.dart';
import 'package:darzi/pages/customer/screens/Customer_Otp_Verification/view/customer_welcome_screen.dart';
import 'package:darzi/pages/customer/screens/customer_dashboard/view/customer_dashboard_new.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../l10n/app_localizations.dart';


class CustomerOtpVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final Locale locale;
  const CustomerOtpVerificationPage(this.phoneNumber,{super.key, required this.locale});

  @override
  _CustomerOtpVerificationPageState createState() =>
      _CustomerOtpVerificationPageState();
}

class _CustomerOtpVerificationPageState
    extends State<CustomerOtpVerificationPage> {
  List<TextEditingController> otpControllers =
  List.generate(6, (index) => TextEditingController());
  int _secondsRemaining = 30;
  Timer? _timer;
  bool isLoading = false;
  bool isOtpComplete = false;
  String otp = "", phoneNumber = "",deviceToken = "",name='';

  @override
  void initState() {
    super.initState();
    phoneNumber = widget.phoneNumber;
    startTimer();
    getDeviceToken();
  }

  Future<void> getDeviceToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    deviceToken = prefs.getString('deviceToken')!;
    print("My Device Token Value is: $deviceToken");
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void resendOtp() {
    setState(() {
      _secondsRemaining = 30;
      startTimer();

      for (var controller in otpControllers) {
        controller.clear();
      }
      isOtpComplete = false;
    });
    phoneNumber = widget.phoneNumber;
    print("My Phone Number is $phoneNumber");
    for (var controller in otpControllers) {
      controller.clear();
    }
    callCustomerLoginApi(phoneNumber,name);
  }

  bool checkOtpComplete() {
    return otpControllers.every((controller) => controller.text.isNotEmpty);
  }

  void updateOtpStatus() {
    setState(() {
      isOtpComplete = checkOtpComplete();
    });
  }

  Future<void> submitOTP() async {
    otp = otpControllers.map((controller) => controller.text).join();
    if (otp.length == 6) {
      callCustomerOtpVerifyApi(otp, phoneNumber);
    } else {
      Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.warningMessage,
          backgroundColor: Colors.black,
          textColor: Colors.white);
    }
  }

  void _showEditNumberDialog(BuildContext context1, String currentPhoneNumber) async{
    TextEditingController numberController = TextEditingController(text: currentPhoneNumber);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.editPhoneNumber),
          content: TextField(
            controller: numberController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
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
                  width: 100,
                  child: Card(
                    color: AppColors.newUpdateColor,
                    elevation: 4,
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextButton(
                      onPressed: () {
                        String updatedNumber = numberController.text;
                        Navigator.of(context).pop(updatedNumber);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.buttonContinue,
                        style: TextStyle(
                            color: Colors
                                .white), // Styled like in the 3rd function
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
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: AppColors.newUpdateColor, width: 1.5),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: TextStyle(
                            color:
                            AppColors.newUpdateColor), // Styled like in the 3rd function
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
        callCustomerLoginApi(phoneNumber,name);// Call the login API with the updated phone number
      }
    });
  }

  Widget otpInputField(TextEditingController controller, int index) {
    return Container(
      width: 50,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8)),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomOtpAppBarWithBack(
        title: AppLocalizations.of(context)!.otpVerify,
        hasBackButton: false,
        elevation: 2.0,
        color: AppColors.primaryRed,
      ),
      body:  Center(
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
              style:  TextStyle(fontSize: 14, color: AppColors.newUpdateColor),
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


  Future<void> callCustomerOtpVerifyApi(String otp, String phoneNumber) async {
    var map = {
      'mobileNo': phoneNumber,
      'otp': otp,
    'device_fcm_token':deviceToken
    };
    print("Customer Otp map value is $map");
    setState(() => isLoading = true);
    final model = await CallService().customerOtpVerification(map);
    String message = model.message.toString();
    setState(() => isLoading = false);
    if(message == "OTP verified. Logged In Successfully !!") {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', model.data!.id.toString());
      await prefs.setString(
          'userMobileNumber', model.data!.mobileNo.toString());
      await prefs.setString('userToken', model.data!.accessToken.toString());
      await prefs.setString('userType', model.data!.type.toString());
      await prefs.setString('userName', model.data!.name.toString());
      await prefs.setString('userProfile', model.data!.profileUrl.toString());
      await prefs.setString('userAddress', model.data!.address.toString());

      Fluttertoast.showToast(
          msg: model.message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.newUpdateColor,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => CustomerDashboardNew(locale: widget.locale)),
      );
    }else if(message == "Otp verified. But User is not registered !!"){
      Fluttertoast.showToast(
          msg: model.message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.newUpdateColor,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CustomerWelcomeScreen(phoneNumber,locale: widget.locale)),
      );
    }
  }

  void callCustomerLoginApi(String phoneNumber, String name) {
    var map = <String, dynamic>{};
    map['mobileNo'] = phoneNumber;
    print("Map value is$map");
    isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      LoginResponseModel model =
      await CallService().customerLogin(map);
      isLoading = false;
      String message = model.message.toString();
      String otp = model.otp.toString();
      print("Customer Otp is $otp");
      showCustomToast(context, message, 10);
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.newUpdateColor,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CustomerOtpVerificationPage(phoneNumber,locale: widget.locale)),
      );
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
    Future.delayed(Duration(seconds: durationInSeconds), () {
      overlayEntry.remove();
    });
  }
}