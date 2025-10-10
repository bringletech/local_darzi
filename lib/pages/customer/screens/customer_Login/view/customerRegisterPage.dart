import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/apiData/model/login_model.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/main.dart';
import 'package:darzi/pages/customer/screens/Customer_Otp_Verification/view/customer_otp_screen.dart';
import 'package:darzi/pages/customer/screens/customer_dashboard/view/customer_dashboard_new.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


import '../../../../../l10n/app_localizations.dart';


class CustomerregisterpagePage extends StatefulWidget {
  Locale locale; // Receive Locale

  CustomerregisterpagePage({super.key, required this.locale});

  @override
  State<CustomerregisterpagePage> createState() => _CustomerregisterpagePageState();
}

class _CustomerregisterpagePageState extends State<CustomerregisterpagePage> {
  FocusNode focusNode = FocusNode();
  bool rememberMe = false,
      isLoading = false,isSelected = false;
  String phoneNumber = "",deviceToken = "";
  final Uri _privacyPolicyUrl = Uri.parse('https://mannytechnologies.com/privacy-policy-2/');
  final Uri _terms_of_use_Url = Uri.parse('https://mannytechnologies.com/terms-conditions/');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _changeLanguage(widget.locale);
    print("Current Locale in OTP Screen: ${widget.locale.languageCode}");
    getDeviceToken();
  }

  Future<void> getDeviceToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    deviceToken = prefs.getString('deviceToken')!;
    print("My Device Token Value is: $deviceToken");
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
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: TextButton(
                              onPressed: (){
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => CustomerDashboardNew(locale: widget.locale)),
                                );
                              },
                              child: Text(
                                AppLocalizations.of(context)!.skip,
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                    color: Colors.black
                                ),
                              )

                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 22,vertical: 80),
                        child: Image.asset(
                          'assets/images/darzi_logo.png',
                          height: MediaQuery.of(context).size.height * 0.20,
                          fit: BoxFit.contain,
                        ),
                      ),

                      Text(
                        AppLocalizations.of(context)!.login,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 20),

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
                            child:
                            Column(
                              children: [
                                SizedBox(height: 10,),
                                //SizedBox(height: 20,),
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

                                        if (rememberMe) {
                                          // ✅ Check for first-time name requirement
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
                                          // ✅ Call API only when both fields are valid
                                          callCustomerLoginApi(phoneNumber);
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
                                              text:  AppLocalizations.of(context)!.termsOfService + " and ", // "Terms of Service"
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                                color: AppColors.newUpdateColor, // Highlight color
                                                decoration: TextDecoration.underline,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () async {
                                                  final Uri url = _terms_of_use_Url;

                                                  // Use mode: LaunchMode.externalApplication to ensure it opens in browser
                                                  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(content: Text('Could not open the privacy policy link')),
                                                    );
                                                  }
                                                },
                                            ),
                                            TextSpan(
                                              text: AppLocalizations.of(context)!.privacyPolicy,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                                color: AppColors.newUpdateColor, // or any color you want
                                                decoration: TextDecoration.underline,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () async {
                                                  final Uri url = _privacyPolicyUrl;

                                                  // Use mode: LaunchMode.externalApplication to ensure it opens in browser
                                                  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(content: Text('Could not open the privacy policy link')),
                                                    );
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
                      SizedBox(height: 20),
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

  void callCustomerLoginApi(String phoneNumber) {
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
      if (model.status == true){
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CustomerOtpVerificationPage(phoneNumber,locale: widget.locale)),
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
    Future.delayed(Duration(seconds: durationInSeconds), () {
      overlayEntry.remove();
    });
  }
}