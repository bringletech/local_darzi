import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/apiData/model/speicific_customer_mearsure_model.dart';
import 'package:darzi/apiData/model/update_customer_measurement_details_model.dart';
import 'package:darzi/apiData/model/verify_mobile_model.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/common/all_text.dart';
import 'package:darzi/common/all_text_form_field.dart';
import 'package:darzi/common/all_text_form_field1.dart';
import 'package:darzi/common/widgets/tailor/commAddCustTextField.dart';
import 'package:darzi/common/widgets/tailor/common_app_bar_with_back.dart';
import 'package:darzi/common/widgets/tailor/custom_toggle_button.dart';
import 'package:darzi/constants/string_constant.dart';
import 'package:darzi/l10n/app_localizations.dart';
import 'package:darzi/pages/tailor/screens/tailor_add_customer/view/add_customer1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class MeasurementsScreen extends StatefulWidget {
  final BuildContext context;
  final String customerId;
  final Locale locale;
  MeasurementsScreen(this.context,this.customerId,this.locale, {super.key});
  //const MeasurementsScreen({super.key, required this.customerId});

  @override
  State<MeasurementsScreen> createState() => _MeasurementsScreenState();
}

class _MeasurementsScreenState extends State<MeasurementsScreen> {
  bool selectValue = false;
  bool isPressed = false;
  final FocusNode _focusNode = FocusNode();
  String name = "",mobileNumber = "",optional = "", neck = "",bust = "",underBust = "",waist = "",
      hips = "", neckToAboveKnee = "", armLength = "", shoulderSeam = "", armHole = "",
      bicep = "", foreArm = "", wrist = "", ankle = "",shoulderToWaist = "",bottomLength = "",
      neck1 = "",bust1 = "",underBust1 = "",waist1 = "",
      hips1 = "", neckToAboveKnee1 = "", armLength1 = "", shoulderSeam1 = "", armHole1 = "",
      bicep1 = "", foreArm1 = "", wrist1 = "", ankle1 = "",shoulderToWaist1 = "",
      bottomLength1 = "",message = "",created_at = "", last_updated_at = "";
  String? notes;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController neckController = TextEditingController();
  final TextEditingController bustController = TextEditingController();
  final TextEditingController underBustController = TextEditingController();
  final TextEditingController waistController = TextEditingController();
  final TextEditingController hipsController = TextEditingController();
  final TextEditingController neckToAboveKneeController = TextEditingController();
  final TextEditingController armLengthController = TextEditingController();
  final TextEditingController shoulderSeamController = TextEditingController();
  final TextEditingController armHoleController = TextEditingController();
  final TextEditingController bicepController = TextEditingController();
  final TextEditingController foreArmController = TextEditingController();
  final TextEditingController wristController = TextEditingController();
  final TextEditingController shoulderToWaistController = TextEditingController();
  final TextEditingController bottomLengthController = TextEditingController();
  final TextEditingController ankleController = TextEditingController();
  TextEditingController textarea = TextEditingController();
  bool isLoading = false;
  bool _isRefreshed = false;

  String _convertToCm(String value) {
    if (value.isEmpty) return '';
    try {
      double inches = double.parse(value);
      double cm = inches * 2.54;
      return cm.toStringAsFixed(2); // Rounded to 2 decimal places
    } catch (e) {
      return value; // Return original value if parsing fails
    }
  }

  String _convertToInches(String value) {
    if (value.isEmpty) return '';
    try {
      double cm = double.parse(value);
      double inches = cm / 2.54;
      return inches.toStringAsFixed(2); // Rounded to 2 decimal places
    } catch (e) {
      return value; // Return original value if parsing fails
    }
  }

  _checkInput(String input) {
    if (input.length == 10) {
      _callVerifyMobile(input);
      // Optionally unfocus the TextField after 10 digits
      _focusNode.unfocus();
    } else if (input.length < 10) {
      setState(() {
        message = ""; // Hide the "Number is already registered" box
      });
    }
  }

