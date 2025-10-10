import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/apiData/model/aws_response_model.dart';
import 'package:darzi/apiData/model/current_tailor_detail_response.dart';
import 'package:darzi/apiData/model/get_tailor_review_response_model.dart';
import 'package:darzi/apiData/model/tailor_account_delete_response_model.dart';
import 'package:darzi/apiData/model/tailor_hide_response_model.dart';
import 'package:darzi/apiData/model/tailor_notification_disable_response_model.dart';
import 'package:darzi/apiData/model/tailor_profile_update_response_model.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/common/widgets/tailor/custom_toggle_button.dart';
import 'package:darzi/l10n/app_localizations.dart';
import 'package:darzi/pages/tailor/screens/tailor_dashboard/view/tailor_dashboard_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as p;
import '../../../../../homePage.dart';
import '../../../../../main.dart';

class TailorProfilePage extends StatefulWidget {
  final Locale locale;
  TailorProfilePage({super.key,required this.locale});

  @override
  State<TailorProfilePage> createState() => TailorProfilePageState();
}

class TailorProfilePageState extends State<TailorProfilePage> {
  int? _expandedIndex; // track open accordion
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
  bool isButtonLoading = false;
  bool isPressed = false;
  bool notificationValue = true;
  bool showNumberValue = false;
  bool deleteAccountValue = false;
  //bool hideNumber;
  bool backendHideNumber = false;
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
        Current_Tailor_Details_Response model =
        await CallService().getCurrentTailorDetails();
        setState(() {
          isLoading = false;
          enterName = model.data?.name ?? "";
          backendHideNumber = model.data?.hideMobileNo ?? false;
          notificationValue = model.data?.notificationEnabled ?? false;
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
          print("Hide Number: $backendHideNumber");
          profileNameController.text = enterName;
          profileMobileNoController.text = mobileNumber;
          profileStreetController.text = street;
          profileCityController.text = city;
          profileStateController.text = state;
          profilePostalCodeController.text = postalCode;
          profileCountryController.text = country;
        });
      });
    });
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
          print('Tailor Review Data is ${reviewData!.length}');
        });
      });
    });
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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

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
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          scrolledUnderElevation: 0,
          centerTitle: true, // 👈 Center mein title
          title: Row(
            mainAxisSize: MainAxisSize.min, // 👈 jitna content utna hi space le
            children: [
              SvgPicture.asset(
                'assets/svgIcon/account.svg',
                height: 22, // thoda size control
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.yourAccount,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.02),

              // Profile Avatar
            Row(
              children: [
                // Profile Avatar
              Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Avatar
                Stack(
                  clipBehavior: Clip.none,
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
                            width: 80,
                            height: 80,
                          )
                              : (profileUrl != null && profileUrl!.isNotEmpty)
                              ? CachedNetworkImage(
                            height: 80,
                            width: 80,
                            imageUrl: profileUrl.toString(),
                            fit: BoxFit.cover,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                  value: downloadProgress.progress,
                                  color: AppColors.newUpdateColor,
                                ),
                            errorWidget: (context, url, error) =>
                                SvgPicture.asset(
                                  'assets/svgIcon/profilepic.svg',
                                  width: 120,
                                  height: 120,
                                ),
                          )
                              : SvgPicture.asset(
                            'assets/svgIcon/profilepic.svg',
                            width: 120,
                            height: 120,
                          ),
                        ),
                      ),
                    ),

                    // ✅ Edit Icon bottom-center
                    Positioned(
                      bottom: 0, // thoda niche overlap
                      left: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () async {
                          _handleImagePickerTap(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.newUpdateColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: SvgPicture.asset(
                            'assets/svgIcon/edit.svg',
                            color: Colors.white,
                            height: 18,
                            width: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )

          ],
            ),
            SizedBox(height: height * 0.015),
              // Name
              Text(
                enterName,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Colors.black),
              ),
              SizedBox(height: height * 0.03),
              // General Details Section
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.general_details,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.black),
                ),
              ),
              SizedBox(height: height * 0.015),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ExpansionPanelList.radio(
                elevation: 0,
                expandedHeaderPadding: EdgeInsets.zero,
                expansionCallback: (index, isExpanded) {
                  setState(() {
                    _expandedIndex = isExpanded ? null : index;
                  });
                },
                children: <ExpansionPanel>[
                  // ✅ My Details hamesha show hoga
                  ExpansionPanelRadio(
                    backgroundColor: Colors.grey.shade200,
                    value: 0,
                    headerBuilder: (context, isExpanded) {
                      return ListTile(
                        title: Text(
                          AppLocalizations.of(context)!.my_details,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      );
                    },
                    body: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          _buildDetailField(label: AppLocalizations.of(context)!.userName, hintText : '',controller: profileNameController),
                          const SizedBox(height: 8),
                          _buildDetailField(
                            label: AppLocalizations.of(context)!.mobileNumber,
                            hintText: '',
                            controller: profileMobileNoController,
                            readOnly: true, // <-- yahan readOnly true kar diya
                          ),
                          const SizedBox(height: 8),
                          _buildDetailField(label:AppLocalizations.of(context)!.street,hintText: street,controller: profileStreetController),
                          const SizedBox(height: 8),
                          _buildDetailField(label:AppLocalizations.of(context)!.city,hintText: city,controller: profileCityController),
                          const SizedBox(height: 8),
                          _buildDetailField(label:AppLocalizations.of(context)!.state,hintText: state,controller: profileStateController),
                          const SizedBox(height: 8),
                          _buildDetailField(label:AppLocalizations.of(context)!.code,hintText: postalCode,controller: profilePostalCodeController),
                          const SizedBox(height: 8),
                          _buildDetailField(label:AppLocalizations.of(context)!.country,hintText: country,controller: profileCountryController),
                        ],
                      ),
                    ),
                  ),

                  // ✅ My Reviews sirf tabhi show hoga jab list empty na ho
                  if (reviewData != null && reviewData!.isNotEmpty)
                    ExpansionPanelRadio(
                      backgroundColor: Colors.grey.shade200,
                      value: 1,
                      headerBuilder: (context, isExpanded) {
                        return ListTile(
                          title: Text(
                            AppLocalizations.of(context)!.my_review,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        );
                      },
                      body:Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: reviewData!.map((review) {
                            return _buildReviewCard(
                              review.customer?.profileUrl ?? "assets/user.png",  // profile image
                              review.customer?.name ?? "Unknown",               // name
                              review.review ?? "",                              // review text
                              (review.rating ?? 0).toDouble(),                  // ⭐ rating
                              review.reviewTime?.toString() ?? "",              // ⏰ time
                              review.images ?? [],                              // 📸 images list
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                ],
              ),
            ),


            SizedBox(height: height * 0.03),

              // Notification & Alert Section
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.notification_and_alert,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.black),
                ),
              ),
              SizedBox(height: height * 0.015),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Notification Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.notifications, color: AppColors.newUpdateColor),
                          SizedBox(width: 10),
                          Text(
                            AppLocalizations.of(context)!.application_notifications,
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ],
                      ),
                      AnimatedSwitch(
                        value: notificationValue,
                        onChanged: (val) {
                          setState(() {
                            notificationValue = val;
                            print("Button is on: $notificationValue");
                            disbaleNotification(notificationValue);
                          });
                        },
                        enabledTrackColor: AppColors.newUpdateColor,
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // Show my Number Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.call, color: AppColors.newUpdateColor),
                          SizedBox(width: 10),
                          Text(
                            AppLocalizations.of(context)!.hide_my_number,
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ],
                      ),
                      AnimatedSwitch(
                        value: backendHideNumber,
                        onChanged: (val) {
                          setState(() {
                            backendHideNumber = val;
                           // backendHideNumber = backendHideNumber;
                            print("Button is on: $backendHideNumber");
                            hideMobileNumber(backendHideNumber);
                          });
                        },
                        enabledTrackColor: AppColors.newUpdateColor, // ON color
                      )

                    ],
                  ),

                  const SizedBox(height: 15),

                  // Delete Account Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children:  [
                          Icon(Icons.delete_forever, color: AppColors.newUpdateColor),
                          SizedBox(width: 10),
                          Text(
                            AppLocalizations.of(context)!.delete_account,
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ],
                      ),
                      Checkbox(
                        value: deleteAccountValue,
                        activeColor: AppColors.newUpdateColor,
                        onChanged: (val) {
                          setState(() {
                            deleteAccountValue = val ?? false;
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
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: height * 0.03),

              // Save Button
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: SizedBox(
              width: 350,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.newUpdateColor,
                  side: const BorderSide(color: Colors.white, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: isButtonLoading
                    ? null // 👈 disable button while loading
                    : () async {
                  setState(() {
                    isButtonLoading = true;
                  });
                  try {
                    await updateProfile(); // API call
                    // Fluttertoast.showToast(
                    //   msg: "Profile updated successfully!",
                    //   toastLength: Toast.LENGTH_SHORT,
                    //   gravity: ToastGravity.CENTER,
                    //   backgroundColor: AppColors.newUpdateColor,
                    //   textColor: Colors.white,
                    //   fontSize: 16.0,
                    // );
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
                      isButtonLoading = false;
                    });
                  }
                },
                child: isButtonLoading
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : Text(
                  AppLocalizations.of(context)!.saveDetails,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 19,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: SizedBox(
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
              ),
              SizedBox(
                height: 10,
              ),
              // Logout Button
            ],
          ),
        ),
      ),
    );
  }


  // My Details ka ek field widget
  Widget _buildDetailField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          readOnly: readOnly,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                color: Color(0xff454545),
                fontWeight: FontWeight.w400),// <-- yahan hintText add kar diya
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: AppColors.newUpdateColor),
            ),
          ),
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }




