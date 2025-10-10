import 'dart:convert';
import 'dart:io';
import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/apiData/model/add_new_customer_order_response_model.dart' show Add_New_Customer_Order_Response_Model;
import 'package:darzi/apiData/model/aws_response_model.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/common/all_text.dart';
import 'package:darzi/common/all_text_form_field.dart';
import 'package:darzi/common/all_text_form_field1.dart';
import 'package:darzi/common/widgets/tailor/common_app_bar_with_back.dart';
import 'package:darzi/constants/string_constant.dart';
import 'package:darzi/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../apiData/all_urls/all_urls.dart';
import 'package:path/path.dart' as p;


class AddNewDress extends StatefulWidget {
  final BuildContext context;
  final String customerId;
  final Locale locale;
  const AddNewDress(this.context, this.customerId, this.locale, {super.key});

  @override
  State<AddNewDress> createState() => _AddNewDressState();
}

class _AddNewDressState extends State<AddNewDress> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController dressNameController = TextEditingController();
  final TextEditingController stitchingCostController = TextEditingController();
  final TextEditingController advancedCostController = TextEditingController();
  final TextEditingController outStandingBalancedController = TextEditingController();
  final TextEditingController textarea = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  String formattedDate = "", customerId = "",fileName = "",presignedUrl = "",objectUrl = "",extensionWithoutDot = "";
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool _isImageSelected = false;
  bool isPressed = false;
  bool isLoading = false;

  @override
  void dispose() {
    stitchingCostController.removeListener(calculateOutstandingBalance);
    advancedCostController.removeListener(calculateOutstandingBalance);
    stitchingCostController.dispose();
    advancedCostController.dispose();
    outStandingBalancedController.dispose();
    super.dispose();
  }

  // Method to calculate outstanding balance
  void calculateOutstandingBalance() {
    double stitchingCost = double.tryParse(stitchingCostController.text) ?? 0.0;
    double advance = double.tryParse(advancedCostController.text) ?? 0.0;
    double outstanding = stitchingCost - advance;

    outStandingBalancedController.text = outstanding.toStringAsFixed(2);
  }

  bool _isFormDirty() {
    return nameController.text.isNotEmpty ||
        mobileNoController.text.isNotEmpty ||
        dressNameController.text.isNotEmpty ||
        dueDateController.text.isNotEmpty ||
        stitchingCostController.text.isNotEmpty ||
        advancedCostController.text.isNotEmpty ||
        outStandingBalancedController.text.isNotEmpty ||
        textarea.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    stitchingCostController.addListener(calculateOutstandingBalance);
    advancedCostController.addListener(calculateOutstandingBalance);
    setState(() {
      customerId = widget.customerId.toString();
      print("CustomerId is $customerId");
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isFormDirty()) {
          bool? shouldPop = await showWarningMessage(
            context,
            locale: widget.locale,
            onChangeLanguage: (newLocale) {
              print("Language changed to: ${newLocale.languageCode}");
            },
          );
          return shouldPop ?? false;
        } else {
          return true; // Allow pop without warning
        }
      },
      child: Container(
        color: Colors.white,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.addNewDress,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
              textAlign: TextAlign.center,),
            centerTitle: true, // 👈 yeh add karo
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () async {
                    if (_isFormDirty()) {
                      bool? shouldPop = await showWarningMessage(
                        context,
                        locale: widget.locale,
                        onChangeLanguage: (newLocale) {
                          print("Language changed to: ${newLocale.languageCode}");
                        },
                      );
                      print("pop up value is $shouldPop");
                      if (shouldPop == true) {
                        Navigator.pop(context);
                      }
                    } else {
                      Navigator.pop(context); // No warning if form untouched
                    }
                    //Navigator.pop(widget.context);
              },
            ),
          ),
          // CustomAppBarWithBack(
          //   title: AppLocalizations.of(context)!.addNewDress,
          //   hasBackButton: true,
          //   leadingIcon: SvgPicture.asset(
          //     'assets/svgIcon/add.svg',
          //   ),
          //   onBackButtonPressed: () async {
          //     if (_isFormDirty()) {
          //       bool? shouldPop = await showWarningMessage(
          //         context,
          //         locale: widget.locale,
          //         onChangeLanguage: (newLocale) {
          //           print("Language changed to: ${newLocale.languageCode}");
          //         },
          //       );
          //       print("pop up value is $shouldPop");
          //       if (shouldPop == true) {
          //         Navigator.pop(context);
          //       }
          //     } else {
          //       Navigator.pop(context); // No warning if form untouched
          //     }
          //     //Navigator.pop(widget.context);
          //   },
          // ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: Column(children: [
                Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: AllText(
                            text: AppLocalizations.of(context)!.dressName,
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                    SizedBox(width: 8),
                    Expanded(
                        flex: 3,
                        child: Container(
                          margin: EdgeInsets.only(right: 5),
                          child: AllTextFormField1(
                            inputType: TextInputType.text,
                            hintText:
                            AppLocalizations.of(context)!.enterDressName,
                            mController: dressNameController,
                            readOnly: false,
                          ),
                        )),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Label
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          AppLocalizations.of(context)!.dressPhoto,
                          style: TextStyle(
                            fontFamily: 'Popins',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                        flex: 3,
                        child: GestureDetector(onTap: () async {
                          _handleImagePickerTap(context);
                        },
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6), // halka sa rounded corner
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.8), // halka shadow
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 2), // shadow niche ki taraf
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Text(
                                      AppLocalizations.of(context)!.addImage,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 11,
                                        color: AppColors.newUpdateColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: Icon(
                                      Icons.add_circle_outline_sharp,
                                      size: 15,
                                      color: AppColors.newUpdateColor,
                                    ),
                                  ),
                                ],
                              ),
                            )

                        )),
                  ],
                ),
                SizedBox(height: 8),
                if (_isImageSelected)
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(left: 30),
                      child: Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                            width: 120,
                            height: 120,
                          ),
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 8),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          flex: 2,
                          child: AllText(
                              text: AppLocalizations.of(context)!.dueDate,
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              fontWeight: FontWeight.w500)),
                      SizedBox(width: 8),
                      Expanded(
                        flex: 3,
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              print("Field is tapped");});
                            //_pickedImages(context);
                          },
                          child: Material(
                            elevation: 4,
                            child: TextFormField(
                              onTap: () async {
                                DateTime? pickedDate =
                                await showDatePicker(context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2100),
                                    builder: (context, child){
                                      return Theme(data: Theme.of(context).copyWith(
                                          colorScheme:  ColorScheme.light(primary: AppColors.newUpdateColor,onPrimary: Colors.white,onSurface: Colors.black,)
                                      ), child: child!);
                                    });
                                if (pickedDate != null) {
                                  print(pickedDate);
                                  formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                  print("Date Value is : $formattedDate");
                                  setState(() {dueDateController.text = formattedDate;});
                                  value:formattedDate;}
                                if (pickedDate != null) {
                                  formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                  dueDateController.text = formattedDate;
                                }
                              },
                              readOnly: true,
                              controller: dueDateController,
                              // decoration: InputDecoration(
                              //   hintText:
                              //   formattedDate.isEmpty ? AppLocalizations.of(context)!.noDateSelected : formattedDate.toString(),
                              //   contentPadding: EdgeInsets.only(left: 15.0),
                              //   hintStyle: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: Color(0xff454545), fontWeight: FontWeight.w400),
                              //   border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none), filled: true, fillColor: Colors.white,
                              // ),
                              decoration: InputDecoration(
                                hintText: formattedDate.isEmpty ? AppLocalizations.of(context)!.noDateSelected : formattedDate.toString(),
                                contentPadding: EdgeInsets.only(left: 15.0),
                                hintStyle: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11,
                                  color: Color(0xff454545),
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                // Container(
                //   margin: EdgeInsets.only(left: 10, right: 5),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Expanded(
                //           flex: 2,
                //           child: AllText(
                //               text:
                //               AppLocalizations.of(context)!.stitchingCost1,
                //               fontFamily: 'Poppins',
                //               fontSize: 15,
                //               fontWeight: FontWeight.w500)),
                //       SizedBox(width: 8),
                //       Expanded(
                //           flex: 3,
                //           child: AllTextFormField(
                //             inputType: TextInputType.number,
                //             hintText: '₹',
                //             mController: stitchingCostController,
                //             readOnly: false,
                //           )),
                //     ],
                //   ),
                // ),
                // SizedBox(height: 8),
                // Container(
                //   margin: EdgeInsets.only(left: 10, right: 5),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Expanded(
                //           flex: 2,
                //           child: AllText(
                //               text: AppLocalizations.of(context)!.advancedCost,
                //               fontFamily: 'Poppins',
                //               fontSize: 15,
                //               fontWeight: FontWeight.w500)),
                //       SizedBox(width: 8),
                //       Expanded(
                //           flex: 3,
                //           child: AllTextFormField(
                //             inputType: TextInputType.number,
                //             hintText: '₹',
                //             mController: advancedCostController,
                //             readOnly: false,
                //           )),
                //     ],
                //   ),
                // ),
                // SizedBox(height: 8),
                // Container(
                //   margin: EdgeInsets.only(left: 10, right: 5),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Expanded(
                //           flex: 2,
                //           child: AllText(
                //               text: AppLocalizations.of(context)!.outstandingBalance1,
                //               fontFamily: 'Poppins',
                //               fontSize: 15,
                //               fontWeight: FontWeight.w500)),
                //       SizedBox(width: 8),
                //       Expanded(
                //           flex: 3,
                //           child: AllTextFormField(
                //             inputType: TextInputType.number,
                //             hintText: '₹',
                //             mController: outStandingBalancedController,
                //             readOnly: false,
                //           )),
                //     ],
                //   ),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(flex: 2,
                        child: AllText(text: AppLocalizations.of(context)!.stitchingCost1, fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w500)),
                    SizedBox(width: 8),
                    Expanded(flex: 3,
                        child: AllTextFormField1(inputType: TextInputType.text, hintText: "₹", mController: stitchingCostController, readOnly: false,)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(flex: 2,
                        child: AllText(text: AppLocalizations.of(context)!.advancedCost, fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w500)),
                    SizedBox(width: 8),
                    Expanded(flex: 3,
                        child: AllTextFormField1(inputType: TextInputType.text, hintText: "₹", mController: advancedCostController, readOnly: false,)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(flex: 2,
                        child: AllText(text: AppLocalizations.of(context)!.outstandingBalance1, fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w500)),
                    SizedBox(width: 8),
                    Expanded(flex: 3,
                        child: AllTextFormField1(inputType: TextInputType.text, hintText: "₹", mController: outStandingBalancedController, readOnly: false,)),
                  ],
                ),
                SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.notes,
                        style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 14),),

                      SizedBox(height: 5,),
                      TextField(controller: textarea,
                        keyboardType: TextInputType.multiline, maxLines: 4, maxLength: 500,
                        decoration: InputDecoration(hintText: AppLocalizations.of(context)!.textHere, enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey, width: 0.0),),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.0, color: Colors.grey))),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () async {
                    if (dressNameController.text.isEmpty &&
                        dueDateController.text.isEmpty &&
                        stitchingCostController.text.isEmpty &&
                        !_isImageSelected) {
                      Fluttertoast.showToast(
                        msg: AppLocalizations.of(context)!.validationMessage,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: AppColors.newUpdateColor,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      return;
                    }

                    if (dressNameController.text.isEmpty) {
                      Fluttertoast.showToast(
                        msg: AppLocalizations.of(context)!.enterDressName,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: AppColors.newUpdateColor,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      return;
                    }

                    if (!_isImageSelected) {
                      Fluttertoast.showToast(
                        msg: AppLocalizations.of(context)!.selectImage,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: AppColors.newUpdateColor,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      return;
                    }

                    if (dueDateController.text.isEmpty) {
                      Fluttertoast.showToast(
                        msg: AppLocalizations.of(context)!.enterDueDate,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: AppColors.newUpdateColor,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      return;
                    }

                    if (stitchingCostController.text.isEmpty) {
                      Fluttertoast.showToast(
                        msg: AppLocalizations.of(context)!.enterStitchingCost,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: AppColors.newUpdateColor,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      return;
                    }

                    setState(() {
                      isLoading = true;
                    });

                    await getAwsUrl(); // this method already ends with setState(() => isLoading = false)
                  },
                  child: Container(
                    width: 350,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.newUpdateColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: isLoading
                          ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2,
                        ),
                      )
                          : Text(
                        AppLocalizations.of(context)!.saveDetails1,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 19,
                        ),
                      ),
                    ),
                  ),
                ),

              ]),
            ),
          ),
        ),
      ),
    );
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
              title: Text(AppLocalizations.of(context)!.appCamera),
              onTap: () async {
                final XFile? photo =
                await _picker.pickImage(source: ImageSource.camera);

                if (photo != null) {
                  setState(() {
                    _selectedImage = File(photo.path);
                    fileName = p.basename(photo.path); // Get file name with extension
                    String extension = p.extension(photo.path); // Get extension with dot
                    extensionWithoutDot = extension.substring(1); // Remove dot
                    _isImageSelected = true;
                    print("File Name: $fileName");
                    print("File Extension (with dot): $extension");
                    print("File Extension (without dot): $extensionWithoutDot");
                  });

                }
                Navigator.pop(context); // Close the modal after action
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: Colors.black),
              title: Text(AppLocalizations.of(context)!.appGallery),
              onTap: () async {
                final XFile? photo =
                await _picker.pickImage(source: ImageSource.gallery);

                if (photo != null) {
                  setState(() {
                    _selectedImage = File(photo.path);
                    fileName = p.basename(photo.path); // Get file name with extension
                    String extension = p.extension(photo.path); // Get extension with dot
                    extensionWithoutDot = extension.substring(1); // Remove dot
                    _isImageSelected = true;
                    print("File Name: $fileName");
                    print("File Extension (with dot): $extension");
                    print("File Extension (without dot): $extensionWithoutDot");
                  });
                }
                Navigator.pop(context); // Close the modal after action
              },
            ),
          ],
        );
      },
    );
  }

  // ✅ Warning Dialog Function
  Future<bool?> showWarningMessage(BuildContext context,
      {required Locale locale,
        required Function(Locale) onChangeLanguage}) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Container(
            margin: const EdgeInsets.only(left: 16),
            child: Text(
              AppLocalizations.of(context)!.unsaved_changes,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  fontSize: 20),
            ),
          ),
          content: Container(
            child: Text(
              AppLocalizations.of(context)!.unsaved_changes_warningMessage,
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
                      side: BorderSide(color: AppColors.newUpdateColor, width: 1.5),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pop(true); // Close dialog and return true
                      },
                      child: Text(
                        AppLocalizations.of(context)!.yesMessage,
                        style: TextStyle(fontFamily: 'Inter',fontSize: 18,fontWeight: FontWeight.w600,color: Colors.white),
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
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: AppColors.newUpdateColor, width: 1.5),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pop(false); // Close the dialog
                      },
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: TextStyle(fontFamily: 'Inter',fontSize: 18,fontWeight: FontWeight.w600,color: AppColors.newUpdateColor),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      },
    ) ??
        false; // Agar null return ho to false return karo
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
        await addNewDressForSpecificCustomer(); // 👈 Profile update after image upload
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

  Future<void> addNewDressForSpecificCustomer() async {
    setState(() {
      isLoading = true;
    });
    var map = <String, dynamic>{};
    map['customerId'] = customerId;
    map['dressImgUrl'] = objectUrl;
    map['dueDate'] = formattedDate;
    map['stitchingCost'] = stitchingCostController.text.trim();
    map['advanceReceived'] = advancedCostController.text.isEmpty
        ? "00"
        : advancedCostController.text.trim();
    map['outstandingBalance'] = outStandingBalancedController.text.isEmpty
        ? "00"
        : outStandingBalancedController.text.trim();
    map['notes'] = textarea.text.trim();
    map['dressName'] = dressNameController.text.trim();

    print("Tailor Data Map value is $map");

    try {
      Add_New_Customer_Order_Response_Model model = await CallService().addNewCustomerOrder(map);
      String message = model.message?.toString() ?? "Customer Order Created Successfully !!";
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.newUpdateColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // Clear all fields
      nameController.clear();
      stitchingCostController.clear();
      advancedCostController.clear();
      outStandingBalancedController.clear();
      textarea.clear();
      dressNameController.clear();
      dueDateController.clear();
      formattedDate = "";
      fileName = "";
      _selectedImage = null;
      _isImageSelected = false; // Reset the flag

    } catch (e) {
      print("Error in addCustomerMethod: ${e.toString()}");
      Fluttertoast.showToast(
        msg: "Something went wrong. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

}