import 'package:cached_network_image/cached_network_image.dart';
import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/common/widgets/tailor/common_app_bar_search_customer_without_back.dart';
import 'package:darzi/common/widgets/tailor/common_app_bar_with_back.dart';
import 'package:darzi/constants/string_constant.dart';
import 'package:darzi/l10n/app_localizations.dart';
import 'package:darzi/pages/customer/screens/customer_search/view/tailor_full_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:darzi/apiData/model/get_all_tailors_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../customer_dashboard/view/customer_dashboard.dart';

class CustomerSearchPage extends StatefulWidget {
  final Locale locale;
  CustomerSearchPage({super.key, required this.locale});

  @override
  State<CustomerSearchPage> createState() => _CustomerSearchPageState();
}

class _CustomerSearchPageState extends State<CustomerSearchPage> {
  List<Data> filteredTailorList = [];
  List<Data> tailorList = [];
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = true;
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Get_All_Tailors_response_Model model =
            await CallService().getAllTailorsList();
        setState(() {
          isLoading = false;
          tailorList = model.data!;
          filteredTailorList = tailorList;
          _searchController.addListener(_filterContacts);
        });
      });
    });
  }

  Future<void> _loadData() async {
    print('Loading latest data...');
    setState(() {
      isRefreshing = true;
    });

    Get_All_Tailors_response_Model model =
    await CallService().getAllTailorsList();

    print('Loaded Tailors: ${model.data?.length}');
    setState(() {
      isRefreshing = false;
      tailorList = model.data!;
      filteredTailorList = tailorList;
    });
  }


  void _filterContacts() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredTailorList = tailorList.where((Data data) {
        return data.name.toString().toLowerCase().contains(query) ||
            data.mobileNo.toString().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      // Navigate to TailorDashboardNew when device back button is pressed
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => CustomerHomeScreen(
              locale: widget.locale,
            )),
      );
      return false; // Prevent default back behavior
    },child:Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.searchTailor,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true, // 👈 yeh add karo
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: SvgPicture.asset(
            'assets/svgIcon/myTailor.svg',
            color: Colors.black,
          ),
        ),
      ),
      // CustomAppBarSearchCustomerWithOutBack(
      //   title: AppLocalizations.of(context)!.searchTailor,
      //   hasBackButton: true,
      //   elevation: 2.0,
      //   leadingIcon: SvgPicture.asset(
      //     'assets/svgIcon/myTailor.svg',
      //     color: Colors.black,
      //   ),
      // ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppColors.newUpdateColor,
                      width: 1.0,
                      style: BorderStyle.solid),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.mobileOrName,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    suffixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
            ),
            Expanded(
                child: isLoading && !isRefreshing
                    ? Center(
                        child:
                            CircularProgressIndicator(color: AppColors.darkRed),
                      )
                    : filteredTailorList.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/no_results.png",
                                height: 80,
                              ),
                              Center(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .no_customer_found,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: filteredTailorList.length,
                              itemBuilder: (context, index) {
                                final contact = filteredTailorList[index];
                                // customerId = contact.id.toString();
                                return GestureDetector(
                                  onTap: () async {

                                    final shouldRefresh = await
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => TailorFullView(
                                                locale: widget.locale,tailorId: contact.id.toString())));

                                    // 👇👇 Yahan print karo
                                    print('shouldRefresh: $shouldRefresh');

                                    if (shouldRefresh == true) {
                                      // ✅ Refresh this screen
                                      _loadData(); // ya jo bhi API/function chahiye
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3,
                                        horizontal:
                                            15), // 👈 Card ke beech ka space kam kiya
                                    child: Card(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      elevation: 10,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            /// IMAGE VIEW ///
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: SizedBox(
                                                width: 70,
                                                height: 70,
                                                child:
                                                    //Image.network('https://randomuser.me/api/portraits/women/10.jpg',),
                                                    CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  height: 50,
                                                  width: 50,
                                                  imageUrl: contact.profileUrl
                                                      .toString(),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      SvgPicture.asset(
                                                        'assets/svgIcon/profilepic.svg', // Default profile icon
                                                        width: 120,
                                                        height: 120,
                                                      ),
                                                ),
                                              ),
                                            ),

                                            /// CARD DETAIL VIEW ///
                                            const SizedBox(
                                                width:
                                                    8), // 👈 Spacing Between Image and Text Kam Kiya
                                            Expanded(
                                              flex: 5,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    contact.name ??
                                                        AppLocalizations.of(
                                                                context)!
                                                            .noUserName,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      color: Color(0xFF000000),
                                                      fontSize: 19,
                                                      fontFamily: 'Poppins',
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SvgPicture.asset(
                                                        'assets/svgIcon/location.svg',
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          width: MediaQuery.of(context).size.width*0.3,
                                                          child: Text(
                                                            contact.address ??
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .userNoAddress,
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            maxLines: 2,
                                                            style: const TextStyle(
                                                              color:
                                                                  Color(0xFF000000),
                                                              fontSize: 13,
                                                              fontFamily: 'Poppins',
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      RatingBarIndicator(
                                                        rating: contact.avgRating!
                                                            .toDouble(),
                                                        direction:
                                                            Axis.horizontal,
                                                        itemBuilder:
                                                            (context, index) =>
                                                                Icon(
                                                          Icons.star,
                                                          color: AppColors
                                                              .ratingBarColor,
                                                        ),
                                                        itemCount: 5,
                                                        itemSize: 20.0,
                                                        //unratedColor : Colors.blue
                                                      ),
                                                      SizedBox(width: 6),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                                horizontal: 8,
                                                                vertical: 1.5),
                                                        decoration: BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                        ),
                                                        child: Text(
                                                          contact.avgRating != null
                                                              ? contact.avgRating!.toStringAsFixed(1)
                                                              : '0.0',
                                                          style: TextStyle(
                                                              fontFamily: "Inter",
                                                              color: Colors.white,
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                              fontSize: 16),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),

                                            /// ICON BUTTONS ///
                                            contact.hideMobileNo == false?Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    openWhatsApp(
                                                        context,
                                                        contact.mobileNo
                                                            .toString());
                                                  },
                                                  child: Image.asset(
                                                    'assets/images/whatsapp.png',
                                                    width: 28,
                                                    height: 28,
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                                GestureDetector(
                                                  onTap: () {
                                                    _makePhoneCall(
                                                        context,
                                                        contact.mobileNo
                                                            .toString());
                                                  },
                                                  child: SvgPicture.asset(
                                                    'assets/svgIcon/phone_color.svg',
                                                    width: 28,
                                                    height: 28,
                                                  ),
                                                ),
                                              ],
                                            ):SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                        )),
          ],
        ),
      ),
    ),
    );
  }

  void _makePhoneCall(BuildContext context, String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);

    // 📌 कॉल परमिशन चेक करें
    var status = await Permission.phone.status;
    if (!status.isGranted) {
      status = await Permission.phone.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Call permission is required")),
        );
        return;
      }
    }

    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not launch $callUri")),
      );
    }
  }

  /// Helper function to format phone number for WhatsApp
  String formatPhoneNumber(String phone, {String defaultCountryCode = '91'}) {
    String cleanedPhone = phone.replaceAll(RegExp(r'\D'), '');

    // Remove leading zero
    if (cleanedPhone.startsWith('0')) {
      cleanedPhone = cleanedPhone.substring(1);
    }

    if (!cleanedPhone.startsWith(defaultCountryCode)) {
      cleanedPhone = '$defaultCountryCode$cleanedPhone';
    }

    print("Formatted WhatsApp Phone: $cleanedPhone");
    return cleanedPhone; // ✅ no `+` in this string!
  }



  void openWhatsApp(BuildContext context, String phone) async {
    String formattedPhone = formatPhoneNumber(phone);

    final Uri whatsappUrl = Uri.parse("https://wa.me/$formattedPhone?text=Hello");

    try {
      // Always launch directly (skip canLaunch check)
      final launched = await launchUrl(
        whatsappUrl,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) throw 'Could not launch';
    } catch (e) {
      // Show fallback snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("WhatsApp not available")),
      );

      // Redirect to Play Store
      await launchUrl(
        Uri.parse("https://play.google.com/store/apps/details?id=com.whatsapp"),
        mode: LaunchMode.externalApplication,
      );
    }
  }
}

class FullScreenImage extends StatelessWidget {
  final Data contact;

  const FullScreenImage({required this.contact, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithBack(
        title: AppLocalizations.of(context)!.tailorDetail,
        hasBackButton: true,
        elevation: 2.0,
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
        leadingIcon: SvgPicture.asset(
          'assets/svgIcon/myTailor.svg',
          color: Colors.black,
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(45),
                topRight: Radius.circular(45),
              ),
              child: CachedNetworkImage(
                imageUrl: contact.profileUrl.toString(),
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.22,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(45),
                  topRight: Radius.circular(45),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.7),
                    spreadRadius: 4.0,
                    blurRadius: 4.0,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.userName} : ${contact.name ?? AppLocalizations.of(context)!.noUserName}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${AppLocalizations.of(context)!.mobileNumber} : ${contact.mobileNo ?? AppLocalizations.of(context)!.noMobileNumber}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${AppLocalizations.of(context)!.userAddress} : ${contact.address ?? AppLocalizations.of(context)!.userNoAddress}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