// Review card
  Widget _buildReviewCard(
      String image,
      String name,
      String review,
      double rating,
      String timeAgo,
      List<String> reviewImages,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Profile
          CircleAvatar(
            backgroundImage: NetworkImage(image),
            radius: 24,
          ),
          const SizedBox(width: 12),

          // ✅ Review content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + Time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      timeAgo,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // ✅ Rating bar
                RatingBarIndicator(
                  rating: rating,
                  direction: Axis.horizontal,
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: AppColors.ratingBarColor,
                  ),
                  itemCount: 5,
                  itemSize: 20.0,
                ),
                const SizedBox(height: 6),

                // ✅ Review text
                Text(
                  review,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),

                // ✅ Review images (agar hain)
                if (reviewImages.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: reviewImages.length,
                      itemBuilder: (context, imgIndex) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Image.network(
                            reviewImages[imgIndex],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.network(
                                'https://dummyimage.com/500x500/aaa/000000.png&text=No+Image',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
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
                          await prefs.clear();

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

  Future<void> hideMobileNumber(bool hideNumber) async{
    setState(() {
      isLoading = true;
    });
    var map = <String, dynamic>{};
    map['hideMobileNo'] = hideNumber;
    // map['device_fcm_token'] = deviceToken;

    print("Map value is$map");
    isLoading = true;
    try {
      Tailor_Hide_Response_Model model = await CallService().hide_tailor_number(map);
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
  Future<void> disbaleNotification(bool hideNumber) async{
    setState(() {
      isLoading = true;
    });
    var map = <String, dynamic>{};
    map['notificationEnabled'] = hideNumber;
    // map['device_fcm_token'] = deviceToken;

    print("Map value is$map");
    isLoading = true;
    try {
      Tailor_Notification_Disable_Response_Model model = await CallService().enable_tailor_number(map);
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

}
