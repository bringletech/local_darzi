import 'package:cached_network_image/cached_network_image.dart';
import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/apiData/model/specific_notification_review_response_model.dart';
import 'package:darzi/l10n/app_localizations.dart';
import 'package:darzi/pages/tailor/screens/tailor_notification/view/tailor_notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../colors.dart';
import '../../../../../common/widgets/tailor/common_app_bar_with_back.dart';

class UserProfileReview extends StatefulWidget {
  final String notificationId;
  final Locale? locale;
  const UserProfileReview({super.key, required this.notificationId,this.locale});

  @override
  State<UserProfileReview> createState() => _UserProfileReviewState();
}

class _UserProfileReviewState extends State<UserProfileReview> {
  bool isLoading = false;
  Specific_Tailor_Review_Data? specific_tailor_review_data;
  ReviewCategories? reviewCategories;
  List<AllReviews> review_List_Data = [];

  String getFirstTwoWords(String? name) {
    if (name == null || name.trim().isEmpty) return "NA"; // Null ya empty check
    String onlyLetters =
        name.replaceAll(RegExp(r'[^A-Za-z]'), ''); // Sirf letters le

    if (onlyLetters.isEmpty)
      return "NA"; // Important: Agar sirf non-letters the, toh NA return karo

    return onlyLetters.length >= 2
        ? onlyLetters.substring(0, 2).toUpperCase()
        : onlyLetters.toUpperCase();
  }

  String capitalizeFirstLetter(String? text) {
    if (text == null || text.isEmpty) return AppLocalizations.of(context)!.noUserName; // Handle null or empty case
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUpdateData(widget.notificationId);
  }

  void updateUI() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> ratings = specific_tailor_review_data != null
        ? [
      {
        "label": AppLocalizations.of(context)!.excellent_review,
        "value": specific_tailor_review_data?.reviewCategories?.excellent?.toDouble() ?? 0.0,
        "color": Colors.green
      },
      {
        "label": AppLocalizations.of(context)!.good_review,
        "value": specific_tailor_review_data?.reviewCategories?.good?.toDouble() ?? 0.0,
        "color": Colors.lightGreen
      },
      {
        "label": AppLocalizations.of(context)!.average_review,
        "value": specific_tailor_review_data?.reviewCategories?.average?.toDouble() ?? 0.0,
        "color": Colors.yellow
      },
      {
        "label": AppLocalizations.of(context)!.below_average_review,
        "value": specific_tailor_review_data?.reviewCategories?.belowAverage?.toDouble() ?? 0.0,
        "color": Colors.orange
      },
      {
        "label": AppLocalizations.of(context)!.poor_review,
        "value": specific_tailor_review_data?.reviewCategories?.poor?.toDouble() ?? 0.0,
        "color": Colors.red
      },
    ]
        : [];