  _callVerifyMobile(String input) {
    setState(() {
      isLoading = true;
      var map = Map<String, dynamic>();
      map['mobileNo'] = input.toString();
      print("Map value is $map");
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Mobile_Verify_Model model =
        await CallService().verifyCustomerMobile(map);
        setState(() {
          isLoading = false;
          message = model.message.toString();
          print("Message received: $message");
        });
      });
    });
  }

  bool _isFormDirty() {
    return nameController.text.isNotEmpty ||
        mobileNoController.text.isNotEmpty ||
        neckController.text.isNotEmpty ||
        bustController.text.isNotEmpty ||
        underBustController.text.isNotEmpty ||
        waistController.text.isNotEmpty ||
        hipsController.text.isNotEmpty ||
        neckToAboveKneeController.text.isNotEmpty ||
        armLengthController.text.isNotEmpty ||
        shoulderSeamController.text.isNotEmpty ||
        armHoleController.text.isNotEmpty ||
        bicepController.text.isNotEmpty ||
        foreArmController.text.isNotEmpty ||
        wristController.text.isNotEmpty ||
        shoulderToWaistController.text.isNotEmpty ||
        bottomLengthController.text.isNotEmpty ||
        ankleController.text.isNotEmpty;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      updateMeasurementDetails();
    });
  }


