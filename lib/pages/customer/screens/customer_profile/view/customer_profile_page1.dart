import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:darzi/apiData/all_urls/all_urls.dart';
import 'package:darzi/apiData/model/aws_response_model.dart';
import 'package:darzi/apiData/model/customer_delete_account_response_model.dart';
import 'package:darzi/apiData/model/customer_update_response_model.dart';
import 'package:darzi/apiData/model/tailor_notification_disable_response_model.dart';
import 'package:darzi/common/widgets/tailor/custom_toggle_button.dart';
import 'package:darzi/homePage.dart';
import 'package:darzi/main.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/apiData/model/current_customer_response_model.dart';
import 'package:darzi/apiData/model/update_customer_profile.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/common/all_text.dart';
import 'package:darzi/common/all_text_form_field_profile.dart';
import 'package:darzi/common/widgets/customer/common_app_bar_customer_without_back.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as p;

import '../../../../../l10n/app_localizations.dart';


class CustomerProfilePage extends StatefulWidget {
  final Locale locale;
  const CustomerProfilePage({super.key, required this.locale});


  @override
  State<CustomerProfilePage> createState() => _CustomerProfilePageState();
}

class _CustomerProfilePageState extends State<CustomerProfilePage> {
  int? _expandedIndex; // track open accordion
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isButtonLoading = false;
  bool isPressed = false;
  String userMobile = "";
  String userNameUpdate = "",fileName = "",presignedUrl = "",objectUrl = "",extensionWithoutDot = "";
  String userAddress = "",enterName = "";
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  String? profileUrl;
  bool notificationValue = true;
  bool showNumberValue = false;
  bool deleteAccountValue = false;
  final Uri _privacyPolicyUrl = Uri.parse('https://mannytechnologies.com/contact-us/');