    return WillPopScope(
      onWillPop: () async {
        // Navigate to TailorDashboardNew when device back button is pressed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => TailorNotificationScreen(
                    locale: widget.locale!,
                  )),
        );
        return false; // Prevent default back behavior
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.my_review,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.white,
          centerTitle: true, // 👈 yeh add karo
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () async {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => TailorNotificationScreen(
                      locale: widget.locale!,
                    )),
              );
            },
          ),
        ),
        // CustomAppBarWithBack(
        //   title: AppLocalizations.of(context)!.my_review,
        //   // title: AppLocalizations.of(context)!.tailorDetail ,
        //   hasBackButton: true,
        //   elevation: 2.0,
        //   onBackButtonPressed: () async {
        //     final result = await Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) => TailorNotificationScreen(
        //                 locale: widget.locale!,
        //               )),
        //     );
        //     Navigator.pop(context, true);
        //   },
        //   leadingIcon: SvgPicture.asset(
        //     'assets/svgIcon/myTailor.svg',
        //     color: Colors.black,
        //   ),
        // ),
        body: isLoading == true?Center(child: CircularProgressIndicator(color: AppColors.primaryRed,),):
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: CachedNetworkImage(
                  imageUrl: specific_tailor_review_data?.tailoraccount?.profileUrl?.toString() ?? '',
                  errorWidget: (context, url,
                      error) =>
                      Image.network(
                          'https://dummyimage.com/500x500/aaa/000000.png&text= No+Image+Available',
                          fit: BoxFit.fill),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Center(
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue,
                          child: Text(
                            getFirstTwoWords(specific_tailor_review_data?.tailoraccount!.name ?? AppLocalizations.of(context)!.noUserName),
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        )
                    ),
                    Text(
                      //'Name',
                      specific_tailor_review_data?.tailoraccount!.name.toString()
                          ?? AppLocalizations.of(context)!.noUserName,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                          fontSize: 19),
                    ),
                    if (reviewCategories != null) ...[
                      Text(
                        reviewCategories?.avgRating?.toString() ?? "0.0",
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Inter',
                            fontSize: 48),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RatingBarIndicator(
                            rating: reviewCategories?.avgRating?.toDouble() ?? 0.0,
                            direction: Axis.horizontal,
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: AppColors.ratingBarColor,
                            ),
                            itemCount: 5,
                            itemSize: 20.0,
                          ),
                        ],
                      ),
                    ],
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: ratings.map((rating) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    rating["label"],
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: rating["value"],
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        rating["color"]),
                                    minHeight: 8,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Visibility(
                      visible: review_List_Data.isNotEmpty,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: review_List_Data.length,
                        itemBuilder: (context, index) {
                          final review = review_List_Data[index];
                          return Card(
                            color: Colors.white,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            margin: EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 22,
                                            backgroundColor: Colors.grey[300], // Optional background color
                                            child: ClipOval(
                                              child: CachedNetworkImage(
                                                imageUrl: review.customerProfileUrl?? '', // Ensure it doesn't crash if null
                                                width: 44, // Double the radius to fit perfectly
                                                height: 44,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) => CircularProgressIndicator(),
                                                errorWidget: (context, url, error) =>
                                                    Icon(Icons.person, size: 44, color: Colors.grey), // Fallback icon
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            textAlign: TextAlign.start,
                                            capitalizeFirstLetter(review.customerName),
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                      Text(review.reviewTime.toString(), style:
                                      TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 8,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey)),
                                    ],
                                  ),
                                  SizedBox(height: 6),
                                  RatingBarIndicator(
                                    rating: (review.rating ?? 0).toDouble(),
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
                                  if (review.review.toString().isNotEmpty) ...[
                                    SizedBox(height: 6),
                                    Text(review.review.toString(),
                                      style: TextStyle(fontFamily: 'Inter',
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,),),
                                  ],
                                  if (review.images != null) ...[
                                    SizedBox(height: 6),
                                    Visibility(
                                      visible:review.images!.isNotEmpty,
                                      child: SizedBox(
                                        height: 100,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: review.images!.length,
                                          itemBuilder: (context, imgIndex) {
                                            return Padding(
                                              padding: const EdgeInsets.only(right: 10),
                                              child: Image.network(
                                                review.images![imgIndex],
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return  Image.network(
                                                    height: 100,
                                                    width: 100,
                                                    'https://dummyimage.com/500x500/aaa/000000.png&text= No+Image+Available',
                                                    fit: BoxFit.fill,);
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  loadUpdateData(String notificationId) {
    setState(() {
      isLoading = true;
      print("customer Id is : $notificationId");
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Specific_Notification_Review_Response_Model model =
        await CallService().getSpecificTailorReviewNotificationDetail(notificationId);
        setState(() {
          isLoading = false;
          specific_tailor_review_data = model.data;
          reviewCategories = model.data!.reviewCategories;
          review_List_Data = model.data!.allReviews!;
          print("list Value is: ${review_List_Data.length}");
        });
      });
    });
  }
}
