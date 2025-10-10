import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:darzi/apiData/all_urls/all_urls.dart';
import 'package:darzi/apiData/model/aws_response_model.dart';
import 'package:darzi/apiData/model/customer_delete_account_response_model.dart';
import 'package:darzi/apiData/model/customer_update_response_model.dart';
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
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isPressed = false;
  String userMobile = "";
  String userNameUpdate = "",fileName = "",presignedUrl = "",objectUrl = "",extensionWithoutDot = "";
  String userAddress = "";
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  String? profileUrl = "";
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
        profileNameController.text = userNameUpdate;
        profileAddressController.text = userAddress;
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarCustomerWithOutBack(
        title: AppLocalizations.of(context)!.yourAccount,
        hasBackButton: true,
        elevation: 2.0,
        leadingIcon: SvgPicture.asset(
          'assets/svgIcon/account.svg',
          color: Colors.black,
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.newUpdateColor))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              SafeArea(
                child: Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomCenter,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          // var cameraStatus =
                          // await Permission.camera.request();
                          // if (cameraStatus.isGranted) {
                          //   _showImageSourceActionSheet(context);
                          // } else {
                          //   print("Camera permission denied");
                          // }
                          //_showPermissionDisclosure(context);
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
                                : (profileUrl!= null &&
                                profileUrl!.isNotEmpty)
                                ? CachedNetworkImage(
                              height: 120,
                              width: 120,
                              imageUrl: profileUrl!,
                              fit: BoxFit.cover,
                              progressIndicatorBuilder: (context,
                                  url,
                                  downloadProgress) =>
                                  CircularProgressIndicator(
                                    value: downloadProgress
                                        .progress,
                                    color: AppColors.newUpdateColor,
                                  ),
                              errorWidget:
                                  (context, url, error) =>
                                  SvgPicture.asset(
                                    'assets/svgIcon/profilepic.svg', // Default profile icon
                                    width: 120,
                                    height: 120,
                                  ),
                            )
                                : SvgPicture.asset(
                              'assets/svgIcon/profilepic.svg', // Default profile icon
                              width: 120,
                              height: 120,
                            ),
                          ),
                        ),
                      ),

                      // Edit Button
                      GestureDetector(
                        onTap: () async {
                          // var cameraStatus =
                          // await Permission.camera.request();
                          // if (cameraStatus.isGranted) {
                          //   print(
                          //       "Camera and Gallery permission granted");
                          //   _showImageSourceActionSheet(context);
                          // } else {
                          //   print("Camera permission denied");
                          // }
                          _handleImagePickerTap(context);
                          //_showPermissionDisclosure(context);
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
                              child: Icon(Icons.edit,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),
              _buildSectionLabel(AppLocalizations.of(context)!.userName),
              AllProfileTextFormField(
                mController: profileNameController,
                readOnly: false,
                hintText: '',
              ),
              const SizedBox(height: 20),
              _buildSectionLabel(AppLocalizations.of(context)!.mobileNumber),
              _buildMobileNumberField(),
              const SizedBox(height: 20),
              _buildSectionLabel(AppLocalizations.of(context)!.userAddress),
              AllProfileTextFormField(
                mController: profileAddressController,
                readOnly: false,
                hintText: '',
              ),
              const SizedBox(height: 20),
              _buildSaveButton(context),
              SizedBox(height: 10,),
              SizedBox(
                width: 350,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.newUpdateColor,
                    //side: BorderSide(color: AppColors.newUpdateColor, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // <-- Rounded corners
                    ),
                  ),
                  onPressed: () {
                    showCustomerAlertDialog(
                      context,
                      locale: widget.locale,
                      onChangeLanguage: (newLocale) {
                        // Handle the language change
                        print("Language changed to: ${newLocale.languageCode}");
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
                      SizedBox(width: 3),
                      SvgPicture.asset("assets/svgIcon/logout.svg",color: Colors.white,),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30,),
              SizedBox(height: 30,),
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
                        text: AppLocalizations.of(context)!.delete_account + '  ', // Add a space here
                      ),
                      TextSpan(
                        text: AppLocalizations.of(context)!.contact_us,
                        style: TextStyle(
                          color: AppColors.newUpdateColor,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
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
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
}