// Share function
  void shareMeasurementDetails() {
    final now = DateTime.now();
    final formattedDate = DateFormat('dd-yy-MMMM').format(now);
    final formattedTime = DateFormat('hh:mm a').format(now);

    String measurementDetails = '''
  Your measurement recorded on $formattedDate at $formattedTime is:
  - Neck: ${neckController.text}
  - Bust: ${bustController.text}
  - Under Bust: ${underBustController.text}
  - Waist: ${waistController.text}
  - Hips: ${hipsController.text}
  - Neck to Above Knee: ${neckToAboveKneeController.text}
  - Arm Length: ${armLengthController.text}
  - Shoulder Seam: ${shoulderSeamController.text}
  - Arm Hole: ${armHoleController.text}
  - Bicep: ${bicepController.text}
  - Forearm: ${foreArmController.text}
  - Wrist: ${wristController.text}
  - Shoulder to Waist: ${shoulderToWaistController.text}
  - Bottom Length: ${bottomLengthController.text}
  - Ankle: ${ankleController.text}
  - Notes: ${textarea.text}
  ''';

    Share.share(measurementDetails);
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
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.measurements,
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
            },
          ),
        ),
        // CustomAppBarWithBack(
        //   onBackButtonPressed:() async {
        //     //Navigator.pop(widget.context,true);
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
        //   },
        //   title: AppLocalizations.of(context)!.measurements,
        //   hasBackButton: true,
        //   leadingIcon: SvgPicture.asset('assets/svgIcon/measurement.svg',),
        // ),
        body: isLoading == true?Center(child: CircularProgressIndicator(color: AppColors.newUpdateColor,)):SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.last_update,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              fontSize: 19,
                              color: AppColors.newUpdatedColor,
                            ),
                          ),
                          Text(
                            last_updated_at.isEmpty?created_at:last_updated_at,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 19,
                              color: AppColors.newUpdatedColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: SizedBox(
                        width: 300,
                        height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // White background
                            side: BorderSide(
                              color: AppColors.newUpdateColor, // Orange border
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            shareMeasurementDetails();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/svgIcon/share_icon.svg",
                                color: Colors.black, // Orange icon (to match border)
                              ),
                              const SizedBox(width: 6),
                              Text(
                                AppLocalizations.of(context)!.share_details,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 19,
                                  color: Colors.black, // Orange text
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ),
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              flex: 2,
                              child: AllText(text: AppLocalizations.of(context)!.userName, fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w500,)),
                          SizedBox(width: 8),
                          Expanded(
                              flex: 3,
                              child: AllTextFormField1(inputType: TextInputType.text, hintText: AppLocalizations.of(context)!.enterName, mController: nameController, readOnly: false,)
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: AllText(text: AppLocalizations.of(context)!.mobileNumber, fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w500,),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Material(
                                      elevation: 8, shadowColor: Colors.black.withOpacity(0.8), borderRadius: BorderRadius.circular(0),
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) => _checkInput(value),
                                        readOnly: false,
                                        focusNode: _focusNode,
                                        controller: mobileNoController,
                                        decoration: InputDecoration(
                                          hintMaxLines: 1,
                                          hintText: AppLocalizations.of(context)!.enterMobileNumber,
                                          contentPadding: EdgeInsets.only(left: 15.0),
                                          hintStyle: TextStyle(fontFamily: 'Inter', fontSize: 11, color: Color(0xff454545), fontWeight: FontWeight.w400,),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30),borderSide: BorderSide.none,),
                                          filled: true,
                                          fillColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                    if (isLoading)
                                      Positioned(
                                        right: 8.0,
                                        top: 12.0,
                                        child: SizedBox(width: 24, height: 24,
                                          child: CircularProgressIndicator(strokeWidth: 2.0),
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 3),
                                // Debugging Text
                                //Text("Current message: $message", style: TextStyle(color: Colors.red)),
                                if (message.contains("Number registered on Darzi App")&& message.isNotEmpty)
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.green),
                                    ),
                                    child: Text(
                                      message,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.newUpdateColor,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        AppLocalizations.of(context)!.howToMeasure,
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AnimatedSwitch(
                            value: selectValue,  // The current toggle state
                            onChanged: (val) {
                              setState(() {
                                selectValue = val;
                                optional = selectValue ? "cm" : "inch";
                                print("Optional value is: $optional");
                                print("Toggle value is: $selectValue");
                              });
                            },
                            enabledTrackColor: AppColors.newUpdateColor,  // Custom color for the active state
                          ),
                          const SizedBox(width: 10),
                          Text(
                            optional,
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          // Container(
                          //   //color: Colors.black,
                          //   margin: EdgeInsets.all(0),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Expanded(
                          //         child: Container(
                          //           // color : Colors.cyan,
                          //           decoration: BoxDecoration(
                          //               borderRadius: BorderRadius.circular(10),
                          //               color: Colors.white
                          //           ),
                          //           child: Column(
                          //             crossAxisAlignment: CrossAxisAlignment.start,
                          //             children: [
                          //               Commonaddcusttextfield(text: AppLocalizations.of(context)!.neck,hintText: "",controller: neckController,inputType: TextInputType.number,),
                          //               SizedBox(height: 25,),
                          //               Commonaddcusttextfield(text: AppLocalizations.of(context)!.bust,hintText: "",controller: bustController,inputType: TextInputType.number),
                          //               SizedBox(height: 25,),
                          //               Commonaddcusttextfield(text: AppLocalizations.of(context)!.underBust,hintText: "",controller: underBustController,inputType: TextInputType.number),
                          //               SizedBox(height: 25,),
                          //               Commonaddcusttextfield(text: AppLocalizations.of(context)!.waist,hintText: "",controller: waistController,inputType: TextInputType.number),
                          //               SizedBox(height: 25,),
                          //               Commonaddcusttextfield(text: AppLocalizations.of(context)!.hips,hintText: "",controller: hipsController,inputType: TextInputType.number),
                          //               SizedBox(height: 25,),
                          //               Commonaddcusttextfield(text: AppLocalizations.of(context)!.neckAbove,hintText: "",controller: neckToAboveKneeController,inputType: TextInputType.number),
                          //               SizedBox(height: 25),
                          //               Commonaddcusttextfield(text: AppLocalizations.of(context)!.armLength,hintText: "",controller: armLengthController,inputType: TextInputType.number),
                          //               SizedBox(height: 25,),
                          //               Commonaddcusttextfield(text: AppLocalizations.of(context)!.shoulderSeam,hintText: "",controller: shoulderSeamController,inputType: TextInputType.number),
                          //               SizedBox(height: 25,),
                          //               Commonaddcusttextfield(text: AppLocalizations.of(context)!.armHole,hintText: "",controller: armHoleController,inputType: TextInputType.number),
                          //               SizedBox(height: 25,),
                          //               Commonaddcusttextfield(text: AppLocalizations.of(context)!.bicep,hintText: "",controller: bicepController,inputType: TextInputType.number),
                          //               SizedBox(height: 25,),
                          //               Commonaddcusttextfield(text: AppLocalizations.of(context)!.foreArm,hintText: "",controller: foreArmController,inputType: TextInputType.number),
                          //               SizedBox(height: 25,),
                          //               Commonaddcusttextfield(text: AppLocalizations.of(context)!.wrist,hintText: "",controller: wristController,inputType: TextInputType.number),
                          //               SizedBox(height: 25,),
                          //               Commonaddcusttextfield(text: AppLocalizations.of(context)!.shoulderWaist,hintText: "",controller: shoulderToWaistController,inputType: TextInputType.number),
                          //               SizedBox(height: 25,),
                          //               Commonaddcusttextfield(text: AppLocalizations.of(context)!.bottomLength,hintText: "",controller: bottomLengthController,inputType: TextInputType.number),
                          //               SizedBox(height: 25,),
                          //               Commonaddcusttextfield(text: AppLocalizations.of(context)!.ankle,hintText: "",controller: ankleController,inputType: TextInputType.number),
                          //               SizedBox(height: 25,),
                          //               Text(
                          //                 AppLocalizations.of(context)!.notes,
                          //                 style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 14),),
                          //               SizedBox(height: 5,),
                          //               TextField(controller: textarea,
                          //                 keyboardType: TextInputType.multiline, maxLines: 4, maxLength: 500,
                          //                 decoration: InputDecoration(hintText: AppLocalizations.of(context)!.textHere, enabledBorder: const OutlineInputBorder(
                          //                   borderSide: const BorderSide(color: Colors.grey, width: 0.0),),
                          //                     focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.0, color: Colors.grey))),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          //
                          // ),
                          Container(
                            margin: EdgeInsets.all(0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: MeasurementField(label: AppLocalizations.of(context)!.neck, controller: neckController,inputType: TextInputType.number,)),
                                    const SizedBox(width: 20),
                                    Expanded(child: MeasurementField(label: AppLocalizations.of(context)!.bust, controller: bustController,inputType: TextInputType.number,)),
                                    // const SizedBox(width: 12),
                                    // Expanded(child: MeasurementField(label: AppLocalizations.of(context)!.underBust, controller: underBustController,inputType: TextInputType.number,)),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // Row 2
                                Row(
                                  children: [
                                    Expanded(child: MeasurementField(label: AppLocalizations.of(context)!.underBust, controller: underBustController,inputType: TextInputType.number,)),
                                    const SizedBox(width: 20),
                                    Expanded(child: MeasurementField(label: AppLocalizations.of(context)!.waist, controller: waistController,inputType: TextInputType.number,)),
                                    // Expanded(child: MeasurementField(label:  AppLocalizations.of(context)!.hips, controller: hipsController,inputType: TextInputType.number,)),
                                    // const SizedBox(width: 12),
                                    // Expanded(child: MeasurementField(label: AppLocalizations.of(context)!.neckAbove, controller: wristController,inputType: TextInputType.number,)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                // Row 3
                                Row(
                                  children: [
                                    // Expanded(child: MeasurementField(label: AppLocalizations.of(context)!.underBust, controller: underBustController,inputType: TextInputType.number,)),
                                    // const SizedBox(width: 20),
                                    // Expanded(child: MeasurementField(label: AppLocalizations.of(context)!.waist, controller: waistController,inputType: TextInputType.number,)),
                                    // const SizedBox(width: 12),
                                    Expanded(child: MeasurementField(label:  AppLocalizations.of(context)!.hips, controller: hipsController,inputType: TextInputType.number,)),
                                    const SizedBox(width: 20),
                                    Expanded(child: MeasurementField(label: AppLocalizations.of(context)!.neckAbove, controller: wristController,inputType: TextInputType.number,)),
                                  ],
                                ),
                                SizedBox(height: 12,),
                                // Row 4
                                Row(
                                  children: [
                                    Expanded(child: MeasurementField(label: AppLocalizations.of(context)!.armLength, controller: armLengthController,inputType: TextInputType.number,)),
                                    const SizedBox(width: 20),
                                    Expanded(child: MeasurementField(label: AppLocalizations.of(context)!.shoulderSeam, controller: shoulderSeamController,inputType: TextInputType.number,)),
                                    // const SizedBox(width: 12),
                                    // Expanded(child: MeasurementField(label: AppLocalizations.of(context)!.armHole, controller: armHoleController,inputType: TextInputType.number,)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                // Row 5
                                Row(
                                  children: [
                                    Expanded(child: MeasurementField(label: AppLocalizations.of(context)!.armHole, controller: armHoleController,inputType: TextInputType.number,)),
                                    const SizedBox(width: 20),
                                    Expanded(child: MeasurementField(label: AppLocalizations.of(context)!.bicep, controller: bicepController,inputType: TextInputType.number,)),
                                    // const SizedBox(width: 12),
                                    // Expanded(child: MeasurementField(label: AppLocalizations.of(context)!.foreArm, controller: foreArmController,inputType: TextInputType.number,)),
                                    // const SizedBox(width: 12),
                                    // Expanded(child: MeasurementField(label: AppLocalizations.of(context)!.wrist, controller: wristController,inputType: TextInputType.number,)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(child: MeasurementField(label: AppLocalizations.of(context)!.foreArm, controller: foreArmController,inputType: TextInputType.number,)),
                                    const SizedBox(width: 20),
                                    Expanded(child: MeasurementField(label: AppLocalizations.of(context)!.wrist, controller: wristController,inputType: TextInputType.number,)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                // Row 6
                                Row(
                                  children: [
                                    Expanded(child: MeasurementField(label: AppLocalizations.of(context)!.shoulderWaist, controller: shoulderToWaistController,inputType: TextInputType.number,)),
                                    const SizedBox(width: 20),
                                    Expanded(child: MeasurementField(label: AppLocalizations.of(context)!.bottomLength, controller: bottomLengthController,inputType: TextInputType.number,)),
                                    //const SizedBox(width: 12),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(child: MeasurementField(label: AppLocalizations.of(context)!.ankle, controller: ankleController,inputType: TextInputType.number,)),
                                    Spacer()
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  AppLocalizations.of(context)!.notes,
                                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 14),),
                                SizedBox(height: 10,),
                                TextField(controller: textarea,
                                  keyboardType: TextInputType.multiline, maxLines: 4, maxLength: 500,
                                  decoration: InputDecoration(hintText: AppLocalizations.of(context)!.textHere,
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.grey, width: 0.5),),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.0, color: Colors.grey))),
                                ),
                              ],
                            ),
                            // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Expanded(
                            //         child: Container(
                            //           decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white),
                            //           child: Column(
                            //             children: [
                            //               Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.neck, hintText: optional, controller: neckController,),
                            //               SizedBox(height: 10,),
                            //               Commonaddcusttextfield(inputType: TextInputType.number,text: AppLocalizations.of(context)!.bust, hintText: optional, controller: bustController,),
                            //               SizedBox(height: 10,),
                            //               Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.underBust, hintText: optional, controller: underBustController,),
                            //               SizedBox(height: 10,),
                            //               Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.waist, hintText: optional, controller: waistController,),
                            //               SizedBox(height: 10,),
                            //               Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.hips, hintText: optional, controller: hipsController,),
                            //               SizedBox(height: 10,),
                            //               Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.neckAbove, hintText: optional, controller: neckToAboveKneeController,),
                            //               SizedBox(height: 10,),
                            //               Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.armLength, hintText: optional, controller: armLengthController,),
                            //               SizedBox(height: 10,),
                            //               Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.shoulderSeam, hintText: optional, controller: shoulderSeamController,),
                            //               SizedBox(height: 10,),
                            //               Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.armHole, hintText: optional, controller: armHoleController,),
                            //               SizedBox(height: 10,),
                            //               Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.bicep, hintText: optional, controller: bicepController,),
                            //               SizedBox(height: 10,),
                            //               Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.foreArm, hintText: optional, controller: foreArmController,),
                            //               SizedBox(height: 10,),
                            //               Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.wrist, hintText: optional, controller: wristController,),
                            //               SizedBox(height: 10,),
                            //               Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.shoulderWaist, hintText: optional, controller: shoulderToWaistController,),
                            //               SizedBox(height: 10,),
                            //               Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.bottomLength, hintText: optional, controller: bottomLengthController,),
                            //               SizedBox(height: 10,),
                            //               Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.ankle, hintText: optional, controller: ankleController,),
                            //               SizedBox(height: 10,),
                            //               Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.stitchingCost, hintText: "₹", controller: stitchingCostController,),
                            //               SizedBox(height: 10,),
                            //               Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.advancedCost, hintText: "₹", controller: advancedReceivedController,),
                            //               SizedBox(height: 10,),
                            //               Commonaddcusttextfield(inputType: TextInputType.number, text: AppLocalizations.of(context)!.outstandingBalance, hintText: "₹", controller: outStandingBalanceController,),
                            //             ],
                            //           ),
                            //         ),
                            //       ),
                            //     ]
                            // ),
                          ),
                          SizedBox(height: 12,),

                        ],
                      ),
                    ),
                    // Save button
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GestureDetector(
                        onTapDown: (_) {
                          setState(() {
                            isPressed = true;
                          });
                        },
                        onTap: () {
                          updateMeasurementData(
                              widget.customerId,
                              nameController.text,
                              mobileNoController.text,
                              neckController.text,
                              bustController.text,
                              underBustController.text,
                              waistController.text,
                              hipsController.text,
                              neckToAboveKneeController.text,
                              armLengthController.text,
                              shoulderSeamController.text,
                              armHoleController.text,
                              bicepController.text,
                              foreArmController.text,
                              wristController.text,
                              shoulderToWaistController.text,
                              bottomLengthController.text,
                              ankleController.text,
                              textarea.text
                          );
                        },
                        onTapUp: (_) async {},
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
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.saveDetails1,
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
                      ),
                    ),

                  ],
                )
                // Bottom Navigation
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateMeasurementData(String customerId, String name, String mobileNo,String neck,String bust,
      String underBust, String waist,String hips, String neckToAboveKnee,String armLength,
      String shoulderSeam,String armHole, String bicep,String foreArm, String wrist,
      String shoulderToWaist,String bottomLength,String ankle,String notes) async {
    var map = Map<String, dynamic>();
    map['customerId'] = customerId;
    map['name'] = name;
    map['mobileNo'] = mobileNo;
    map['neck'] = neck;
    map['Bust'] = bust;
    map['underBust'] = underBust;
    map['waist'] = waist;
    map['hips'] = hips;
    map['neckToAboveKnee'] = neckToAboveKnee;
    map['armLength'] = armLength;
    map['shoulderSeam'] = shoulderSeam;
    map['armHole'] = armHole;
    map['bicep'] = bicep;
    map['foreArm'] = foreArm;
    map['wrist'] = wrist;
    map['shoulderToWaist'] = shoulderToWaist;
    map['bottomLength'] = bottomLength;
    map['ankle'] = ankle;
    map['measurementUnit'] = optional;
    map['measurementnotes'] = notes;
    print("My Map Value is : $map");
    isLoading = true;
    WidgetsBinding.instance
        .addPostFrameCallback((_) async {
      Update_Customer_Measurement_Details_Model model =
      await CallService()
          .updateCustomerMeasurementDressDetails(map);
      isLoading = false;
      String message = model.message.toString();
      print("Measurement update message $message");
      Fluttertoast.showToast(
          msg: message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      updateUI();
      updateMeasurementDetails();
    });
  }

  void updateUI() {
    setState(() {});
  }

  void updateMeasurementDetails() {
    isLoading = true;
    String cId = widget.customerId.toString();
    print("customer Id is : $cId");
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Specific_Cutomer_Measurement_Response_Model model =
      await CallService().getSpecificCustomerMeasurementDetails(cId);
      setState(() {
        isLoading = false;
        optional = model.data!.measurementUnit.toString();
        name = model.data!.name.toString();
        mobileNumber = model.data!.mobileNo.toString();
        neck = model.data!.neck.toString();
        bust = model.data!.bust.toString();
        underBust = model.data!.underBust.toString();
        bicep = model.data!.bicep.toString();
        armHole = model.data!.armHole.toString();
        armLength = model.data!.armLength.toString();
        waist = model.data!.waist.toString();
        wrist = model.data!.wrist.toString();
        ankle = model.data!.ankle.toString();
        shoulderToWaist = model.data!.shoulderToWaist.toString();
        shoulderSeam = model.data!.shoulderSeam.toString();
        foreArm = model.data!.foreArm.toString();
        bottomLength = model.data!.bottomLength.toString();
        neckToAboveKnee = model.data!.neckToAboveKnee.toString();
        hips = model.data!.hips.toString();
        notes = model.data!.measurementnotes.toString();
        DateTime fudgeThis = DateFormat("yyyy-MM-dd").parse(model.data!.createdAt.toString());
        String formattedDate = DateFormat("d MMMM yyyy").format(fudgeThis);
        created_at = formattedDate;
        print("Final Date is : $created_at");
        last_updated_at = model.data!.lastUpdatedAt.toString();
        print("Final Date is : $last_updated_at");
        print("list Value is: $optional");
        print("list Value is: $neck");
        print("list Value is: $notes");
        nameController.text = "${name}";
        mobileNoController.text = "${mobileNumber}";
        neckController.text = "${neck}";
        bustController.text = "${bust}";
        underBustController.text = "${underBust}";
        bicepController.text = "${bicep} ";
        armHoleController.text = "${armHole}";
        armLengthController.text = "${armLength}";
        waistController.text = "${waist}";
        wristController.text = "${wrist}";
        ankleController.text = "${ankle}";
        shoulderToWaistController.text = "${shoulderToWaist}";
        shoulderSeamController.text = "${shoulderSeam}";
        foreArmController.text = "${foreArm}";
        bottomLengthController.text = "${bottomLength}";
        neckToAboveKneeController.text = "${neckToAboveKnee}";
        hipsController.text = "${hips}";
        textarea.text = "${notes ?? ''}";
      });
    });
  }

  Future<bool?> showWarningMessage(BuildContext context,
      {required Locale locale, required Function(Locale) onChangeLanguage}) async {
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
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);// Close dialog and return true
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
                        Navigator.of(context).pop(false); // Close the dialog
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
    ) ?? false; // Agar null return ho to false return karo
  }

}