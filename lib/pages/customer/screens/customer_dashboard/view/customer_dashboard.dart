// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:darzi/apiData/call_api_service/call_service.dart';
// import 'package:darzi/apiData/model/customer_favourite_response_model.dart';
// import 'package:darzi/apiData/model/get_current_customer_list_details_model.dart';
// import 'package:darzi/colors.dart';
// import 'package:darzi/common/widgets/tailor/common_app_bar.dart';
// import 'package:darzi/pages/customer/screens/Customer_Otp_Verification/view/customer_otp_screen.dart';
// import 'package:darzi/pages/customer/screens/customer_Login/view/customerRegisterPage.dart';
// import 'package:darzi/pages/customer/screens/customer_dashboard/view/my_favourite_tailor.dart';
// import 'package:darzi/pages/customer/screens/customer_dashboard/view/mydresses%20copy.dart';
// import 'package:darzi/pages/customer/screens/customer_dashboard/view/mytailors%20copy.dart';
// import 'package:darzi/pages/customer/screens/customer_notifications/view/customer_notification_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../../../l10n/app_localizations.dart';
//
//
// class CustomerHomeScreen extends StatefulWidget {
//   final Locale locale;
//   const CustomerHomeScreen({super.key, required this.locale});
//
//   @override
//   State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
// }
//
// class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
//   List<CustomerOrder> orderList = [];
//   List<Customer_Favourite_Data> customer_Favourite_Data = [];
//   Favourite_Tailor? favourite_Tailor_Data;
//   final List<bool> _isTapped = [false, false];
//   final int _selectedIndex = 0;
//   int currentIndex = 0; // Track current position
//   bool isLoading = true;
//   final PageController _pageController = PageController(viewportFraction: 0.8);
//   bool isBackArrowTapped = false; // By default, icon color is grey
//
//
//   Future<void> checkAccessTokenAndFetchData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? accessToken = prefs.getString('userToken');
//
//     if (accessToken != null && accessToken.isNotEmpty) {
//       getCustomerFavouriteData();
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//       print('accesstoken is null');
//     }
//   }
//
//   Future<void> checkAccessTokenAndNavigate({
//     required BuildContext context,
//     required Locale locale,
//     required Widget destination,
//   }) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? accessToken = prefs.getString('userToken');
//
//     if (accessToken == null || accessToken.isEmpty) {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             backgroundColor: Colors.white,
//             title: Container(
//               margin: EdgeInsets.only(left: 16),
//               child: Text("Not Registered",
//                 style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Poppins', fontSize: 20),
//               ),
//             ),
//             content: Container(
//               child: Text("You are not registered currently. Please register first.",
//                 style: TextStyle(fontWeight: FontWeight.w400, fontFamily: 'Inter', fontSize: 16, color: Colors.grey),
//               ),
//             ),
//             actions: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     height: 47,
//                     width: 100,
//                     child: Card(
//                       color: Colors.white,
//                       elevation: 4,
//                       shadowColor: Colors.grey,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         side: BorderSide(color: AppColors.newUpdateColor, width: 1.5),
//                       ),
//                       child: TextButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                         child: Text("Cancel",
//                           style: TextStyle(
//                             fontFamily: 'Inter',
//                             fontWeight: FontWeight.w600,
//                             fontSize: 18,
//                             color: AppColors.newUpdateColor,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 20),
//                   SizedBox(
//                     height: 47,
//                     width: 110,
//                     child: Card(
//                       color: AppColors.newUpdateColor,
//                       elevation: 4,
//                       shadowColor: Colors.grey,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: TextButton(
//                         onPressed: () {
//                           Navigator.of(context).pop(); // Close popup
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => CustomerregisterpagePage(locale: locale),
//                             ),
//                           ).then((value) {
//                             checkAccessTokenAndFetchData();
//                           });
//                         },
//                         child: Text("Continue",
//                           style: TextStyle(
//                             fontFamily: 'Inter',
//                             fontWeight: FontWeight.w600,
//                             fontSize: 18,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           );
//         },
//       );
//     } else {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => destination),
//       );
//     }
//   }
//
//
//   @override
//   void initState() {
//     super.initState();
//     checkAccessTokenAndFetchData(); // Only fetch if token exists
//
//     _pageController.addListener(() {
//       int newIndex = _pageController.page!.round();
//       if (newIndex != currentIndex) {
//         setState(() {
//           currentIndex = newIndex;
//         });
//       }
//     });
//   }
//
//
//   // Function to update state
//   void updateBackArrowColor(int index) {
//     setState(() {
//       currentIndex = index;
//     });
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double spotlightWidth = screenWidth * 0.9;
//     return Scaffold(
//       extendBody: true,
//       backgroundColor: Colors.white,
//       appBar: CustomAppBar(
//           title: AppLocalizations.of(context)!.appHome,
//           hasBackButton: true,
//           elevation: 2.0,
//           leadingIcon: SvgPicture.asset(
//             'assets/svgIcon/home.svg',
//             allowDrawingOutsideViewBox: true,
//           ),
//         onNotificationTap: () {
//           checkAccessTokenAndNavigate(
//             context: context,
//             locale: widget.locale,
//             destination: CustomerNotificationScreen(locale: widget.locale),
//           );
//         },
//       ),
//
//       body: isLoading == true?Center(
//       child: CircularProgressIndicator(color: AppColors.newUpdateColor,))
//         :Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             const SizedBox(height: 60),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _buildCustomGridItem(
//                     AppLocalizations.of(context)!.myTailor,
//                     SvgPicture.asset(
//                       'assets/svgIcon/myTailor.svg',
//                       color: AppColors.newUpdateColor,
//                     ),
//                     0),
//                 _buildCustomGridItem1(
//                     AppLocalizations.of(context)!.myDresses,
//                     SvgPicture.asset(
//                       'assets/svgIcon/dress.svg',
//                       color: AppColors.newUpdateColor,
//                     ),
//                     1),
//               ],
//             ),
//             Visibility(
//               visible: customer_Favourite_Data.isNotEmpty,
//               child: Column(
//                 children: [
//                   Container(
//                       margin: EdgeInsets.only(top: 40, left: 10),
//                       width: double.infinity,
//                       child: Text(AppLocalizations.of(context)!.my_favourites,
//                           style:
//                           TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: AppColors.newUpdateColor))),
//                   SizedBox(
//                     height:
//                     MediaQuery.of(context).size.height * .16, // Height of cards
//                     child: ListView.builder(
//                       controller: _pageController,
//                       scrollDirection: Axis.horizontal,
//                       itemCount: customer_Favourite_Data.length,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 5),
//                           child: GestureDetector(
//                             onTap: (){
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => MyFavouriteTailorDetails(
//                                       locale: widget
//                                           .locale,tailorId: customer_Favourite_Data[index].tailor!.id.toString(),) // tailor page (new route will be added)
//                                 ),
//                               );
//                             },
//                             child: Container(
//                               width: MediaQuery.of(context).size.width *
//                                   0.43, // Adjust width to fit 2 cards in screen
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(15),
//                                 boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
//                               ),
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(15),
//                                 child: Stack(
//                                   children: [
//                                     CachedNetworkImage(
//                                       fit: BoxFit.cover,
//                                       width: double.infinity,
//                                       height: double.infinity,
//                                       imageUrl: customer_Favourite_Data[index].tailor!.profileUrl.toString(),
//                                       errorWidget: (context, url,
//                                           error) =>
//                                           Stack(
//                                             alignment: Alignment.center,
//                                             children: [
//                                               Image.network(
//                                                 'https://dummyimage.com/500x500/aaa/000000.png&text=',
//                                                 fit: BoxFit.cover,
//                                                 width: double.infinity,
//                                                 height: double.infinity,
//                                               ),
//                                               Text(
//                                                 "No Image Available",
//                                                 style: TextStyle(
//                                                   color: Colors.white,  // 🎨 यहाँ अपना मनचाहा रंग दें
//                                                   fontSize: 18,
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                     ),
//                                     Container(
//                                       decoration: BoxDecoration(
//                                         gradient: LinearGradient(
//                                           begin: Alignment.bottomCenter,
//                                           end: Alignment.topCenter,
//                                           colors: [Colors.black.withOpacity(0.6), Colors.transparent],
//                                         ),
//                                       ),
//                                     ),
//                                     Positioned(
//                                       bottom: 15,
//                                       left: 10,
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Text(customer_Favourite_Data[index].tailor!.name??AppLocalizations.of(
//                                               context)!
//                                               .noUserName,
//                                               style: TextStyle(
//                                                   fontFamily: 'Poppins',
//                                                   color: Colors.white,
//                                                   fontSize: 15,
//                                                   fontWeight: FontWeight.w500)),
//                                           Row(
//                                             children: [
//                                               Icon(Icons.location_on, color: AppColors.newUpdateColor, size: 14),
//                                               SizedBox(width: 5),
//                                               Text(customer_Favourite_Data[index].tailor!.address??AppLocalizations.of(
//                                                   context)!
//                                                   .userNoAddress,
//                                                   style:
//                                                   TextStyle(fontFamily: 'Poppins',
//                                                       color: Colors.white,
//                                                       fontSize: 10,
//                                                       fontWeight: FontWeight.w400)),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       IconButton(
//                         onPressed: () {
//                           if (currentIndex > 0) {
//                             _pageController.previousPage(
//                               duration: const Duration(milliseconds: 500),
//                               curve: Curves.ease,
//                             );
//                           }
//                         },
//                         icon: SvgPicture.asset(
//                           'assets/svgIcon/back_arrow.svg',
//                           color:
//                           currentIndex == 0 ? Colors.grey : AppColors.newUpdateColor,
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () {
//                           if (currentIndex < customer_Favourite_Data.length - 1) {
//                             _pageController.nextPage(
//                               duration: const Duration(milliseconds: 500),
//                               curve: Curves.ease,
//                             );
//                           } // Increase index
//                         },
//                         icon: SvgPicture.asset('assets/svgIcon/forward_arrow.svg'),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCustomGridItem(String label, Widget icon, int index) {
//     return GestureDetector(
//       onTapDown: (_) {
//         setState(() {
//           _isTapped[index] = true; // Set tapped state
//         });
//       },
//       onTapUp: (_) {
//         // Reset tapped state after a brief delay
//         Future.delayed(const Duration(milliseconds: 100), () async {
//           setState(() {
//             _isTapped[index] = false;
//           });
//
//           bool isAllowed = await isAccessTokenAvailable(context);
//           if (!isAllowed) return;
//
//           // Your existing navigation logic here
//           if (index == 0) {
//             final result = await Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => MyTailors(locale: widget.locale)),
//             );
//             if (result == true) {
//               setState(() {
//                 getCustomerFavouriteData();
//               });
//             }
//           } else {
//             final result = await Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => MyDresses(locale: widget.locale)),
//             );
//             if (result == true) {
//               setState(() {
//                 getCustomerFavouriteData();
//               });
//             }
//           }
//         });
//
//       },
//       onTapCancel: () {
//         setState(() {
//           _isTapped[index] = false; // Reset tapped state on cancel
//         });
//       },
//       child: Material(
//         elevation: 8,
//         shadowColor: Colors.black.withOpacity(1.0),
//         borderRadius: BorderRadius.circular(25),
//         child: Container(
//           height: MediaQuery.of(context).size.height * .15,
//           width: MediaQuery.of(context).size.width * .4,
//           decoration: BoxDecoration(
//             color: _isTapped[index]?AppColors.newUpdateColor:Colors.white,
//             // gradient: LinearGradient(
//             //   colors: _isTapped[index]
//             //       ? AppColors.Gradient1 // Red gradient when pressed
//             //       : [
//             //           Colors.white,
//             //           Colors.white
//             //         ], // White background when not pressed
//             // ),
//             borderRadius: BorderRadius.circular(25),
//             border: Border.all(
//                 color: AppColors.newUpdateColor,
//                 width: 2), // Keep your original border color
//           ),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SvgPicture.asset(
//                   'assets/svgIcon/myTailor.svg', //just change my image with your image
//                   color: _isTapped[index] ? Colors.white : AppColors.newUpdateColor,
//                   width: 39,
//                   height: 37,
//                 ),
//                 const SizedBox(height: 0),
//                 Text(
//                   softWrap: true,
//                   textAlign: TextAlign.center,
//                   label,
//                   maxLines: 2,
//                   style: TextStyle(
//                     fontFamily: 'Poppins',
//                     fontSize: 12,
//                     color:
//                         _isTapped[index] ? Colors.white : AppColors.newUpdateColor,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCustomGridItem1(String label, Widget icon, int index) {
//     return GestureDetector(
//       onTapDown: (_) {
//         setState(() {
//           _isTapped[index] = true; // Set tapped state
//         });
//       },
//       onTapUp: (_) {
//
//         Future.delayed(const Duration(milliseconds: 100), () async {
//           setState(() {
//             _isTapped[index] = false;
//           });
//
//           bool isAllowed = await isAccessTokenAvailable(context);
//           if (!isAllowed) return;
//
//           if (index == 0) {
//             final result = await Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => MyTailors(locale: widget.locale)),
//             );
//             if (result == true) {
//               setState(() {
//                 getCustomerFavouriteData();
//               });
//             }
//           } else {
//             final result = await Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => MyDresses(locale: widget.locale)),
//             );
//             if (result == true) {
//               setState(() {
//                 getCustomerFavouriteData();
//               });
//             }
//           }
//         });
//
//       },
//       onTapCancel: () {
//         setState(() {
//           _isTapped[index] = false; // Reset tapped state on cancel
//         });
//       },
//       child: Material(
//         elevation: 8,
//         shadowColor: Colors.black.withOpacity(1.0),
//         borderRadius: BorderRadius.circular(25),
//         child: Container(
//           height: MediaQuery.of(context).size.height * .15,
//           width: MediaQuery.of(context).size.width * .4,
//           decoration: BoxDecoration(
//             color: _isTapped[index]?AppColors.newUpdateColor:Colors.white,
//             borderRadius: BorderRadius.circular(25),
//             border: Border.all(
//                 color: AppColors.newUpdateColor,
//                 width: 2), // Keep your original border color
//           ),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SvgPicture.asset(
//                   'assets/svgIcon/dress.svg', //just change my image with your image
//                   color: _isTapped[index] ? Colors.white : AppColors.newUpdateColor,
//                   width: 20,
//                   height: 40,
//                 ),
//                 const SizedBox(height: 0),
//                 Text(
//                   textAlign: TextAlign.center,
//                   label,
//                   style: TextStyle(
//                     fontFamily: 'Poppins',
//                     fontSize: 12,
//                     color:
//                         _isTapped[index] ? Colors.white : AppColors.newUpdateColor,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void getCustomerFavouriteData() {
//     setState(() {
//       isLoading = true;
//       WidgetsBinding.instance.addPostFrameCallback((_) async {
//         Customer_Favourites_Response_Model model =
//         await CallService().getMyFavourite_TailorList();
//         setState(() {
//           isLoading = false;
//           customer_Favourite_Data = model.data!;
//           print("Favourite Data Value is: ${customer_Favourite_Data.length}");
//         });
//       });
//     });
//   }
//
//   Future<bool> isAccessTokenAvailable(BuildContext context) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? accessToken = prefs.getString('userToken');
//
//     if (accessToken == null || accessToken.isEmpty) {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog (
//             backgroundColor: Colors.white,
//             title: Container(
//                 margin: EdgeInsets.only(left: 16),
//                 child: Text("Not Registered",
//                   style: TextStyle(fontWeight: FontWeight.w600,fontFamily: 'Poppins',fontSize: 20),)),
//             content:  Container(child: Text("You are not registered currently. Please register first.",
//                 style: TextStyle(fontWeight: FontWeight.w400,fontFamily: 'Inter',fontSize: 16,color: Colors.grey))),
//             actions: [
//               Container(
//                 child: Row(mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         height: 47,
//                         width: 100,
//                         child: Card(
//                           color: Colors.white,
//                           elevation: 4,
//                           shadowColor: Colors.grey,
//                           shape: RoundedRectangleBorder(
//                             borderRadius:
//                             BorderRadius.circular(8),
//                             side: BorderSide(color: AppColors.newUpdateColor, width: 1.5),
//                           ),
//                           child: TextButton(
//                             onPressed: () {
//                               Navigator.of(context).pop(false); // Close the dialog
//                             },
//                             child: Text(
//                               AppLocalizations.of(context)!.cancel,
//                               style: TextStyle(
//                                   fontFamily: 'Inter',
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 18,
//                                   color: AppColors.newUpdateColor), // Styled like in the 3rd function
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 20,),
//                       SizedBox(
//                         height: 47,
//                         width: 110,
//                         child: Card(
//                           color: AppColors.newUpdateColor,
//                           elevation: 4,
//                           shadowColor: Colors.grey,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: TextButton(
//                             style:
//                             ElevatedButton.styleFrom(
//                                 backgroundColor: AppColors.newUpdateColor),
//                             onPressed: () {
//                               // Navigator.pushReplacement(
//                               //   context,
//                               //   MaterialPageRoute(builder: (context) =>
//                               //       CustomerregisterpagePage(locale: widget.locale)),
//                               // );
//                               Navigator.pushReplacement(
//                                 context,
//                                 MaterialPageRoute(builder: (context) => CustomerregisterpagePage(locale: widget.locale)),
//                               ).then((value) {
//                                 checkAccessTokenAndFetchData();
//                               });
//
//                             },
//                             child:  Text("Continue",
//                               style: TextStyle(
//                                   fontFamily: 'Inter',
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 18,
//                                   color:
//                                   Colors.white), // Styled like in the 3rd function
//                             ),
//                           ),
//                         ),
//                       ),
//                     ]),
//               ),
//             ],
//           );
//         },
//       );
//       return false;
//     }
//     return true;
//   }
//
// }
import 'package:cached_network_image/cached_network_image.dart';
import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/apiData/model/customer_favourite_response_model.dart';
import 'package:darzi/apiData/model/get_current_customer_list_details_model.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/common/widgets/tailor/common_app_bar.dart';
import 'package:darzi/pages/customer/screens/Customer_Otp_Verification/view/customer_otp_screen.dart';
import 'package:darzi/pages/customer/screens/customer_Login/view/customerRegisterPage.dart';
import 'package:darzi/pages/customer/screens/customer_dashboard/view/my_favourite_tailor.dart';
import 'package:darzi/pages/customer/screens/customer_dashboard/view/mydresses%20copy.dart';
import 'package:darzi/pages/customer/screens/customer_dashboard/view/mytailors%20copy.dart';
import 'package:darzi/pages/customer/screens/customer_notifications/view/customer_notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../l10n/app_localizations.dart';


class CustomerHomeScreen extends StatefulWidget {
  final Locale locale;
  const CustomerHomeScreen({super.key, required this.locale});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  List<CustomerOrder> orderList = [];
  List<Customer_Favourite_Data> customer_Favourite_Data = [];
  Favourite_Tailor? favourite_Tailor_Data;
  final List<bool> _isTapped = [false, false];
  final int _selectedIndex = 0;
  int currentIndex = 0; // Track current position
  bool isLoading = true;
  final PageController _pageController = PageController(viewportFraction: 0.8);
  bool isBackArrowTapped = false; // By default, icon color is grey
  String userName = "", userAddress = "";
  String?userProfile;

  // Common method for access token check and navigation
  Future<bool> checkAccessTokenAndShowPopup({
    bool showPopup = true,
    Widget? destination,
    bool shouldNavigate = false,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');

    if (accessToken == null || accessToken.isEmpty) {
      if (showPopup) {
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
                          child: Text(shouldNavigate ? AppLocalizations.of(context)!.cancel : "Cancel",
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
                                builder: (context) => CustomerregisterpagePage(locale: widget.locale),
                              ),
                            ).then((value) {
                              checkAccessTokenAndFetchData();
                            });
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
      return false;
    } else {
      // If access token exists and navigation is required
      if (shouldNavigate && destination != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => destination),
        );
      }
      return true;
    }
  }

  Future<void> checkAccessTokenAndFetchData() async {
    bool hasToken = await checkAccessTokenAndShowPopup(showPopup: false);

    if (hasToken) {
      getCustomerFavouriteData();
    } else {
      setState(() {
        isLoading = false;
      });
      print('accesstoken is null');
    }
  }

  @override
  void initState() {
    super.initState();
    checkAccessTokenAndFetchData(); // Only fetch if token exists
    getSharedPrefenceValue();
    _pageController.addListener(() {
      int newIndex = _pageController.page!.round();
      if (newIndex != currentIndex) {
        setState(() {
          currentIndex = newIndex;
        });
      }
    });
  }

  // Function to update state
  void updateBackArrowColor(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double spotlightWidth = screenWidth * 0.9;
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,

      body: isLoading == true
          ? Center(
        child: CircularProgressIndicator(
          color: AppColors.newUpdateColor,
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 60),

            /// 🔹 Welcome + Location + Profile Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    userName.isNotEmpty?Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ):Text(
                      AppLocalizations.of(context)!.welcome,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    userAddress.isNotEmpty?Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: AppColors.newUpdateColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          userAddress,
                          style: TextStyle(
                            color: AppColors.newUpdateColor,
                          ),
                        )
                      ],
                    ):SizedBox(),
                  ],
                ),

                /// 🔹 Notification + Profile
                Row(
                  children: [
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            print("Bell tapped!");
                            checkAccessTokenAndShowPopup(
                              destination: CustomerNotificationScreen(
                                locale: widget.locale,
                              ),
                              shouldNavigate: true,
                            );
                          },
                          child: const Icon(
                            Icons.notifications_none,
                            size: 28,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(width: 12),
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: (userProfile != null &&
                          userProfile!.isNotEmpty)
                          ? NetworkImage(userProfile!)
                          : AssetImage('assets/images/tailorProfile.png') as ImageProvider,
                    )
                  ],
                )
              ],
            ),

            const SizedBox(height: 30),

            /// 🔹 Grid Items
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount:
                MediaQuery.of(context).size.width > 600 ? 3 : 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.4,
                children: [
                  _buildCustomGridItem(
                    AppLocalizations.of(context)!.myTailor,
                    SvgPicture.asset(
                      'assets/svgIcon/abcd.svg',
                      color: Colors.black,
                    ),
                    0,
                  ),
                  _buildCustomGridItem1(
                    AppLocalizations.of(context)!.myDresses,
                    SvgPicture.asset(
                      'assets/svgIcon/active_dress.svg',
                      color: Colors.black,
                    ),
                    1,
                  ),
                ],
              ),
            ),

            /// 🔹 My Favourites Section
            Visibility(
              visible: customer_Favourite_Data.isNotEmpty,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 40, left: 10),
                    width: double.infinity,
                    child: Text(
                      AppLocalizations.of(context)!.my_favourites,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.newUpdateColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .16,
                    child: ListView.builder(
                      controller: _pageController,
                      scrollDirection: Axis.horizontal,
                      itemCount: customer_Favourite_Data.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 5),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MyFavouriteTailorDetails(
                                        locale: widget.locale,
                                        tailorId: customer_Favourite_Data[index]
                                            .tailor!
                                            .id
                                            .toString(),
                                      ),
                                ),
                              );
                            },
                            child: Container(
                              width:
                              MediaQuery.of(context).size.width * 0.43,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                  )
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Stack(
                                  children: [
                                    CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                      imageUrl:
                                      customer_Favourite_Data[index]
                                          .tailor!
                                          .profileUrl
                                          .toString(),
                                      errorWidget:
                                          (context, url, error) => Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Image.network(
                                            'https://dummyimage.com/500x500/aaa/000000.png&text=',
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                          const Text(
                                            "No Image Available",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.black.withOpacity(0.6),
                                            Colors.transparent
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 15,
                                      left: 10,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            customer_Favourite_Data[index]
                                                .tailor!
                                                .name ??
                                                AppLocalizations.of(
                                                    context)!
                                                    .noUserName,
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.location_on,
                                                color: AppColors
                                                    .newUpdateColor,
                                                size: 14,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                customer_Favourite_Data[
                                                index]
                                                    .tailor!
                                                    .address ??
                                                    AppLocalizations.of(
                                                        context)!
                                                        .userNoAddress,
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight:
                                                  FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (currentIndex > 0) {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
                          }
                        },
                        icon: SvgPicture.asset(
                          'assets/svgIcon/back_arrow.svg',
                          color: currentIndex == 0
                              ? Colors.grey
                              : AppColors.newUpdateColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (currentIndex <
                              customer_Favourite_Data.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
                          }
                        },
                        icon: SvgPicture.asset(
                          'assets/svgIcon/forward_arrow.svg',
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


  // Widget _buildCustomGridItem(String label, Widget icon, int index) {
  //   return GestureDetector(
  //     onTapDown: (_) {
  //       setState(() {
  //         _isTapped[index] = true; // Set tapped state
  //       });
  //     },
  //     onTapUp: (_) {
  //       // Reset tapped state after a brief delay
  //       Future.delayed(const Duration(milliseconds: 100), () async {
  //         setState(() {
  //           _isTapped[index] = false;
  //         });
  //
  //         bool isAllowed = await checkAccessTokenAndShowPopup();
  //         if (!isAllowed) return;
  //
  //         // Your existing navigation logic here
  //         if (index == 0) {
  //           final result = await Navigator.push(
  //             context,
  //             MaterialPageRoute(builder: (context) => MyTailors(locale: widget.locale)),
  //           );
  //           if (result == true) {
  //             setState(() {
  //               getCustomerFavouriteData();
  //             });
  //           }
  //         } else {
  //           final result = await Navigator.push(
  //             context,
  //             MaterialPageRoute(builder: (context) => MyDresses(locale: widget.locale)),
  //           );
  //           if (result == true) {
  //             setState(() {
  //               getCustomerFavouriteData();
  //             });
  //           }
  //         }
  //       });
  //
  //     },
  //     onTapCancel: () {
  //       setState(() {
  //         _isTapped[index] = false; // Reset tapped state on cancel
  //       });
  //     },
  //     child: Material(
  //       elevation: 8,
  //       shadowColor: Colors.black.withOpacity(1.0),
  //       borderRadius: BorderRadius.circular(25),
  //       child: Container(
  //         height: MediaQuery.of(context).size.height * .15,
  //         width: MediaQuery.of(context).size.width * .4,
  //         decoration: BoxDecoration(
  //           color: _isTapped[index]?AppColors.newUpdateColor:Colors.white,
  //           // gradient: LinearGradient(
  //           //   colors: _isTapped[index]
  //           //       ? AppColors.Gradient1 // Red gradient when pressed
  //           //       : [
  //           //           Colors.white,
  //           //           Colors.white
  //           //         ], // White background when not pressed
  //           // ),
  //           borderRadius: BorderRadius.circular(25),
  //           border: Border.all(
  //               color: AppColors.newUpdateColor,
  //               width: 2), // Keep your original border color
  //         ),
  //         child: Center(
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               SvgPicture.asset(
  //                 'assets/svgIcon/myTailor.svg', //just change my image with your image
  //                 color: _isTapped[index] ? Colors.white : AppColors.newUpdateColor,
  //                 width: 39,
  //                 height: 37,
  //               ),
  //               const SizedBox(height: 0),
  //               Text(
  //                 softWrap: true,
  //                 textAlign: TextAlign.center,
  //                 label,
  //                 maxLines: 2,
  //                 style: TextStyle(
  //                   fontFamily: 'Poppins',
  //                   fontSize: 12,
  //                   color:
  //                   _isTapped[index] ? Colors.white : AppColors.newUpdateColor,
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildCustomGridItem1(String label, Widget icon, int index) {
  //   return GestureDetector(
  //     onTapDown: (_) {
  //       setState(() {
  //         _isTapped[index] = true; // Set tapped state
  //       });
  //     },
  //     onTapUp: (_) {
  //
  //       Future.delayed(const Duration(milliseconds: 100), () async {
  //         setState(() {
  //           _isTapped[index] = false;
  //         });
  //
  //         bool isAllowed = await checkAccessTokenAndShowPopup();
  //         if (!isAllowed) return;
  //
  //         if (index == 0) {
  //           final result = await Navigator.push(
  //             context,
  //             MaterialPageRoute(builder: (context) => MyTailors(locale: widget.locale)),
  //           );
  //           if (result == true) {
  //             setState(() {
  //               getCustomerFavouriteData();
  //             });
  //           }
  //         } else {
  //           final result = await Navigator.push(
  //             context,
  //             MaterialPageRoute(builder: (context) => MyDresses(locale: widget.locale)),
  //           );
  //           if (result == true) {
  //             setState(() {
  //               getCustomerFavouriteData();
  //             });
  //           }
  //         }
  //       });
  //
  //     },
  //     onTapCancel: () {
  //       setState(() {
  //         _isTapped[index] = false; // Reset tapped state on cancel
  //       });
  //     },
  //     child: Material(
  //       elevation: 8,
  //       shadowColor: Colors.black.withOpacity(1.0),
  //       borderRadius: BorderRadius.circular(25),
  //       child: Container(
  //         height: MediaQuery.of(context).size.height * .15,
  //         width: MediaQuery.of(context).size.width * .4,
  //         decoration: BoxDecoration(
  //           color: _isTapped[index]?AppColors.newUpdateColor:Colors.white,
  //           borderRadius: BorderRadius.circular(25),
  //           border: Border.all(
  //               color: AppColors.newUpdateColor,
  //               width: 2), // Keep your original border color
  //         ),
  //         child: Center(
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               SvgPicture.asset(
  //                 'assets/svgIcon/dress.svg', //just change my image with your image
  //                 color: _isTapped[index] ? Colors.white : AppColors.newUpdateColor,
  //                 width: 20,
  //                 height: 40,
  //               ),
  //               const SizedBox(height: 0),
  //               Text(
  //                 textAlign: TextAlign.center,
  //                 label,
  //                 style: TextStyle(
  //                   fontFamily: 'Poppins',
  //                   fontSize: 12,
  //                   color:
  //                   _isTapped[index] ? Colors.white : AppColors.newUpdateColor,
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildCustomGridItem(String label, Widget icon, int index) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isTapped[index] = true;
        });
      },
      onTapUp: (_) {
              // Reset tapped state after a brief delay
              Future.delayed(const Duration(milliseconds: 100), () async {
                setState(() {
                  _isTapped[index] = false;
                });

                bool isAllowed = await checkAccessTokenAndShowPopup();
                if (!isAllowed) return;

                // Your existing navigation logic here
                if (index == 0) {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyTailors(locale: widget.locale)),
                  );
                  if (result == true) {
                    setState(() {
                      getCustomerFavouriteData();
                    });
                  }
                } else {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyDresses(locale: widget.locale)),
                  );
                  if (result == true) {
                    setState(() {
                      getCustomerFavouriteData();
                    });
                  }
                }
              });
      },
      onTapCancel: () {
        setState(() {
          _isTapped[index] = false;
        });
      },
      child: Material(
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.newUpdateColor,
              width: 1.5,
            ),
          ),
          child: Stack(
            children: [
              // ---- Top Center Text ----
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.newUpdateColor,
                    ),
                  ),
                ),
              ),

              // ---- Bottom Right Icon/Image ----
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 6, bottom: 6),
                  child: SvgPicture.asset(
                    "assets/svgIcon/abcd.svg", // आपका icon/image path
                    height: 70,
                    fit: BoxFit.contain,
                    //color: AppColors.newUpdateColor,
                  ),
                ),
              ),
            ],
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

          Future.delayed(const Duration(milliseconds: 100), () async {
            setState(() {
              _isTapped[index] = false;
            });

            bool isAllowed = await checkAccessTokenAndShowPopup();
            if (!isAllowed) return;

            if (index == 0) {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyTailors(locale: widget.locale)),
              );
              if (result == true) {
                setState(() {
                  getCustomerFavouriteData();
                });
              }
            } else {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyDresses(locale: widget.locale)),
              );
              if (result == true) {
                setState(() {
                  getCustomerFavouriteData();
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
          shadowColor: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.newUpdateColor,
                width: 1.5,
              ),
            ),
            child: Stack(
              children: [
                // ---- Top Center Text ----
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.newUpdateColor,
                      ),
                    ),
                  ),
                ),

                // ---- Bottom Right Icon/Image ----
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6, bottom: 6),
                    child: SvgPicture.asset(
                      "assets/svgIcon/active_dress.svg", // आपका icon/image path
                      height: 70,
                      fit: BoxFit.contain,
                      //color: AppColors.newUpdateColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      // Material(
      //   elevation: 8,
      //   shadowColor: Colors.black.withOpacity(1.0),
      //   borderRadius: BorderRadius.circular(25),
      //   child: Container(
      //     decoration: BoxDecoration(
      //       color: _isTapped[index]?AppColors.newUpdateColor:Colors.white,
      //       borderRadius: BorderRadius.circular(25),
      //       border: Border.all(
      //           color: AppColors.newUpdateColor,
      //           width: 2), // Keep your original border color
      //     ),
      //     child: Center(
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           SvgPicture.asset(
      //             'assets/svgIcon/dress.svg',//just change my image with your image
      //             color: _isTapped[index] ? Colors.white : AppColors.newUpdateColor,
      //             width: 20,
      //             height: 40,
      //           ),
      //           const SizedBox(height: 0),
      //           Text(
      //             textAlign: TextAlign.center,
      //             label,
      //             style: TextStyle(
      //               fontFamily: 'Poppins',
      //               fontSize: 12,
      //               color:
      //               _isTapped[index] ? Colors.white : AppColors.newUpdateColor,
      //               fontWeight: FontWeight.w600,
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  void getCustomerFavouriteData() {
    setState(() {
      isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Customer_Favourites_Response_Model model =
        await CallService().getMyFavourite_TailorList();
        setState(() {
          isLoading = false;
          customer_Favourite_Data = model.data!;
          print("Favourite Data Value is: ${customer_Favourite_Data.length}");
        });
      });
    });
  }

  Future<void> getSharedPrefenceValue() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      userName = prefs.getString('userName') ?? "";
      userProfile = prefs.getString('userProfile') ?? "";
      userAddress = prefs.getString('userAddress') ?? "";
    });

    print("customer Name is $userName");
    print("customer Profile is $userProfile");
  }

}