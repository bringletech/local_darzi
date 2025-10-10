import 'package:cached_network_image/cached_network_image.dart';
import 'package:darzi/apiData/model/reopen_cancelled_order_response_model.dart';
import 'package:darzi/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../../../../../apiData/call_api_service/call_service.dart';
import '../../../../../apiData/model/specific_order_detail_response_model.dart';
import '../../../../../colors.dart';
import '../../../../../common/widgets/tailor/common_app_bar_with_back.dart';

import 'cancelled_order.dart';
class CancelledOrderFullview extends StatefulWidget {
  final String orderId;
  final Locale locale;
  const CancelledOrderFullview({super.key,required this.orderId,required this.locale});

  @override
  State<CancelledOrderFullview> createState() => _CancelledOrderFullviewState();
}

class _CancelledOrderFullviewState extends State<CancelledOrderFullview> {
  bool isLoading = false;
  String customerId = "", dressOrderId = "", dueDate = "",dateTime = "",formattedDate1 = "",dressAmount =  "", status="";
  String? notes;
  SpecificData? specificData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUpdateData();

  }


  loadUpdateData(){
    setState(() {
      isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Specific_Order_Detail_Response_Model model =
        await CallService().getSpecificDreesDetails(widget.orderId);
        setState(() {
          isLoading = false;
          specificData = model.data;
          dueDate = model.data!.dueDate.toString();
          DateTime fudgeThis = DateFormat("yyyy-MM-dd").parse(dueDate.toString());
          dateTime = DateFormat("dd-MM-yyyy").format(fudgeThis);
          status= model.data!.status.toString();
          notes = specificData!.notes.toString();
          print("list Value is: $status");
          print("list Value is: $notes");
        });
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, true); // true = trigger refresh on previous screen
          return false;
        },
        child:isLoading == true?Center(child: CircularProgressIndicator(color: AppColors.darkRed,)):Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.cancel_order_details_title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
              textAlign: TextAlign.center,),
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () async {
                Navigator.pop(context, true);
              },
            ),
          ),
          // CustomAppBarWithBack(
          //   title: AppLocalizations.of(context)!.cancel_order_details_title,
          //   hasBackButton: true,
          //   onBackButtonPressed: () async{
          //     Navigator.pop(context, true);
          //   },
          //   elevation: 2.0,
          //   leadingIcon: SvgPicture.asset(
          //     'assets/svgIcon/activeDress.svg',
          //     color: Colors.black,
          //   ),
          // ),
          body: Stack(
            children: [
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
                        'https://dummyimage.com/500x500/aaa/000000.png&text= No+Image+Available',
                        fit: BoxFit.fill
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: IntrinsicHeight(
                  child: Container(
                    //height: MediaQuery.of(context).size.height * 0.38,
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
                                Text(
                                  specificData!.name??AppLocalizations.of(context)!.noUserName,
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
                                  "₹${specificData!.advanceReceived.toString()}",
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
                                  "₹${specificData!.outstandingBalance.toString()}",
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
                                Text(dateTime,
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
                                        ?AppColors.statusColor:AppColors.primaryRed,
                                  ),
                                ),
                                SizedBox(width: 5,),
                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Text(AppLocalizations.of(context)!.order_cancelled,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: specificData!.status.toString() == "Received"
                                          ?AppColors.statusColor:AppColors.primaryRed,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Visibility(
                              visible: status == "Cancelled",
                              child: GestureDetector(
                                onTap: (){
                                  showReorderDialog(
                                    context,
                                    locale: widget.locale,
                                    onChangeLanguage: (newLocale) {
                                      // Handle the language change
                                      print(
                                          "Language changed to: ${newLocale.languageCode}");
                                    },
                                  );
                                },
                                child: Container(
                                  height: 45,
                                  width: 400,
                                  decoration: BoxDecoration(
                                    color: AppColors.newUpdateColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(AppLocalizations.of(context)!.re_order,style: TextStyle(
                                        fontFamily: "Inter",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white
                                    ),),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
  void showReorderDialog(BuildContext context,
      {required Locale locale, required Function(Locale) onChangeLanguage}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.re_order,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                fontSize: 20),),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          contentPadding: EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.re_order_message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 50,
                      width: 120,
                      child: Card(
                        color: AppColors.newUpdateColor,
                        elevation: 4,
                        shadowColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child:TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                          onPressed: () {
                            String status = "Received";
                            reopenCancelledOrder(widget.orderId,status);
                            Navigator.pop(context);
                          },
                          child: Text(AppLocalizations.of(context)!.yesMessage,
                              style: TextStyle(fontFamily:'Inter',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                        ),)),
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
                          style: TextStyle(fontFamily:'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,color: AppColors.newUpdateColor,),
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


  void updateUI() {
    setState(() {});
  }

  Future<void> reopenCancelledOrder(String orderId, String status) async {
    var map = {
      'id': orderId,
      'status': status,
    };

    print("Map value is $map");
    isLoading = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        Re_Open_Cancelled_Order_Response_Model model =
        await CallService().reopenOrder(map);
        isLoading = false;
        // Show toast
        String message = model.message.toString();
        String status = model.status.toString();
        print("Cancel status is $status");
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        // Check if success before calling loadUpdateData
        if (model.status == true || model.status == "success") {
          loadUpdateData();
          updateUI();
        }
      } catch (e) {
        isLoading = false;
        Fluttertoast.showToast(
          msg: "Something went wrong. Please try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        print("Error in reopenCancelledOrder: $e");
      }
    });
  }
}