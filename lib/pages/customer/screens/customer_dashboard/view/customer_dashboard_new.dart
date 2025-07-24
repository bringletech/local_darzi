// import 'package:darzi/colors.dart';
// import 'package:darzi/common/common_bottom_navigation.dart';
// import 'package:darzi/common/widgets/tab_data.dart';
// import 'package:darzi/pages/customer/screens/customer_Login/view/customerRegisterPage.dart';
// import 'package:darzi/pages/customer/screens/customer_dashboard/view/customer_dashboard.dart';
// import 'package:darzi/pages/customer/screens/customer_profile/view/customer_profile_page.dart';
// import 'package:darzi/pages/customer/screens/customer_search/view/customer_search_page.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// // Import the new routes file
//
// class CustomerDashboardNew extends StatefulWidget {
//   static const TextStyle titleStyle = TextStyle(
//     fontWeight: FontWeight.bold,
//     fontSize: 22,
//     color: Colors.black,
//   );
//
//   final PageController tabController = PageController(initialPage: 1);
//
//   var selectedIndex = 1;
//   final Locale locale;
//
//   CustomerDashboardNew({super.key, required this.locale,});
//
//   @override
//   State<CustomerDashboardNew> createState() => _CustomerDashboardNewState();
// }
//
// class _CustomerDashboardNewState extends State<CustomerDashboardNew> {
//   final bool _isTapped = false;
//   int selectedIndex = 1;
//   String? accessToken;
//   late PageController tabController;
//   Future<void> _loadAccessToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('userToken');
//
//     setState(() {
//       accessToken = token;
//       // If token is null and user tried to access Profile (index 2), reset to Home (index 1)
//       if (token == null && selectedIndex == 2) {
//         selectedIndex = 1;
//         tabController.jumpToPage(selectedIndex);
//       }
//     });
//   }
//   @override
//   void initState() {
//     super.initState();
//     tabController = PageController(initialPage: selectedIndex);
//     _loadAccessToken();
//   }
//   void _onTabChanged(int index) async {
//     if (index == 2 && accessToken == null) {
//       // If user not logged in and tries to open profile, go to Register page
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => CustomerregisterpagePage(locale: widget.locale),
//         ),
//       ); // Update to your actual route
//       return;
//     }
//
//     setState(() {
//       //     (index) {
//       //   setState(() {
//       //     widget.selectedIndex = index;
//       //     widget.tabController.jumpToPage(index);
//       //
//       //     print("index..............    $index");
//       //   });
//       // },
//       widget.selectedIndex = index;
//       widget.tabController.jumpToPage(index);
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       bottomNavigationBar: ClipRRect(
//         borderRadius: const BorderRadius.only(
//           topRight: Radius.circular(24),
//           topLeft: Radius.circular(24),
//         ),
//         child: CircleBottomNavigation(
//           barHeight: 80,
//           circleSize: 65,
//           initialSelection: widget.selectedIndex,
//           activeIconColor: AppColors.newUpdateColor,
//           inactiveIconColor: Colors.white,
//           barBackgroundColor: AppColors.newUpdateColor,
//           textColor: AppColors.newUpdateColor,
//           hasElevationShadows: false,
//           tabs: [
//             TabData(
//               onClick: () {
//
//               },
//               icon: Icons.search,
//               iconSize: 35,
//               title: '',
//               fontSize: 19,
//               fontWeight: FontWeight.bold,
//             ),
//             TabData(
//               onClick: () {
//               },
//               icon: Icons.grid_view,
//               iconSize: 35,
//               title: '',
//               fontSize: 19,
//               fontWeight: FontWeight.bold,
//             ),
//             TabData(
//               onClick: () {
//
//               },
//               icon: Icons.person,
//               iconSize: 35,
//               title: '',
//               fontSize: 19,
//               fontWeight: FontWeight.bold,
//             ),
//
//           ],
//           onTabChangedListener: _onTabChanged,
//
//         ),
//       ),
//       body: PageView(
//         controller: widget.tabController,
//         physics: const NeverScrollableScrollPhysics(),
//         children: <Widget>[
//           Center(
//             child: CustomerSearchPage(locale: widget.locale),
//           ),
//           Center(
//             child: CustomerHomeScreen(locale: widget.locale),
//           ),
//           Center(
//             child: CustomerProfilePage(locale: widget.locale),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:darzi/colors.dart';
import 'package:darzi/common/common_bottom_navigation.dart';
import 'package:darzi/common/widgets/tab_data.dart';
import 'package:darzi/l10n/app_localizations.dart';
import 'package:darzi/pages/customer/screens/customer_Login/view/customerRegisterPage.dart';
import 'package:darzi/pages/customer/screens/customer_dashboard/view/customer_dashboard.dart';
import 'package:darzi/pages/customer/screens/customer_profile/view/customer_profile_page.dart';
import 'package:darzi/pages/customer/screens/customer_search/view/customer_search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerDashboardNew extends StatefulWidget {
  static const TextStyle titleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 22,
    color: Colors.black,
  );

  final PageController tabController = PageController(initialPage: 1);

  var selectedIndex = 1;
  final Locale locale;

  CustomerDashboardNew({super.key, required this.locale,});

  @override
  State<CustomerDashboardNew> createState() => _CustomerDashboardNewState();
}

