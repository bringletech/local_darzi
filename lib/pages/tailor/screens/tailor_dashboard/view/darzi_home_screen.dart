import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/apiData/model/current_tailor_detail_response.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/common/widgets/tailor/common_app_bar.dart';
import 'package:darzi/homePage.dart';
import 'package:darzi/l10n/app_localizations.dart';
import 'package:darzi/pages/tailor/screens/tailor_active_dress/view/active_dress.dart';
import 'package:darzi/pages/tailor/screens/tailor_add_customer/view/add_customer.dart';
import 'package:darzi/pages/tailor/screens/tailor_notification/view/tailor_notification_screen.dart';
import 'package:darzi/pages/tailor/screens/tailor_outstanding_balance/view/customer_outstanding_balance.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../tailor_report/view/tailor_report.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class DarziHomeScreen extends StatefulWidget {
  static const TextStyle titleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 22,
    color: Colors.black,
  );

  final PageController tabController = PageController(initialPage: 0);
  var selectedIndex = 0;
  final Locale locale;
  DarziHomeScreen({super.key, required this.locale,});

  @override
  State<DarziHomeScreen> createState() => _DarziHomeScreenState();
}

class _DarziHomeScreenState extends State<DarziHomeScreen> {

  final CallService callService = CallService();
  bool isLoading = false;
  List<SpecificCustomerOrder> orderList = [];
  List<Customers> customersList = [];