  final TextEditingController profileNameController = TextEditingController();
  final TextEditingController profileMobileNoController = TextEditingController();
  final TextEditingController profileAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getSharedPreferenceValue();
  }

  Future<void> getSharedPreferenceValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userMobile = prefs.getString('userMobileNumber') ?? '';
    profileMobileNoController.text = userMobile;
    await userUpdateDetails();
  }

  Future<void> userUpdateDetails() async {
    setState(() => isLoading = true);

    try {
      Current_Customer_response_Model model = await CallService().getCurrentCustomerDetails();
      setState(() {
        userNameUpdate = model.data?.name ?? '';
        userAddress = model.data?.address ?? '';
        profileUrl = model.data?.profileUrl ?? '';
        enterName = model.data?.name ?? "";
        notificationValue = model.data?.notificationEnabled ?? false;
        profileNameController.text = userNameUpdate;
        profileAddressController.text = userAddress;
        print("Enable Notification: $notificationValue");
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error fetching customer details.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    } finally {
      setState(() => isLoading = false);
    }
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

  Future<void> updateProfile() async {
    setState(() {
      isLoading = true;
    });

    var map = <String, dynamic>{};
    map['name'] = profileNameController.text.trim();
    map['profileUrl'] = objectUrl;
    map['address'] = profileAddressController.text.trim();
    print("Tailor Data Map value is $map");

    try {
      Customer_Update_Response_Model model = await CallService().updateCustomerProfile(map);
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


  void updateUI() {
    setState(() {});
  }

  Future<void> callCustomerOtpVerifyApi(String userName, String address) async {
    setState(() => isLoading = true);

    try {
      var map = {'name': userName, 'address': address};
      Update_Customer_Profile_response_Model model = await CallService().customerUpdateProfile(map);

      setState(() {
        userNameUpdate = model.data?.name ?? '';
        userAddress = model.data?.address ?? '';
        profileNameController.text = userNameUpdate;
        profileAddressController.text = userAddress;
      });
      Fluttertoast.showToast(
          msg: model.message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error updating profile.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      Fluttertoast.showToast(msg: "Error updating profile.");
    } finally {
      setState(() => isLoading = false);
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


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        // Navigate to TailorDashboardNew when device back button is pressed
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => TailorDashboardNew(
        //         locale: widget.locale,
        //       )),
        // );
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
                                        width: 80,
                                        height: 80,
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
                            bottom: -6, // thoda niche overlap
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
                            _buildDetailField(label:AppLocalizations.of(context)!.userAddress,hintText: userAddress,controller: profileAddressController),
                            const SizedBox(height: 8),

                          ],
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


                    // Delete Account Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.delete_forever, color: AppColors.newUpdateColor),
                            SizedBox(width: 10),
                            Text(
                              "Delete Account",
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
                              showDeleteCustomerAlertDialog(
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
                        showCustomerAlertDialog(
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

  Widget _buildSectionLabel(String text) {
    return Row(
      children: [
        const SizedBox(width: 8),
        AllText(
          text: text,
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  Widget _buildMobileNumberField() {
    return Material(
      elevation: 10,
      shadowColor: Colors.black.withOpacity(0.2),
      borderRadius: BorderRadius.circular(30),
      child: TextFormField(
        readOnly: true,
        controller: profileMobileNoController,
        decoration: InputDecoration(
          hintText: userMobile,
          contentPadding: const EdgeInsets.only(left: 15.0),
          hintStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            color: Color(0xff454545),
            fontWeight: FontWeight.w400,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    bool isPressed = false;
    return GestureDetector(
      onTap: () async {
        await updateProfile(); // 👈 Profile update after image upload
      },
      child: Container(
        width: 350,
        height: 60,
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   colors: isPressed ? AppColors.Gradient1 : [Colors.white, Colors.white],
          // ),
          color: AppColors.newUpdateColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.newUpdateColor, width: 2),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.saveDetails,
                style: TextStyle(
                  color: Colors.white,
                  //color: isPressed ? Colors.white : AppColors.newUpdateColor,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 19,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showDeleteCustomerAlertDialog(BuildContext parentContext,
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
            AppLocalizations.of(parentContext)!.customer_account_deletion_sub_title,
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

                        Customer_Delete_Account_Response_Model model =
                        await CallService().removeCustomer(); // API call

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

  void showCustomerAlertDialog(BuildContext context, {required Locale locale, required Function(Locale) onChangeLanguage}) {
    // TextEditingController not needed as the dialog doesn't involve text input

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog (
          backgroundColor: Colors.white,
          title: Container(
              margin:  const EdgeInsets.only(left: 16),
              child: Text(AppLocalizations.of(context)!.logOutConfirmation,style: TextStyle(fontWeight: FontWeight.w600,fontFamily: 'Poppins',fontSize: 20),)),
          content:  Container(
            //margin:  const EdgeInsets.only(left: 16),
              child: Text(AppLocalizations.of(context)!.logOutConfirmationMessage,style: TextStyle(fontWeight: FontWeight.w400,fontFamily: 'Inter',fontSize: 16,color: Colors.grey))),
          actions: [
            Container(
              child: Row(mainAxisAlignment: MainAxisAlignment.center,
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
                          style:
                          ElevatedButton.styleFrom(backgroundColor: AppColors.newUpdateColor),
                          onPressed: () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
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
                            final setLocale = MyApp.of(context)?.setLocale;

                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => HomePage(
                                  onChangeLanguage: setLocale ?? (locale) {},
                                ),
                              ),
                                  (route) => false,
                            );

                          },
                          child:  Text(
                            AppLocalizations.of(context)!.yesMessage,
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color:
                                Colors.white), // Styled like in the 3rd function
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
                          borderRadius:
                          BorderRadius.circular(8),
                          side: BorderSide(color: AppColors.newUpdateColor, width: 1.5),
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
                                color: AppColors.newUpdateColor), // Styled like in the 3rd function
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleImagePickerTap(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDisclosureShown = prefs.getBool('permission_disclosure_shown') ?? false;

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
        title: Text(AppLocalizations.of(context)!.permission_required,style: TextStyle(fontWeight: FontWeight.w600,fontFamily: 'Poppins',fontSize: 20)),
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
                  color: AppColors.newUpdateColor), // Styled like in the 3rd function
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
                  color: AppColors.newUpdateColor), // Styled like in the 3rd function
            ),
          ),
        ],
      ),
    );
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
      Tailor_Notification_Disable_Response_Model model = await CallService().enable_customer_number(map);
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