class _CustomerDashboardNewState extends State<CustomerDashboardNew> {
  bool _isTapped = false;

  // Function to check access token
  Future<bool> _checkAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');

    // Check if token is null or empty
    if (accessToken == null || accessToken.isEmpty) {
      return false;
    }
    return true;
  }

  // Function to show registration popup
  void _showRegistrationPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Container(
            margin: EdgeInsets.only(left: 16),
            child: Text(AppLocalizations.of(context)!.not_registered,
              style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Poppins', fontSize: 20),
            ),
          ),
          content: Container(
            child: Text(AppLocalizations.of(context)!.login_message,
              style: TextStyle(fontWeight: FontWeight.w400, fontFamily: 'Inter', fontSize: 16, color: Colors.grey),
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
                    color: Colors.white,
                    elevation: 4,
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: AppColors.newUpdateColor, width: 1.5),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(AppLocalizations.of(context)!.cancel,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: AppColors.newUpdateColor,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                SizedBox(
                  height: 47,
                  width: 110,
                  child: Card(
                    color: AppColors.newUpdateColor,
                    elevation: 4,
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close popup
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomerregisterpagePage(locale:widget.locale),
                          ),
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.buttonContinue,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // Function to handle tab change with token validation
  Future<void> _handleTabChange(int index) async {
    // If trying to access profile screen (index 2)
    if (index == 2) {
      bool hasValidToken = await _checkAccessToken();

      if (!hasValidToken) {
        // Show popup if no valid token
        _showRegistrationPopup();
        return; // Don't change the tab
      }
    }

    // If token is valid or it's not profile screen, proceed normally
    setState(() {
      widget.selectedIndex = index;
      widget.tabController.jumpToPage(index);
      print("index..............    $index");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(24),
          topLeft: Radius.circular(24),
        ),
        child: CircleBottomNavigation(
          barHeight: 80,
          circleSize: 65,
          initialSelection: widget.selectedIndex,
          activeIconColor: AppColors.newUpdateColor,
          inactiveIconColor: Colors.white,
          barBackgroundColor: AppColors.newUpdateColor,
          textColor: AppColors.newUpdateColor,
          hasElevationShadows: false,
          tabs: [
            TabData(
              onClick: () {
                // Handle search tab click
              },
              icon: Icons.search,
              iconSize: 35,
              title: '',
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
            TabData(
              onClick: () {
                // Handle home tab click
              },
              icon: Icons.grid_view,
              iconSize: 35,
              title: '',
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
            TabData(
              onClick: () {
                // Handle profile tab click with token check
                _handleTabChange(2);
              },
              icon: Icons.person,
              iconSize: 35,
              title: '',
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ],
          onTabChangedListener: (index) {
            _handleTabChange(index);
          },
        ),
      ),
      body: PageView(
        controller: widget.tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          Center(
            child: CustomerSearchPage(locale: widget.locale),
          ),
          Center(
            child: CustomerHomeScreen(locale: widget.locale),
          ),
          Center(
            child: CustomerProfilePage(locale: widget.locale),
          ),
        ],
      ),
    );
  }
}