  // Track if the buttons are tapped
  final List<bool> _isTapped = [false, false,false,false];
  int _selectedIndex = 0;
  final int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData(); // Call the async method
    setState(() {
      isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Current_Tailor_Response model =
        await CallService().getCurrentTailorDetails();
        setState(() {
          isLoading = false;
          orderList = model.data!.order!;
          customersList = model.data!.customers!;
          print("list Value is: $orderList");
          print("list Value is: ${customersList.length}");
        });
      });
    });
  }
  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('userToken');

    if (accessToken == null || accessToken.isEmpty) {
      // Access token not found – logout the user
      _logoutUser(context);
      return;
    }

    setState(() {
      isLoading = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        Current_Tailor_Response model = await CallService().getCurrentTailorDetails();
        setState(() {
          isLoading = false;
          orderList = model.data!.order!;
          customersList = model.data!.customers!;
          print("list Value is: $orderList");
          print("list Value is: ${customersList.length}");
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print("Error: $e");
      }
    });
  }

  void _logoutUser(BuildContext context) async {
    showAlertDialog(
      context,
      locale: widget.locale,
      onChangeLanguage: (newLocale) {
        // Handle the language change
        print(
            "Language changed to: ${newLocale.languageCode}");
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
            title: AppLocalizations.of(context)!.appHome,
            elevation: 2.0,
            leadingIcon: SvgPicture.asset(
              'assets/svgIcon/home.svg',
              allowDrawingOutsideViewBox: true,
            ),
          onNotificationTap: () {
            print("Bell tapped!");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TailorNotificationScreen(locale: widget.locale,),
              ),
            );
          },
        ),
        body: isLoading == true?Center(
            child: CircularProgressIndicator(color: AppColors.newUpdateColor,))
            :Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 60),
              SizedBox(
                height: 300,
                child: customersList.isNotEmpty?GridView.count(
                  crossAxisCount:
                  MediaQuery.of(context).size.width > 600 ? 3 : 2,
                  // Adjust grid count based on screen width
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1.4,
                  children: [
                    _buildCustomGridItem(
                        AppLocalizations.of(context)!.addCustomer,
                        SvgPicture.asset(
                      'assets/svgIcon/addCustomer.svg',//just change my image with your image
                      color: Colors.black,
                    ), 0),
                    _buildCustomGridItem1(
                      AppLocalizations.of(context)!.activeDresses, SvgPicture.asset(
                      'assets/svgIcon/dress.svg',//just change my image with your image
                      color: Colors.black,
                    ), 1),
                    // Using dress icon here
                    _buildCustomGridItem2(
                        AppLocalizations.of(context)!.outstandingBalance, SvgPicture.asset(
                      'assets/svgIcon/out_standing_balance.svg',//just change my image with your image
                      color: Colors.black,
                    ), 2),
                    _buildCustomGridItem3(
                        AppLocalizations.of(context)!.report, SvgPicture.asset(
                      'assets/svgIcon/report.svg',//just change my image with your image
                      color: Colors.black,
                    ), 3),
                  ],
                ):
                Center(
                  child: GridView.count(
                    crossAxisCount:
                    MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    // Adjust grid count based on screen width
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1.4,
                    children: [
                      _buildCustomGridItem(
                      AppLocalizations.of(context)!.addCustomer,  SvgPicture.asset(
                        'assets/svgIcon/addCustomer.svg',//just change my image with your image
                        color: Colors.black,
                      ), 0),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomGridItem(String label, Widget icon, int index) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isTapped[index] = true; // Set tapped state
        });
      },
      onTapUp: (_) {
        // Reset tapped state after a brief delay
        Future.delayed(const Duration(milliseconds: 100), () async {
          setState(() {
            _isTapped[index] = false; // Reset tapped state
          });
          // Navigate to the corresponding page
          if (index == 0) {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddCustomer(locale: widget.locale) // tailor page (new route will be added)
              ),
            );
            // Refresh with the result
            if (result == true) {
              setState(() {
                _loadData();
                //data = result;
              });
            }

          } else {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                   ActiveDress(locale: widget.locale) // navigate to active dress page
              ),
            );
            // Refresh with the result
            if (result == true) {
              setState(() {
                _loadData();
                //data = result;
              });
            }
          }
        });
      },
      onTapCancel: () {
        setState(() {
          _isTapped[index] = false; // Reset tapped state on cancel
        });
      },
      child: Material(
        elevation: 8,
        shadowColor: Colors.black.withOpacity(1.0),
        borderRadius: BorderRadius.circular(25),
        child: Container(
          decoration: BoxDecoration(
            color: _isTapped[index]?AppColors.newUpdateColor:Colors.white,
            // gradient: LinearGradient(
            //   colors: _isTapped[index]
            //       ? AppColors.Gradient1 // Red gradient when pressed
            //       : [
            //     Colors.white,
            //     Colors.white
            //   ], // White background when not pressed
            // ),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
                color: AppColors.newUpdateColor,
                width: 2), // Keep your original border color
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/svgIcon/addCustomer.svg',//just change my image with your image
                  color: _isTapped[index] ?Colors.white:AppColors.newUpdateColor,
                  width: 39,
                  height: 37,

                ),
                const SizedBox(height: 0),
                Text(
                  softWrap: true,
                  textAlign: TextAlign.center,
                  label,
                  maxLines: 2,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color:
                    _isTapped[index] ? Colors.white : AppColors.newUpdateColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildCustomGridItem1(String label, Widget icon, int index) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isTapped[index] = true; // Set tapped state
        });
      },
      onTapUp: (_) {
        // Reset tapped state after a brief delay
        Future.delayed(const Duration(milliseconds: 100), () {
          setState(() {
            _isTapped[index] = false; // Reset tapped state
          });
          // Navigate to the corresponding page
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddCustomer(locale: widget.locale,) // tailor page (new route will be added)
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                   ActiveDress(locale: widget.locale,) // navigate to active dress page
              ),
            );
          }
        });
      },
      onTapCancel: () {
        setState(() {
          _isTapped[index] = false; // Reset tapped state on cancel
        });
      },
      child: Material(
        elevation: 8,
        shadowColor: Colors.black.withOpacity(1.0),
        borderRadius: BorderRadius.circular(25),
        child: Container(
          decoration: BoxDecoration(
            color: _isTapped[index]?AppColors.newUpdateColor:Colors.white,
            // gradient: LinearGradient(
            //   colors: _isTapped[index]
            //       ? AppColors.Gradient1 // Red gradient when pressed
            //       : [
            //     Colors.white,
            //     Colors.white
            //   ], // White background when not pressed
            // ),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
                color: AppColors.newUpdateColor,
                width: 2), // Keep your original border color
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/svgIcon/dress.svg',//just change my image with your image
                  color: _isTapped[index] ? Colors.white : AppColors.newUpdateColor,
                  width: 20,
                  height: 40,
                ),
                const SizedBox(height: 0),
                Text(
                  textAlign: TextAlign.center,
                  label,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color:
                    _isTapped[index] ? Colors.white : AppColors.newUpdateColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildCustomGridItem2(String label, Widget icon, int index) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isTapped[index] = true; // Set tapped state
        });
      },
      onTapUp: (_) {
        // Reset tapped state after a brief delay
        Future.delayed(const Duration(milliseconds: 100), () {
          setState(() {
            _isTapped[index] = false; // Reset tapped state
          });
          // Navigate to the corresponding page
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddCustomer(locale: widget.locale,) // tailor page (new route will be added)
              ),
            );
          } else if(index == 1){
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ActiveDress(locale: widget.locale,) // navigate to active dress page
              ),
            );
          }else if(index == 2){
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CustomerOutstandingBalance(locale: widget.locale,) // navigate to active dress page
              ),
            );
          }
        });
      },
      onTapCancel: () {
        setState(() {
          _isTapped[index] = false; // Reset tapped state on cancel
        });
      },
      child: Material(
        elevation: 8,
        shadowColor: Colors.black.withOpacity(1.0),
        borderRadius: BorderRadius.circular(25),
        child: Container(
          decoration: BoxDecoration(
            color: _isTapped[index]?AppColors.newUpdateColor:Colors.white,
            // gradient: LinearGradient(
            //   colors: _isTapped[index]
            //       ? AppColors.Gradient1 // Red gradient when pressed
            //       : [
            //     Colors.white,
            //     Colors.white
            //   ], // White background when not pressed
            // ),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
                color: AppColors.newUpdateColor,
                width: 2), // Keep your original border color
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/svgIcon/out_standing_balance.svg',//just change my image with your image
                  color: _isTapped[index] ?Colors.white:AppColors.newUpdateColor,
                  width: 20,
                  height: 40,
                ),
                const SizedBox(height: 0),
                Text(
                  textAlign: TextAlign.center,
                  label,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color:
                    _isTapped[index] ?Colors.white:AppColors.newUpdateColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildCustomGridItem3(String label, Widget icon, int index) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isTapped[index] = true; // Set tapped state
        });
      },
      onTapUp: (_) {
        // Reset tapped state after a brief delay
        Future.delayed(const Duration(milliseconds: 100), () {
          setState(() {
            _isTapped[index] = false; // Reset tapped state
          });
          // Navigate to the corresponding page
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddCustomer(locale: widget.locale,) // tailor page (new route will be added)
              ),
            );
          } else if(index == 1){
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ActiveDress(locale: widget.locale,) // navigate to active dress page
              ),
            );
          }else if(index == 2){
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CustomerOutstandingBalance(locale: widget.locale,) // navigate to active dress page
              ),
            );
          }else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      TailorReport(locale: widget.locale,) // navigate to active dress page
              ),
            );
          }
        });
      },
      onTapCancel: () {
        setState(() {
          _isTapped[index] = false; // Reset tapped state on cancel
        });
      },
      child: Material(
        elevation: 8,
        shadowColor: Colors.black.withOpacity(1.0),
        borderRadius: BorderRadius.circular(25),
        child: Container(
          decoration: BoxDecoration(
            color: _isTapped[index]?AppColors.newUpdateColor:Colors.white,
            // gradient: LinearGradient(
            //   colors: _isTapped[index]
            //       ? AppColors.Gradient1 // Red gradient when pressed
            //       : [
            //     Colors.white,
            //     Colors.white
            //   ], // White background when not pressed
            // ),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
                color: AppColors.newUpdateColor,
                width: 2), // Keep your original border color
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              SvgPicture.asset(
              'assets/svgIcon/report.svg',//just change my image with your image
                  color: _isTapped[index] ? Colors.white : AppColors.newUpdateColor,
                  width: 20,
                  height: 40,
                ),
                const SizedBox(height: 0),
                Text(
                  textAlign: TextAlign.center,
                  label,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color:
                    _isTapped[index] ? Colors.white : AppColors.newUpdateColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showAlertDialog(BuildContext context,
      {required Locale locale, required Function(Locale) onChangeLanguage}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Container(
            margin: const EdgeInsets.only(left: 16),
            child: Text(
              AppLocalizations.of(context)!.logOutConfirmation,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  fontSize: 20),
            ),
          ),
          content: Container(
            child: Text(
              AppLocalizations.of(context)!.logOutConfirmationMessage,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Colors.grey),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                      onPressed: () async {
                        SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                        await prefs.remove("userId");
                        await prefs.remove('userMobileNumber');
                        await prefs.remove('phoneNumber');
                        await prefs.remove("userToken");
                        await prefs.remove("userType");
                        await prefs.remove("selectedLanguage");
                        await prefs.remove("deviceToken");
                        await prefs.clear();

                        // print("SharedPreference value are $prefs");
                        await Future.delayed(const Duration(seconds: 2));
                        navigatorKey.currentState?.pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomePage(onChangeLanguage: onChangeLanguage)),
                              (route) => false, // Remove all previous routes
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.yesMessage,
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20,),
                SizedBox(
                  height: 47,
                  width: 100,
                  child: Card(
                    color: Colors.white,
                    elevation: 4,
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false); // Close the dialog
                      },
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: TextStyle(fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: AppColors.newUpdateColor),
                      ),
                    ),
                  ),
                ),

              ],
            )
          ],
        );
      },
    );
  }
}

