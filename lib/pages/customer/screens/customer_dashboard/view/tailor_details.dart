import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:darzi/apiData/all_urls/all_urls.dart';
import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/apiData/model/aws_response_model.dart';
import 'package:darzi/apiData/model/customer_add_to_favourite_response_model.dart';
import 'package:darzi/apiData/model/my_tailor_details_response_model.dart';
import 'package:darzi/apiData/model/tailor_review_list_response_model.dart';
import 'package:darzi/apiData/model/tailor_review_response_model.dart';
import 'package:darzi/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../colors.dart';
import '../../../../../common/widgets/tailor/common_app_bar_with_back.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

import 'mytailors copy.dart';

class TailorDetails extends StatefulWidget {
  final Locale locale;
  final String tailorId;
  TailorDetails({super.key, required this.locale,required this.tailorId});


  @override
  State<TailorDetails> createState() => _TailorDetailsState();
}

class _TailorDetailsState extends State<TailorDetails> {
  bool isLoading = false;
  double _rating = 0.0;
  bool? isFavourite;
  bool? isReview;
  TextEditingController _reviewController = TextEditingController();
  TailorDetailsData? tailorDetailsData;
  ReviewCategories? reviewCategories;
  List<ReviewListData> review_List_Data = [];
  List<String> reviewImageList = [];
  File? _selectedImage;
  double? latitude;
  double? longitude;
  String fileName = "",
      presignedUrl = "",
      objectUrl = "",
      extensionWithoutDot = "";
  final ImagePicker _picker = ImagePicker();





  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTailorDetails(widget.tailorId);
    getTailorReviews(widget.tailorId);
  }


  Future<void> getTailorDetails(String tailorId) async {
    isLoading = true;
    setState(() {});

    try {
      My_Tailor_Details_Respone_Model model =
      await CallService().getMyTailorDetails(tailorId);

      tailorDetailsData = model.data!;
      isFavourite = model.data!.isFavorite;
      isReview = model.data!.isReview;
      latitude = model.data!.latitude!;
      longitude = model.data!.longitude!;
      // if (latitude == null || longitude == null) {
      //   // Handle null case
      //   print('Location not available');
      //   latitude = model.data?.latitude ?? 20.5937; // Default India latitude
      //   longitude = model.data?.longitude ?? 78.9629; // Default India longitude
      // } else {
      //   latitude = model.data!.latitude!;
      //   longitude = model.data!.longitude!;
      // }
      print("Tailor Details: $tailorDetailsData");
      print("Tailor Details: $latitude");
      print("Tailor Details: $longitude");
      print("Is Favourite: $isFavourite");
      print("Is Review: $isReview");
    } catch (e) {
      print("Error in getTailorDetails: $e");
    } finally {
      isLoading = false;
      setState(() {});
    }
  }

  String capitalizeFirstLetter(String? text) {
    if (text == null || text.isEmpty) return AppLocalizations.of(context)!.noUserName; // Handle null or empty case
    return text[0].toUpperCase() + text.substring(1);
  }

  void getTailorReviews(String tailorId) {
    setState(() {
      isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Get_Customer_Tailor_Reviews_Response_Model model =
        await CallService().get_Tailor_Review_List(tailorId);
        setState(() {
          isLoading = false;
          review_List_Data = model.data!;
          // customersList = model.data!.customers!;
          print("list Value is: ${tailorDetailsData}");
          print("list Value is: ${isFavourite}");
          print("list Value is: ${isReview}");
          // print("list Value is: ${customersList.length}");
        });
      });
    });
  }

  String getFirstTwoWords(String? name) {
    if (name == null || name.trim().isEmpty) return "NA"; // Null ya empty check
    String onlyLetters = name.replaceAll(RegExp(r'[^A-Za-z]'), ''); // Sirf letters le

    if (onlyLetters.isEmpty) return "NA"; // Important: Agar sirf non-letters the, toh NA return karo

    return onlyLetters.length >= 2
        ? onlyLetters.substring(0, 2).toUpperCase()
        : onlyLetters.toUpperCase();
  }

  void updateUI() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> ratings = tailorDetailsData != null
        ? [
      {"label":  AppLocalizations.of(context)!.excellent_review, "value": tailorDetailsData?.reviewCategories?.excellent?.toString() ?? "0", "color": Colors.green},
      {"label": AppLocalizations.of(context)!.good_review, "value": tailorDetailsData?.reviewCategories?.good?.toString() ?? "0", "color": Colors.lightGreen},
      {"label": AppLocalizations.of(context)!.average_review, "value": tailorDetailsData?.reviewCategories?.average?.toString() ?? "0", "color": Colors.yellow},
      {"label": AppLocalizations.of(context)!.below_average_review, "value":tailorDetailsData?.reviewCategories?.belowAverage?.toString() ?? "0", "color": Colors.orange},
      {"label": AppLocalizations.of(context)!.poor_review, "value": tailorDetailsData?.reviewCategories?.poor?.toString() ?? "0", "color": Colors.red},
    ]
        : [];
    return WillPopScope(
      onWillPop: () async {
        // Navigate to TailorDashboardNew when device back button is pressed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MyTailors(
                    locale: widget.locale,
                  )),
        );
        return false;
      },

      child:Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBarWithBack(
            title: AppLocalizations.of(context)!.myTailor,
            // title: AppLocalizations.of(context)!.tailorDetail ,
            hasBackButton: true,
            elevation: 2.0,
            onBackButtonPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyTailors(
                      locale: widget.locale,
                    )),
              );
              Navigator.pop(context, true);
            },
            leadingIcon: SvgPicture.asset(
              'assets/svgIcon/myTailor.svg',
              color: Colors.black,
            ),
          ),
          body: isLoading || tailorDetailsData == null
              ? Center(child: CircularProgressIndicator())
              :SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10,),
                Container(
                  child: CachedNetworkImage(
                    imageUrl: tailorDetailsData?.profileUrl?.toString() ?? '',
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
                              getFirstTwoWords(tailorDetailsData?.name ?? AppLocalizations.of(context)!.noUserName),
                              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          )
                      ),
                      Text(tailorDetailsData!.name?? AppLocalizations.of(context)!.noUserName,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                            fontSize: 19
                        ),
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RatingBarIndicator(
                            rating: (tailorDetailsData?.avgRating ?? 0).toDouble(),
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(4),
                            ), child: Text(tailorDetailsData!.avgRating!.toString(),
                            style: TextStyle(
                                fontFamily: 'Inter',
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight:
                                FontWeight
                                    .w600),
                          ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          showAlertDialog(context,);
                        },
                        child: Visibility(
                          visible: isReview == false,
                          child: Text(AppLocalizations.of(context)!.write_review,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                color: Color(0xFF0165A3)
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                GestureDetector(
                                  onTap:(){
                                    _makePhoneCall(context,tailorDetailsData!.mobileNo.toString());
                                  },
                                  child: SvgPicture.asset(
                                    'assets/svgIcon/phoneCircle.svg',
                                    width: 36,
                                    height: 36,
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Text(AppLocalizations.of(context)!.tailor_call, style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF0165A3)
                                ),)
                              ],
                            ),
                            SizedBox(width: 30,),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap:(){
                                    openGoogleMapsWithDirections();
                                  },
                                  child: SvgPicture.asset(
                                    'assets/svgIcon/locationCircle.svg',
                                    width: 36,
                                    height: 36,
                                    color: AppColors.newUpdateColor,
                                  ),
                                ), SizedBox(height: 5,),
                                Text(AppLocalizations.of(context)!.tailor_location, style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF0165A3)
                                ),)
                              ],
                            ),
                            SizedBox(width: 15,),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    openWhatsApp(context,tailorDetailsData!.mobileNo.toString());
                                  },
                                  child: Image.asset(
                                    'assets/images/whatsapp.png',
                                    width: 36,
                                    height: 36,
                                  ),
                                ), SizedBox(height: 5,),
                                Text(AppLocalizations.of(context)!.tailor_whatsapp, style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF0165A3)
                                ),)
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: EdgeInsets.only(left: 15.0, right: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Text(AppLocalizations.of(context)!.add_to_favourite
                                  , style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Poppins',
                                      fontSize: 11
                                  ),), SizedBox(width: 5,),
                                isFavourite == true?GestureDetector(
                                    onTap: (){
                                      add_Tailor_To_Favourite(widget.tailorId);
                                    },
                                    child: Icon(Icons.favorite,color: AppColors.newUpdateColor,))
                                    :GestureDetector(
                                    onTap: (){
                                      add_Tailor_To_Favourite(widget.tailorId);
                                    },
                                    child: Icon(Icons.favorite_border))
                              ],
                            ),
                          ],
                        ),
                      ),
                      Text(tailorDetailsData!.avgRating.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Inter',
                            fontSize: 48
                        ),
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RatingBarIndicator(
                            rating: tailorDetailsData!.avgRating!.toDouble(),
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
                        ],
                      ),
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
                                          fontSize: 13, fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  SizedBox(width: 5,),
                                  Expanded(
                                    child: LinearProgressIndicator(
                                      value: double.tryParse(rating["value"].toString()) ?? 0.0, // String to double conversion
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
                                                  imageUrl: review.customer?.profileUrl ?? '', // Ensure it doesn't crash if null
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
                                              capitalizeFirstLetter(review.customer?.name),
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
          )
      ),
    );
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool isDialogLoading = false; // ✅ local loading state

            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Container(
                height: 400,
                width: 340,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Header
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                        color: Color(0xFFD9D9D9),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.write_review,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),

                    /// ⭐ Rating
                    Center(
                      child: RatingBar.builder(
                        initialRating: _rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: AppColors.ratingBarColor,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            _rating = rating;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 8),

                    /// ✏️ Review Text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: _reviewController,
                        maxLength: 50,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.write_review_text,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 1),
                          ),
                          hintStyle: TextStyle(
                            fontSize: 11,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF7D7D7D),
                          ),
                        ),
                      ),
                    ),

                    /// 📸 Upload Image Label
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: Text(
                        AppLocalizations.of(context)!.upload_image,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: AppColors.newUpdateColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 4),

                    /// 📸 Image Row + Upload Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showImageSourceActionSheet(context, setState);
                            },
                            child: Icon(Icons.attach_file, color: Colors.black),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: Container(
                              height: 60,
                              child: reviewImageList.isNotEmpty
                                  ? ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: reviewImageList.length > 3
                                    ? 3
                                    : reviewImageList.length,
                                itemBuilder: (context, index) {
                                  final imageUrl = reviewImageList[index].toString().trim();
                                  return Stack(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.symmetric(horizontal: 6),
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(6),
                                          child: CachedNetworkImage(
                                            imageUrl: imageUrl,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                            errorWidget: (context, url, error) =>
                                                Icon(Icons.broken_image),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              reviewImageList.removeAt(index);
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.black.withOpacity(0.6),
                                            ),
                                            padding: EdgeInsets.all(2),
                                            child: Icon(Icons.close, size: 12, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              )
                                  : Center(
                                child: Text(
                                  "No image uploaded",
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 12),

                    /// ✅ Submit Button or Loading
                    Center(
                      child: isLoading
                          ? CircularProgressIndicator()
                          : SizedBox(
                        height: 47,
                        width: 120,
                        child: Card(
                          color: AppColors.newUpdateColor,
                          elevation: 4,
                          shadowColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: AppColors.newUpdateColor, width: 1.5),
                          ),
                          child: TextButton(
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });

                              String reviewText = _reviewController.text.trim();

                              var map = <String, dynamic>{};
                              map['tailorId'] = widget.tailorId.toString();
                              map['rating'] = _rating.toString();
                              map['review'] = reviewText;
                              map['reviewImages'] = reviewImageList;

                              // if (reviewImageList.isNotEmpty) {
                              //
                              // }

                              print("Review Data Map: $map");

                              try {
                                Tailor_Review_Response_Model model =
                                await CallService().uploadTailorReviewByCustomer(map);

                                String message = model.message.toString();

                                Fluttertoast.showToast(
                                  msg: message,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: AppColors.newUpdateColor,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );

                                // ✅ Close popup first
                                if (context.mounted) Navigator.of(context).pop(true);

                                // ✅ Then refresh background screen
                                updateUI();
                                getTailorDetails(widget.tailorId);
                                getTailorReviews(widget.tailorId);

                                // ✅ Clear local values
                                _reviewController.clear();
                                _rating = 0;
                                reviewImageList.clear();
                              } catch (e) {
                                Fluttertoast.showToast(
                                  msg: "Something went wrong: $e",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                );
                              } finally {
                                if (mounted) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }
                            },
                            child: Text(
                              AppLocalizations.of(context)!.submit_review,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _makePhoneCall(BuildContext context,String phoneNumber) async {
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

  void _showImageSourceActionSheet(BuildContext context, void Function(void Function()) parentSetState) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      isScrollControlled: true,
      builder: (BuildContext mcontext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter dialogSetState) {
            bool isUploading = false;

            return Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text("Camera"),
                  onTap: () async {
                    // Navigator.pop(context);
                    // final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
                    // if (photo != null) {
                    //   _selectedImage = File(photo.path);
                    //   fileName = p.basename(photo.path);
                    //   extensionWithoutDot = p.extension(photo.path).substring(1);
                    //
                    //   dialogSetState(() => isUploading = true);
                    //   final uploadedUrl = await getAwsUrl(dialogSetState);
                    //   dialogSetState(() => isUploading = false);
                    //
                    //   if (uploadedUrl.isNotEmpty) {
                    //     reviewImageList.add(uploadedUrl);
                    //   }
                    // }
                    Navigator.pop(context); // ⚠️ ye dialog close kar raha hai

                    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
                    if (photo != null) {
                      _selectedImage = File(photo.path);
                      fileName = p.basename(photo.path);
                      extensionWithoutDot = p.extension(photo.path).substring(1);

                      final uploadedUrl = await getAwsUrl(dialogSetState);

                      // ✅ Check mounted before setState
                      if (!mounted) return;
                      parentSetState(() {
                        reviewImageList.add(uploadedUrl);
                      });
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text("Gallery"),
                  onTap: () async {
                    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);

                    if (photo != null) {
                      dialogSetState(() => isUploading = true); // show loader

                      _selectedImage = File(photo.path);
                      fileName = p.basename(photo.path);
                      extensionWithoutDot = p.extension(photo.path).substring(1);

                      final uploadedUrl = await getAwsUrl(dialogSetState);

                      dialogSetState(() => isUploading = false); // hide loader

                      if (!mounted) return;

                      if (uploadedUrl.isNotEmpty) {
                        parentSetState(() {
                          reviewImageList.add(uploadedUrl);
                        });
                      }

                      Navigator.pop(context); // ✅ Only pop if upload succeeded
                    }
                  },
                ),
                if (isUploading)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
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

  Future<String> getAwsUrl(StateSetter dialogSetState) async {
    String fileType = "image/$extensionWithoutDot", folder_name = "Order";

    try {
      AwsResponseModel model = await CallService().getAwsUrl(fileType, folder_name);
      presignedUrl = model.presignedUrl.toString();
      objectUrl = model.objectUrl.toString();
      print("Presigned url is: $presignedUrl");
      print("Object url is: $objectUrl");

      await callPresignedUrl(presignedUrl);

      return objectUrl;
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Failed to upload image. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return '';
    }
  }



  Future<void> callPresignedUrl(String presignedUrl) async {
    if (_selectedImage == null) return;

    try {
      Uri url = Uri.parse(presignedUrl);
      final imageBytes = await _selectedImage!.readAsBytes();

      var response = await http.put(
        url,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'image/$extensionWithoutDot',
        },
        body: imageBytes,
      );

      if (response.statusCode != 200) {
        Fluttertoast.showToast(
          msg: "Image upload failed. Status: ${response.statusCode}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
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


  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  void openGoogleMapsWithDirections() async {
    // Check if destination coordinates are not null
    if (latitude == null || longitude == null) {
      Fluttertoast.showToast(msg: "Destination location not available");
      return;
    }

    try {
      Position position = await getCurrentLocation();

      final double currentLatitude = position.latitude;
      final double currentLongitude = position.longitude;

      final Uri googleMapsUrl = Uri.parse(
        'https://www.google.com/maps/dir/?api=1'
            '&origin=$currentLatitude,$currentLongitude'
            '&destination=$latitude,$longitude'
            '&travelmode=driving',
      );

      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch Google Maps';
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  void add_Tailor_To_Favourite(String tailorId) async {
    var map = <String, dynamic>{};
    map['tailorId'] = tailorId;
    print("Map value is $map");

    isLoading = true;
    setState(() {});

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        Customer_Add_To_Favourite_Response_Model model =
        await CallService().add_Tailor_To_Favourites(map);

        String message = model.message.toString();
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        // ✅ Wait for this to complete before setting isLoading = false
        await getTailorDetails(tailorId);
      } catch (e) {
        print("Error: $e");
      } finally {
        isLoading = false;
        setState(() {});
      }
    });
  }


}