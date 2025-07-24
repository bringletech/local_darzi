import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/apiData/model/login_model.dart';
import 'package:darzi/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../main.dart';
import '../../tailor_otp_verification/view/otp_screen.dart'; // Ensure this import is correct

class TailorPage extends StatefulWidget {
  Locale locale; // Receive Locale

  TailorPage({super.key, required this.locale});

  @override
  State<TailorPage> createState() => _TailorPageState();
}

class _TailorPageState extends State<TailorPage> {
  FocusNode focusNode = FocusNode();
  bool rememberMe = false,isLoading = false;
  String phoneNumber = "",deviceToken = "";
  final TextEditingController nameController = TextEditingController();
  final Uri _privacyPolicyUrl = Uri.parse('https://mannytechnologies.com/privacy-policy-2/');
  final Uri _terms_of_use_Url = Uri.parse('https://mannytechnologies.com/terms-conditions/');
  bool isFirstTime = true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _changeLanguage(widget.locale);
    print("Current Locale in OTP Screen: ${widget.locale.languageCode}");
    getDeviceToken();
    checkIfFirstTime();
  }


  Future<void> getDeviceToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    deviceToken = prefs.getString('deviceToken')!;
    print("My Device Token Value is: $deviceToken");
  }

  Future<void> checkIfFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isFirstTime = prefs.getBool('isFirstTimeLogin') ?? true;
    setState(() {});
  }

  void _changeLanguage(Locale locale) {
    setState(() {
      widget.locale = locale; // Update the locale
      WidgetsBinding.instance.addPostFrameCallback((_) {
        MyApp.of(context)?.setLocale(locale); // Update the locale dynamically
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child: Image.asset(
                          'assets/images/darzi_logo.png',
                          height: MediaQuery.of(context).size.height * 0.20,
                          fit: BoxFit.contain,
                        ),
                      ),
                      // Login Text
                      Text(
                        AppLocalizations.of(context)!.login,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Card with Input and Agreement
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 12),
                            child: Column(
                              children: [
                                SizedBox(height: 10,),
                                if (isFirstTime)
                                  Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: TextField(
                                      controller: nameController,
                                      decoration: InputDecoration(
                                        hintText: AppLocalizations.of(context)!.enter_name,
                                        hintStyle: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black.withOpacity(0.6),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black),
                                        ),
                                      ),
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                SizedBox(height: 20,),
                                // Phone number input
                                IntlPhoneField(
                                  focusNode: focusNode,
                                  decoration: InputDecoration(
                                    labelText:
                                    AppLocalizations.of(context)!.phoneNumber,
                                    border: const OutlineInputBorder(),
                                  ),
                                  languageCode: "en",
                                  showCountryFlag: true,
                                  initialCountryCode: 'IN',
                                  onChanged: (phone) {
                                    phoneNumber = phone.number.toString();
                                  },
                                  onCountryChanged: (country) {
                                    print('Country changed to: ${country.name}');
                                  },
                                ),

                                // Agreement section
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Checkbox(
                                      value: rememberMe,
                                      activeColor: AppColors.newUpdateColor,
                                      onChanged: (value) {
                                        setState(() {
                                          rememberMe = value!;
                                        });

                                        String name = nameController.text.trim();

                                        if (rememberMe) {
                                          // ✅ Check for first-time name requirement
                                          if (isFirstTime && name.isEmpty) {
                                            Fluttertoast.showToast(
                                              msg: AppLocalizations.of(context)!.enter_name1,
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: AppColors.newUpdateColor,
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );
                                            return;
                                          }

                                          if (phoneNumber.isEmpty) {
                                            Fluttertoast.showToast(
                                              msg: AppLocalizations.of(context)!.enter_name2,
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: AppColors.newUpdateColor,
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );
                                            return;
                                          }

                                          // ✅ Call API only when validations pass
                                          callTailorLoginApi(phoneNumber, name);
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: AppLocalizations.of(context)!.agreeContinue,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: AppColors.newUpdateColor,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        }
                                      },
                                    ),

                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: AppLocalizations.of(context)!
                                                  .agreeContinue,
                                            ),
                                            TextSpan(
                                              text: AppLocalizations.of(context)!.termsOfService+" and  ", // "Terms of Service"
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                                color: AppColors.newUpdateColor,// Highlight color
                                                decoration: TextDecoration.underline,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () async {
                                                  // Navigate to Terms of Service
                                                  print('Terms of Service clicked');
                                                  if (await canLaunchUrl(_terms_of_use_Url)) {
                                                    await launchUrl(_terms_of_use_Url, mode: LaunchMode.externalApplication);
                                                  } else {
                                                    print('Could not launch $_terms_of_use_Url');
                                                  }
                                                  print('Terms of Service clicked');
                                                },
                                            ),
                                            TextSpan(
                                              text: AppLocalizations.of(context)!.privacyPolicy,
                                              style: TextStyle(
                                                color: AppColors.newUpdateColor,
                                                decoration: TextDecoration.underline,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () async {
                                                  if (await canLaunchUrl(_privacyPolicyUrl)) {
                                                    await launchUrl(_privacyPolicyUrl, mode: LaunchMode.externalApplication);
                                                  } else {
                                                    print('Could not launch $_privacyPolicyUrl');
                                                  }
                                                },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  void callTailorLoginApi(String phoneNumber, String name) {
    var map = <String, dynamic>{};
    map['mobileNo'] = phoneNumber;
    map['name'] = name;
    map['device_fcm_token'] = deviceToken;

    print("Map value is$map");
    isLoading = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      LoginResponseModel model = await CallService().userLogin(map);
      isLoading = false;

      String message = model.message.toString();
      String otp = model.otp.toString();
      print("Otp Value is $otp");

      showCustomToast(context, message, 10);

      // ✅ Set firstTimeLogin to false only on success
      if (model.status == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isFirstTimeLogin', false);

        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OtpVerificationPage(phoneNumber, name, locale: widget.locale),
          ),
        );
      }
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
                  color: AppColors.newUpdateColor,
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