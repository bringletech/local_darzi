import 'package:cached_network_image/cached_network_image.dart';
import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/apiData/model/get_current_customer_list_details_model.dart';
import 'package:darzi/apiData/model/tailor_List_Response_Model.dart';
import 'package:darzi/common/widgets/tailor/common_app_bar_with_back.dart';
import 'package:darzi/constants/string_constant.dart';
import 'package:darzi/l10n/app_localizations.dart';
import 'package:darzi/pages/customer/screens/customer_dashboard/view/customer_dashboard.dart';
import 'package:darzi/pages/customer/screens/customer_dashboard/view/tailor_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../colors.dart';
import 'customer_dashboard_new.dart';

class MyTailors extends StatefulWidget {
  final Locale locale;
  MyTailors({super.key, required this.locale});

  @override
  State<MyTailors> createState() => _MyTailorsState();
}

class _MyTailorsState extends State<MyTailors> {
  List<Tailors> tailorList = []; // List to store API response
  List<Tailors> filteredTailors = []; // Filtered list for search
  final TextEditingController _searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  bool isLoading = true; // To show loading indicator
  bool isFetchingMore = false;
  int page = 0;
  int limit = 10;
  bool _hasCallSupport = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      fetchTailorList();
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent &&
          !isFetchingMore) {
        loadMoreStories();
      }
    });
  }
  Future<void> fetchTailorList() async {
    setState(() {
      isLoading = true;
    });
    try {
      Tailor_List_Response_Model model =
          await CallService().getMyTailorList(page, limit);
      setState(() {
        tailorList = model.data!;
        filteredTailors = tailorList;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching tailors: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void loadMoreStories() async {
    if (isFetchingMore) return;

    setState(() {
      isFetchingMore = true;
    });

    try {
      page++;
      print("My Current Page Value is : ${page++}");
      print("My Current Page Value is : $limit");
      try {
        Tailor_List_Response_Model model =
        await CallService().getMyTailorList(page, limit);
        setState(() {
          filteredTailors.addAll(model.data!);
        });
      } catch (e) {
        print('Error fetching tailors: $e');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading more stories: $e");
    } finally {
      setState(() {
        isFetchingMore = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => CustomerDashboardNew(
                      locale: widget.locale,
                    )),
          );
          return false; // Prevent default back behavior
        },
        child: Scaffold(
          appBar: CustomAppBarWithBack(
            title: AppLocalizations.of(context)!.myTailor,
            hasBackButton: true,
            elevation: 2.0,
            leadingIcon: SvgPicture.asset(
              'assets/svgIcon/myTailor.svg', //just change my image with your image
              color: Colors.black,
            ),
            onBackButtonPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CustomerDashboardNew(
                      locale: widget.locale,
                    )),
              );
              Navigator.pop(context, true);
            },
          ),
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.darkRed,
                  ), // Loading indicator
                )
              : Column(
                  children: [
                    Expanded(
                      child: filteredTailors.isEmpty
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
                                        .no_tailor_found,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey),
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              padding: const EdgeInsets.only(top: 20),
                              color: Colors.white,
                              child: ListView.builder(
                                controller: scrollController,
                                physics: BouncingScrollPhysics(),
                                itemCount: filteredTailors.length + (isFetchingMore ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == filteredTailors.length) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.newUpdateColor,
                                      ),
                                    );
                                  }
                                  final tailor = filteredTailors[index];
                                  print("specific tailor id is ${tailor.id}");
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TailorDetails(
                                                      locale: widget.locale,
                                                      tailorId: tailor.id
                                                          .toString())));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3,
                                          horizontal:
                                              15), // 👈 Card ke beech ka space kam kiya
                                      child: Card(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        elevation: 10,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: SizedBox(
                                                  width: 70,
                                                  height: 70,
                                                  child: CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    height: 50,
                                                    width: 50,
                                                    imageUrl: tailor.profileUrl
                                                        .toString(),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            SvgPicture.asset(
                                                      'assets/svgIcon/profilepic.svg',
                                                      // Default profile icon
                                                      width: 120,
                                                      height: 120,
                                                    ),
                                                  ),
                                                ),
                                              ),
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
                                                      tailor.name ??
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .noUserName,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xFF000000),
                                                        fontSize: 19,
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                          'assets/svgIcon/location.svg',
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            tailor.address ??
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .userNoAddress,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                            style:
                                                                const TextStyle(
                                                              color: Color(
                                                                  0xFF000000),
                                                              fontSize: 13,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        RatingBarIndicator(
                                                          rating: tailor
                                                              .avgRating!
                                                              .toDouble(),
                                                          direction:
                                                              Axis.horizontal,
                                                          itemBuilder: (context,
                                                                  index) =>
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
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal: 8,
                                                                  vertical:
                                                                      1.5),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.black,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                          ),
                                                          child: Text(
                                                            tailor.avgRating!
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Inter',
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () async {
                                                      openWhatsApp(context,tailor.mobileNo.toString());
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
                                                          tailor.mobileNo
                                                              .toString());
                                                    },
                                                    child: SvgPicture.asset(
                                                      'assets/svgIcon/phone_color.svg',
                                                      width: 28,
                                                      height: 28,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )),
                    ),
                  ],
                ),
        ));
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
}
