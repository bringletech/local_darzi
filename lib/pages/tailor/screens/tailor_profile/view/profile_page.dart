import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/apiData/model/aws_response_model.dart';
import 'package:darzi/apiData/model/current_tailor_detail_response.dart';
import 'package:darzi/apiData/model/tailor_account_delete_response_model.dart';
import 'package:darzi/apiData/model/tailor_profile_update_response_model.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/common/all_text.dart';
import 'package:darzi/common/all_text_form_field_profile.dart';
import 'package:darzi/common/widgets/tailor/common_app_bar_without_back.dart';
import 'package:darzi/l10n/app_localizations.dart';
import 'package:darzi/pages/tailor/screens/tailor_dashboard/view/tailor_dashboard_new.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as p;
import '../../../../../apiData/model/get_tailor_review_response_model.dart';
import '../../../../../common/widgets/tailor/common_app_bar_with_back.dart';
import '../../../../../homePage.dart';
import '../../../../../main.dart';

class TailorProfilePage extends StatefulWidget {
  final Locale locale;
  TailorProfilePage({super.key, required this.locale});

  @override
  State<TailorProfilePage> createState() => _TailorProfilePageState();
}

class _TailorProfilePageState extends State<TailorProfilePage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController profileNameController = TextEditingController();
  final TextEditingController profileMobileNoController =
      TextEditingController();
  final TextEditingController profileStreetController = TextEditingController();
  final TextEditingController profileCityController = TextEditingController();
  final TextEditingController profileStateController = TextEditingController();
  final TextEditingController profilePostalCodeController =
      TextEditingController();
  final TextEditingController profileCountryController =
      TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  String mobileNumber = "", fileName = "",presignedUrl = "",objectUrl = "",extensionWithoutDot = "";
  bool isLoading = false;
  bool isPressed = false;
  String enterName = "",
      address = "",
      street = '',
      city = '',
      state = '',
      postalCode = '',
      country = '';
  String? profileUrl = "";
  List<TailorReviewData>? reviewData = [];
  final Uri _privacyPolicyUrl =
      Uri.parse('https://mannytechnologies.com/contact-us/');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading == true;
    getSharedValue();
    getReviewData();
    //userUpdateDetails();
  }

  String capitalizeFirstLetter(String? text) {
    if (text == null || text.isEmpty)
      return AppLocalizations.of(context)!
          .noUserName; // Handle null or empty case
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mobileNumber.isEmpty) {
      // or else you end up creating multiple instances in this case.
      getSharedValue();
    }
  }

  Future<void> _showImageSourceActionSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, color: Colors.black),
              title: Text(
                AppLocalizations.of(context)!.appCamera,
              ),
              onTap: () async {
                final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

                if (photo != null) {
                  setState(() {
                    _selectedImage = File(photo.path);
                    fileName = p.basename(photo.path);
                    String extension = p.extension(photo.path);
                    extensionWithoutDot = extension.substring(1);
                  });

                  Navigator.pop(context); // Close the sheet immediately

                  await getAwsUrl(); // Upload or get URL after modal is closed
                } else {
                  Navigator.pop(context); // Even if no photo, close the sheet
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: Colors.black),
              title: Text(
                AppLocalizations.of(context)!.appGallery,
              ),
              onTap: () async {
                final XFile? photo =
                await _picker.pickImage(source: ImageSource.gallery);

                if (photo != null) {
                  setState(() {
                    _selectedImage = File(photo.path);
                    fileName = p.basename(photo.path);
                    String extension = p.extension(photo.path);
                    extensionWithoutDot = extension.substring(1);
                  });

                  Navigator.pop(context); // Close the sheet immediately

                  await getAwsUrl(); // Upload or get URL after modal is closed
                } else {
                  Navigator.pop(context); // Even if no photo, close the sheet
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> getAwsUrl() async {
    String fileType = "image/$extensionWithoutDot", folder_name = "Order";
    print('Image FileType is $fileType');
    print('Folder Name is $folder_name');

    setState(() {
      isLoading = true; // Start loader
    });

    try {
      AwsResponseModel model = await CallService().getAwsUrl(fileType, folder_name);
      presignedUrl = model.presignedUrl.toString();
      objectUrl = model.objectUrl.toString();

      print("Presigned URL: $presignedUrl");
      print("Object URL: $objectUrl");

      await callPresignedUrl(presignedUrl); // ✅ Await here
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Failed to update details. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.newUpdateColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      setState(() {
        isLoading = false; // Stop loader AFTER everything
      });
    }
  }


  Future<void> callPresignedUrl(String presignedUrl) async {
    if (_selectedImage == null) {
      Fluttertoast.showToast(
        msg: "No image selected",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    try {
      Uri url = Uri.parse(presignedUrl);
      print("Uploading to Presigned URL: $url");

      final imageBytes = await _selectedImage!.readAsBytes();

      var response = await http.put(
        url,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'image/$extensionWithoutDot',
        },
        body: imageBytes,
      );

      print("Upload response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        print("Image uploaded successfully.");

      } else {
        Fluttertoast.showToast(
          msg: "Image upload failed. Status: ${response.statusCode}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print("Upload error: $e");
      Fluttertoast.showToast(
        msg: "An error occurred during upload: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }



  void updateUI() {
    setState(() {});
  }

  void userUpdateDetails() {
    setState(() {
      isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Current_Tailor_Response model =
            await CallService().getCurrentTailorDetails();
        setState(() {
          isLoading = false;
          enterName = model.data?.name ?? "";
          profileUrl = model.data?.profileUrl ?? "";
          street = model.data?.street ?? "";
          city = model.data?.city ?? "";
          state = model.data?.state ?? "";
          postalCode = model.data?.postalCode ?? "";
          country = model.data?.country ?? "";
          print("name Value is: $enterName");
          print("Street Value is: $street");
          print("city Value is: $city");
          print("state Value is: $state");
          print("postalcode Value is: $postalCode");
          print("country Value is: $country");
          print("Profile URL: $profileUrl");
          profileNameController.text = enterName;
          profileStreetController.text = street;
          profileCityController.text = city;
          profileStateController.text = state;
          profilePostalCodeController.text = postalCode;
          profileCountryController.text = country;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate to TailorDashboardNew when device back button is pressed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => TailorDashboardNew(
                    locale: widget.locale,
                  )),
        );
        return false; // Prevent default back behavior
      },
      child: SingleChildScrollView(
        child: Stack(children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: isLoading == true
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.newUpdateColor,
                    ),
                  )
                : Container(
                    padding: EdgeInsets.only(bottom: 50),
                    height: 350,
                    width: 400,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.newBackgroundColor,
                            AppColors.newUpdateColor
                          ], // Define colors
                          begin: Alignment.topCenter, // Start position
                          end: Alignment.bottomCenter, // End position
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        )),
                    child: Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.bottomCenter,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              _handleImagePickerTap(context);
                            },
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.transparent,
                              child: ClipOval(
                                child: _selectedImage != null
                                    ? Image.file(
                                        _selectedImage!,
                                        fit: BoxFit.cover,
                                        width: 120,
                                        height: 120,
                                      )
                                    : (profileUrl != null &&
                                            profileUrl!.isNotEmpty)
                                        ? CachedNetworkImage(
                                            height: 120,
                                            width: 120,
                                            imageUrl: profileUrl.toString(),
                                            fit: BoxFit.cover,
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                CircularProgressIndicator(
                                              value: downloadProgress.progress,
                                              color: AppColors.newUpdateColor,
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    SvgPicture.asset(
                                              'assets/svgIcon/profilepic.svg',
                                              // Default profile icon
                                              width: 120,
                                              height: 120,
                                            ),
                                          )
                                        : SvgPicture.asset(
                                            'assets/svgIcon/profilepic.svg',
                                            // Default profile icon
                                            width: 120,
                                            height: 120,
                                          ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              _handleImagePickerTap(context);
                            },
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Transform.translate(
                                offset: Offset(0, 15),
                                child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.newUpdateColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                    ),
                                    child:
                                        // Icon(Icons.edit, color: Colors.white, size: 20),
                                        SvgPicture.asset(
                                      'assets/svgIcon/edit.svg',
                                      color: Colors.white,
                                      height: 18,
                                      width: 18,
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomAppBarWithBack(
              title: AppLocalizations.of(context)!.yourAccount,
              hasBackButton: false,
              elevation: 2.0,
              leadingIcon: SvgPicture.asset(
                'assets/svgIcon/account.svg',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 350, left: 40, right: 40, bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(width: 8),
                    AllText(
                      text: AppLocalizations.of(context)!.userName,
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                Material(
                  elevation: 10,
                  shadowColor: Colors.black.withOpacity(1.0),
                  borderRadius: BorderRadius.circular(30),
                  child: TextFormField(
                    readOnly: false,
                    controller: profileNameController,
                    decoration: InputDecoration(
                      hintText: '',
                      contentPadding: EdgeInsets.only(left: 15.0),
                      hintStyle: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          color: Color(0xff454545),
                          fontWeight: FontWeight.w400),

                      //contentPadding: const EdgeInsets.all(15),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    SizedBox(width: 8),
                    AllText(
                      text: AppLocalizations.of(context)!.mobileNumber,
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                Material(
                  elevation: 10,
                  shadowColor: Colors.black.withOpacity(1.0),
                  borderRadius: BorderRadius.circular(30),
                  child: TextFormField(
                    readOnly: true,
                    controller: profileMobileNoController,
                    decoration: InputDecoration(
                      hintText: mobileNumber,
                      contentPadding: EdgeInsets.only(left: 15.0),
                      hintStyle: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          color: Color(0xff454545),
                          fontWeight: FontWeight.w400),

                      //contentPadding: const EdgeInsets.all(15),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    SizedBox(width: 8),
                    AllText(
                      text: AppLocalizations.of(context)!.street,
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                AllProfileTextFormField(
                  readOnly: false,
                  hintText: '',
                  mController: profileStreetController,
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    SizedBox(width: 8),
                    AllText(
                      text: AppLocalizations.of(context)!.city,
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                AllProfileTextFormField(
                  readOnly: false,
                  hintText: '',
                  mController: profileCityController,
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    SizedBox(width: 8),
                    AllText(
                      text: AppLocalizations.of(context)!.state,
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                AllProfileTextFormField(
                  readOnly: false,
                  hintText: '',
                  mController: profileStateController,
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    SizedBox(width: 8),
                    AllText(
                      text: AppLocalizations.of(context)!.code,
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                AllProfileTextFormField(
                  readOnly: false,
                  hintText: '',
                  mController: profilePostalCodeController,
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    SizedBox(width: 8),
                    AllText(
                      text: AppLocalizations.of(context)!.country,
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                AllProfileTextFormField(
                  readOnly: false,
                  hintText: '',
                  mController: profileCountryController,
                ),
                SizedBox(
                  height: 15,
                ),
                if (reviewData != null && reviewData!.isNotEmpty)
                  Text(
                    AppLocalizations.of(context)!.recent_Reviews,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                SizedBox(
                  height: 15,
                ),
                Visibility(
                  visible: reviewData!.isNotEmpty,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: reviewData!.length,
                    itemBuilder: (context, index) {
                      final review = reviewData![index];
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 22,
                                        backgroundColor: Colors.grey[
                                            300], // Optional background color
                                        child: ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl: review
                                                    .customer?.profileUrl ??
                                                '', // Ensure it doesn't crash if null
                                            width:
                                                44, // Double the radius to fit perfectly
                                            height: 44,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) => Icon(
                                                    Icons.person,
                                                    size: 44,
                                                    color: Colors
                                                        .grey), // Fallback icon
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        textAlign: TextAlign.start,
                                        capitalizeFirstLetter(
                                            review.customer?.name),
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  Text(review.reviewTime.toString(),
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 8,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey)),
                                ],
                              ),
                              SizedBox(height: 6),
                              RatingBarIndicator(
                                rating: (review.rating ?? 0).toDouble(),
                                direction: Axis.horizontal,
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: AppColors.ratingBarColor,
                                ),
                                itemCount: 5,
                                itemSize: 20.0,
                                //unratedColor : Colors.blue
                              ),
                              if (review.review.toString().isNotEmpty) ...[
                                SizedBox(height: 6),
                                Text(
                                  review.review.toString(),
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                              if (review.images != null) ...[
                                SizedBox(height: 6),
                                Visibility(
                                  visible: review.images!.isNotEmpty,
                                  child: SizedBox(
                                    height: 100,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: review.images!.length,
                                      itemBuilder: (context, imgIndex) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Image.network(
                                            review.images![imgIndex],
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.network(
                                                height: 100,
                                                width: 100,
                                                'https://dummyimage.com/500x500/aaa/000000.png&text= No+Image+Available',
                                                fit: BoxFit.fill,
                                              );
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
                SizedBox(
                  height: 10,
                ),
                _buildSignUpButton(context),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 350,
                  height: 60,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.newUpdateColor,
                        side: BorderSide(color: Colors.white, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // <-- Rounded corners
                        ),
                      ),
                      onPressed: () {
                        // showAlertDialog(context,locale: widget.locale);
                        showAlertDialog(
                          context,
                          locale: widget.locale,
                          onChangeLanguage: (newLocale) {
                            // Handle the language change
                            print(
                                "Language changed to: ${newLocale.languageCode}");
                          },
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.userLogout,
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 19,
                                color: Colors.white
                                // color: isPressed ? Colors.white : AppColors.newUpdateColor,
                                ),
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          SvgPicture.asset(
                            "assets/svgIcon/logout.svg",
                            color: Colors.white,
                          ),
                        ],
                      )),
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
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
                          text: AppLocalizations.of(context)!.delete_account +
                              '  ', // Add a space here
                        ),
                        TextSpan(
                          text: AppLocalizations.of(context)!.contact_us,
                          style: TextStyle(
                            color: AppColors.newUpdateColor,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              showDeleteTailorAlertDialog(
                                context,
                                locale: widget.locale,
                                onChangeLanguage: (newLocale) {
                                  // Handle the language change
                                  print(
                                      "Language changed to: ${newLocale.languageCode}");
                                },
                                setLoadingTrue: () => setState(() => isLoading = true),
                                setLoadingFalse: () => setState(() => isLoading = false),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        Future<void> handleTap() async {
          setState(() {
            isLoading = true;
          });

          try {
            await updateProfile(); // 👈 Profile update after image upload;
          } catch (e) {
            Fluttertoast.showToast(
              msg: "Something went wrong: $e",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              backgroundColor: AppColors.newUpdateColor,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          } finally {
            setState(() {
              isLoading = false;
              isPressed = false;
            });
          }
        }

        return GestureDetector(
          onTap: () {
            if (!isLoading) handleTap();
          },
          onTapDown: (_) {
            setState(() {
              isPressed = true;
            });
          },
          onTapUp: (_) {
            setState(() {
              isPressed = false;
            });
          },
          onTapCancel: () {
            setState(() {
              isPressed = false;
            });
          },
          child: Container(
            width: 350,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.newUpdateColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.newUpdateColor, width: 2),
            ),
            child: Center(
              child: isLoading
                  ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                ),
              )
                  : Text(
                AppLocalizations.of(context)!.saveDetails,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 19,
                ),
              ),
            ),
          ),
        );
      },
    );
  }



  void showDeleteTailorAlertDialog(BuildContext parentContext,
      {required Locale locale, required Function(Locale) onChangeLanguage, required VoidCallback setLoadingTrue,
        required VoidCallback setLoadingFalse,}) {
    showDialog(
      context: parentContext,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Container(
            margin: const EdgeInsets.only(left: 16),
            child: Text(
              AppLocalizations.of(parentContext)!.tailor_account_deletion_title,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  fontSize: 20),
            ),
          ),
          content: Text(
            AppLocalizations.of(parentContext)!.tailor_account_deletion_sub_title,
            style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontFamily: 'Inter',
                fontSize: 16,
                color: Colors.grey),
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
                      onPressed: () async {
                        Navigator.of(dialogContext).pop(); // Close dialog

                        setLoadingTrue(); // Show loader

                        Tailor_Account_Delete_Response_Model model =
                        await CallService().removeTailor(); // API call

                        setLoadingFalse(); // Hide loader

                        if (model.status == true) {
                          Fluttertoast.showToast(
                            msg: model.message ?? "Account deleted successfully",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: AppColors.newUpdateColor,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );

                          // ✅ Clear all necessary shared preferences
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.remove("userId");
                          await prefs.remove("userMobileNumber");
                          await prefs.remove("phoneNumber");
                          await prefs.remove("userToken");
                          await prefs.remove("userType");
                          await prefs.remove("selectedLanguage");
                          await prefs.remove("deviceToken");

                          // Optionally: clear all data (if needed)
                          // await prefs.clear();

                          await Future.delayed(const Duration(seconds: 1));

                          if (parentContext.mounted) {
                            Navigator.pushAndRemoveUntil(
                              parentContext,
                              MaterialPageRoute(
                                builder: (context) => HomePage(
                                  onChangeLanguage: onChangeLanguage,
                                ),
                              ),
                                  (route) => false,
                            );
                          }
                        } else {
                          Fluttertoast.showToast(
                            msg: model.message ?? "Failed to delete account",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      },
                      child: Text(
                        AppLocalizations.of(context)!.yesMessage,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  height: 47,
                  width: 100,
                  child: Card(
                    color: Colors.white,
                    elevation: 4,
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                          color: AppColors.newUpdateColor, width: 1.5),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: TextStyle(
                            fontFamily: 'Inter',
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

  void getSharedValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mobileNumber = prefs.getString('userMobileNumber').toString();
    print("User Mobile Number Value is : $mobileNumber");
    userUpdateDetails();
  }

  void getReviewData() {
    setState(() {
      isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Get_Tailor_Review_Response_Model model =
            await CallService().getCurrentTailorReviewDetails();
        setState(() {
          isLoading = false;
          reviewData = model.data;
          print('Tailor Review Data is $reviewData');
        });
      });
    });
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        // await prefs.clear();

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
                SizedBox(
                  width: 20,
                ),
                SizedBox(
                  height: 47,
                  width: 100,
                  child: Card(
                    color: Colors.white,
                    elevation: 4,
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                          color: AppColors.newUpdateColor,
                          width: 1.5), // 🔴 Red border added
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false); // Close the dialog
                      },
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: TextStyle(
                            fontFamily: 'Inter',
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

  Future<void> updateProfile() async {
    setState(() {
      isLoading = true;
    });

    var map = <String, dynamic>{};
    map['name'] = profileNameController.text.trim().toString();
    map['profileUrl'] = objectUrl;
    map['Street'] = profileStreetController.text.trim().toString();
    map['City'] = profileCityController.text.trim().toString();
    map['State'] = profileStateController.text.trim().toString();
    map['Country'] = profileCountryController.text.trim().toString();
    map['PostalCode'] = profilePostalCodeController.text.trim().toString();

    // "name": "Veer",
    // "profileUrl": "https://darzi-test.s3.ap-south-1.amazonaws.com/Uploads/Order/image-1751961972354-se81ld.png",
    // "Street": "Sector 79",
    // "City": "Mohali",
    // "State": "Punjab",
    // "Country": "India",
    // "PostalCode": "160055"


    print("Tailor Data Map value is $map");

    try {
      Tailor_Profile_Update_Response_Model model = await CallService().updateTailorProfile(map);
      String message = model.message.toString();
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.newUpdateColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      updateUI();
      userUpdateDetails();
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Something went wrong: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  Future<void> _handleImagePickerTap(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDisclosureShown =
        prefs.getBool('permission_disclosure_shown') ?? false;

    if (!isDisclosureShown) {
      _showPermissionDisclosure(context); // Show the dialog
      await prefs.setBool('permission_disclosure_shown', true); // Set flag
    } else {
      _showImageSourceActionSheet(context); // Proceed directly
    }
  }

  void _showPermissionDisclosure(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.permission_required,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                fontSize: 20)),
        content: Text(
          AppLocalizations.of(context)!.access_camera_permission,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              //  Navigator.of(context).pop();
              //_requestCameraPermission(context);
              _showImageSourceActionSheet(context);
            },
            child: Text(
              AppLocalizations.of(context)!.access_continue,
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: AppColors
                      .newUpdateColor), // Styled like in the 3rd function
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: AppColors
                      .newUpdateColor), // Styled like in the 3rd function
            ),
          ),
        ],
      ),
    );
  }
}

