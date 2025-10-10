import 'package:cached_network_image/cached_network_image.dart';
import 'package:darzi/apiData/model/recieve_payment_response_model.dart';
import 'package:darzi/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../../../../../apiData/call_api_service/call_service.dart';
import '../../../../../apiData/model/order_status_change_model.dart';
import '../../../../../apiData/model/specific_order_detail_response_model.dart';
import '../../../../../colors.dart';
import '../../../../../common/widgets/tailor/common_app_bar_with_back.dart';
import '../../../../../constants/string_constant.dart';

import 'dresses.dart';

class SpecificCustomerDressFullview extends StatefulWidget {
  final String dressId;
  final String customerId;
  final Locale locale;
  SpecificCustomerDressFullview(this.dressId,this.customerId,this.locale,{super.key});

  @override
  State<SpecificCustomerDressFullview> createState() => _SpecificCustomerDressFullviewState();
}

class _SpecificCustomerDressFullviewState extends State<SpecificCustomerDressFullview> {
  bool isLoading = false;
  SpecificData? specificData;
  String customerId = "",customerId1 = "",dressOrderId = "",dateTime = "",formattedDate1 = "" ,dressAmount =  "";
  String? notes;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUpdateData();
  }

  loadUpdateData(){
    setState(() {
      isLoading = true;
      dressOrderId = widget.dressId.toString();
      print("customer Id is : $dressOrderId");
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Specific_Order_Detail_Response_Model model =
        await CallService().getSpecificDreesDetails(dressOrderId);
        setState(() {
          isLoading = false;
          specificData = model.data;
          DateTime fudgeThis = DateFormat("yyyy-MM-dd").parse(specificData!.dueDate.toString());
          dateTime = DateFormat("dd-MM-yyyy").format(fudgeThis);
          print("list Value is: ${specificData}");
          notes = specificData!.notes.toString();
          customerId1 = specificData!.customerId.toString();
        });
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    String dressId = widget.dressId.toString();
    print("Dress Id is : $dressId");
    print("Final Date is : $dateTime");
    return  WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true); // pass true to signal refresh
        return false;
      },
      child:Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.dressDetails,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
            textAlign: TextAlign.center,),
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () async {
              Navigator.pop(context, true); // pass true to signal refresh
            },
          ),
        ),
        // CustomAppBarWithBack(
        //   title: AppLocalizations.of(context)!.dressDetails,
        //   hasBackButton: true,
        //   elevation: 2.0,
        //   leadingIcon: SvgPicture.asset(
        //     'assets/svgIcon/activeDress.svg',
        //     color: Colors.black,
        //   ),
        //   onBackButtonPressed: () async {
        //     Navigator.pop(context, true); // pass true to signal refresh
        //   },
        // ),
        body: isLoading
            ? Center(
          child: CircularProgressIndicator(color: AppColors.newUpdateColor),
        )
            : Stack(
          children: [
            // Upper image design
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(45),
                  topRight: Radius.circular(45),
                ),
                child: CachedNetworkImage(
                  imageUrl: specificData!.dressImgUrl.toString(),
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  errorWidget: (context, url, error) =>  Image.network(
                      'https://dummyimage.com/500x500/aaa/000000.png&text=No+Image+Available',
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      fit: BoxFit.fill),
                ),
              ),
            ),

            // Bottom details section
            Align(
              alignment: Alignment.bottomCenter,
              child: IntrinsicHeight(
                child: Container(
                  // height: MediaQuery.of(context).size.height * 0.38,
                  width: double.infinity,
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
                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${AppLocalizations.of(context)!.userName} :",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                SizedBox(width: 5,),
                                Text(specificData!.name??AppLocalizations.of(context)!.noUserName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${AppLocalizations.of(context)!.dressName} :",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                SizedBox(width: 5,),
                                Text(
                                  specificData!.dressName??AppLocalizations.of(context)!.noDressName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${AppLocalizations.of(context)!.cost} :",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                SizedBox(width: 5,),
                                Text(
                                  "₹${specificData!.stitchingCost.toString()}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${AppLocalizations.of(context)!.advancedCost} :",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                SizedBox(width: 5,),
                                Text(
                                  "₹${specificData!.advanceReceived ?? 0}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${AppLocalizations.of(context)!.remainingBalance} :",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                SizedBox(width: 5,),
                                Text(
                                  "₹${specificData!.outstandingBalance??0}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${AppLocalizations.of(context)!.dueDate} :",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                SizedBox(width: 5,),
                                Text(
                                  dateTime.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${AppLocalizations.of(context)!.notes} :",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    (notes == null || notes.toString().trim().isEmpty)
                                        ? AppLocalizations.of(context)!.noNotesAvailable
                                        : notes.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4,),
                            Visibility(
                              visible: specificData?.cancelledReason != null && specificData!.cancelledReason!.trim().isNotEmpty,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${AppLocalizations.of(context)!.cancel_reason} :",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Inter',
                                      color: AppColors.primaryRed,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Text(
                                        specificData?.cancelledReason?.trim().isNotEmpty == true
                                            ? specificData!.cancelledReason!
                                            : AppLocalizations.of(context)!.no_cancel_reason,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.primaryRed,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${AppLocalizations.of(context)!.dressStatus} :",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Inter',
                                    color: specificData!.status.toString() == "Received"
                                        || specificData!.status.toString() == "InProgress"
                                        ?AppColors.statusColor:AppColors.primaryRed,
                                  ),
                                ),
                                SizedBox(width: 5,),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    specificData!.status.toString() == "Received"?
                                    AppLocalizations.of(context)!.order_Received
                                        : specificData!.status.toString() == "InProgress"?
                                    AppLocalizations.of(context)!.dressProgress
                                        : specificData!.status.toString() == "Cancelled"?
                                    AppLocalizations.of(context)!.order_cancelled:
                                    specificData!.status.toString() == "PaymentDone"?
                                    AppLocalizations.of(context)!.payment_done
                                        :AppLocalizations.of(context)!.dressComplete,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: specificData!.status.toString() == "Received"
                                          || specificData!.status.toString() == "InProgress"
                                          ?AppColors.statusColor:AppColors.primaryRed,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            SizedBox(height: 20,),
                            Visibility(
                              visible: specificData!.status.toString() == "Received",
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Start Work Button
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.newUpdateColor, // Button background color
                                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      String status = "InProgress";
                                      _callVerifyMobile(status);

                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.start_Work,
                                      style: TextStyle(color: Colors.white,
                                          fontFamily: 'Inter',
                                          fontSize: 14, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const SizedBox(width: 12), // Spacing between buttons

                                  // Cancel Work Button
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                                      side: const BorderSide(color: AppColors.newUpdateColor, width: 1.5), // Border color
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      // Add your logic here
                                      showWarningMessage(
                                        context,
                                        locale: widget.locale,
                                        onChangeLanguage: (newLocale) {
                                          // Handle the language change
                                          print(
                                              "Language changed to: ${newLocale.languageCode}");
                                        },
                                      );

                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.cancel_Work,
                                      style: TextStyle(color: Colors.black,
                                          fontFamily: 'Inter',
                                          fontSize: 14, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: specificData!.status.toString() == "InProgress",
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.newUpdateColor,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    minimumSize: const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: specificData!.status.toString() ==
                                      "Completed"
                                      ? null
                                      : () {
                                    String complete = "Completed";
                                    _callVerifyMobile(complete);
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.dressIsComplete,
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: Colors.white),
                                  )
                              ),
                            ),
                            Visibility(
                              visible: specificData!.status.toString() == "Completed",
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.newUpdateColor,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    minimumSize: const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: (){
                                    showPaymentMessage(
                                      context,
                                      locale: widget.locale,
                                      onChangeLanguage: (newLocale) {
                                        // Handle the language change
                                        print(
                                            "Language changed to: ${newLocale.languageCode}");
                                      },
                                    );
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.payment_Received,
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: Colors.white),
                                  )
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  _callVerifyMobile(String input) {
    setState(() {
      isLoading = true;
      customerId = widget.dressId.toString();
      var map = Map<String, dynamic>();
      map['id'] = customerId;
      map['status'] = input.toString();
      print("Map value is $map");
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Order_Status_Change_Model model = await CallService().updateDreesOrderStatus(map);
        setState(() {
          isLoading = false;
          String message = model.message.toString();
          // customersList = model.data!.customers!;
          print("list Value is: $message");
          Fluttertoast.showToast(
              msg: message,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
          loadUpdateData();
          // print("list Value is: ${customersList.length}");
        });
      });
    });
  }
  _callVerifyMobile1(String input, String cancelReason) {
    setState(() {
      isLoading = true;
      customerId = widget.dressId.toString();
      var map = Map<String, dynamic>();
      map['id'] = customerId;
      map['status'] = input.toString();
      map['cancelledReason'] = cancelReason;
      print("Status Map value is $map");
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Order_Status_Change_Model model = await CallService().updateDreesOrderStatus(map);
        setState(() {
          isLoading = false;
          String message = model.message.toString();
          // customersList = model.data!.customers!;
          print("list Value is: $message");
          Fluttertoast.showToast(
              msg: message,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
          loadUpdateData();
          // print("list Value is: ${customersList.length}");
        });
      });
    });
  }

  void showWarningMessage(BuildContext context,
      {required Locale locale, required Function(Locale) onChangeLanguage}) {
    TextEditingController reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Container(
            margin: const EdgeInsets.only(left: 5),
            child: Text(
              AppLocalizations.of(context)!.cancel_order_warning,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  fontSize: 20),
            ),
          ),
          content: Container(
            child: Text(
              AppLocalizations.of(context)!.subTitle_of_cancel_order_warning,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Colors.grey),
            ),
          ),
          actions: [
            _buildTextField1(AppLocalizations.of(context)!.cancel_reason, reasonController, isNumber: false),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 47,
                  width: 120,
                  child: Card(
                    color: AppColors.newUpdateColor,
                    elevation: 4,
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        String status = "Cancelled";
                        String cancelReason = reasonController.text.toString();
                        _callVerifyMobile1(status,cancelReason);
                        Navigator.pop(context, true);

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
                SizedBox(width: 10,),
                SizedBox(
                  height: 47,
                  width: 120,
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


  void showPaymentMessage(BuildContext context,
      {required Locale locale, required Function(Locale) onChangeLanguage}) {
    TextEditingController dateController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(AppLocalizations.of(context)!.payment_information,style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              fontSize: 20),),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDateField(context, AppLocalizations.of(context)!.payment_Date, dateController),
              const SizedBox(height: 12),
              _buildTextField(AppLocalizations.of(context)!.amount_Received, amountController, isNumber: true),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          formattedDate1 = dateController.text;
                          dressAmount = amountController.text;
                          // Navigator.of(context).pop(formattedDate1);
                          callTailorPaymentApi(formattedDate1,dressAmount);
                          Navigator.of(context).pop(false);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.yesMessage,
                          style: TextStyle(fontFamily: 'Inter',fontSize: 18,fontWeight: FontWeight.w600,color: Colors.white),
                        ),
                      ),
                    ),
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
                          side: BorderSide(width: 1.5, color: AppColors.newUpdateColor)
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false); // Close the dialog
                        },
                        child: Text(
                            AppLocalizations.of(context)!.cancel,
                            style: TextStyle(
                                fontFamily: 'Inter',fontSize: 18,fontWeight: FontWeight.w600,color: AppColors.newUpdateColor)
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDateField(BuildContext context, String hintText, TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
      ),
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
          formattedDate1 = DateFormat('yyyy-MM-dd').format(pickedDate);
          print("Date Value is : $formattedDate1");
          setState(() {controller.text = formattedDate1;});
          value:formattedDate1;}
        if (pickedDate != null) {
          formattedDate1 = DateFormat('yyyy-MM-dd').format(pickedDate);
          controller.text = formattedDate1;
        }
      },
    );
  }

  Widget _buildTextField(String hintText, TextEditingController controller, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildTextField1(String hintText, TextEditingController controller, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void callTailorPaymentApi(String formattedDate1,String dressAmount) {
    var map =  Map<String, dynamic>();
    map['orderId'] = dressOrderId;
    map['customerId'] = customerId1;
    map['paymentDate'] = formattedDate1;
    map['amount'] = dressAmount;
    print("New Map is $map");
    isLoading = true;
    WidgetsBinding.instance
        .addPostFrameCallback((_) async {
      Receive_Payment_Response_Model model =
      await CallService()
          .customerDressPayment(map);
      isLoading = false;
      String message = model.message.toString();
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      loadUpdateData();
    });
  }
}