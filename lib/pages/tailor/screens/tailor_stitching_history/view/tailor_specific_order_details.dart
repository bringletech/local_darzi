import 'package:cached_network_image/cached_network_image.dart';
import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/apiData/model/specific_stitching_history_response_model.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/l10n/app_localizations.dart';
import 'package:darzi/pages/tailor/screens/tailor_stitching_history/view/tailor_stitching_history.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TailorSpecificOrderDetails extends StatefulWidget {
  final String? contact;
  final Locale locale;
  TailorSpecificOrderDetails(this.contact,{super.key,required this.locale});

  @override
  State<TailorSpecificOrderDetails> createState() => _TailorSpecificOrderDetailsState();
}

class _TailorSpecificOrderDetailsState extends State<TailorSpecificOrderDetails> {
  bool isLoading = false;
  String customerId = "",customerId1 = "", dressOrderId = "", dueDate = "",dateTime = "",formattedDate1 = "",dressAmount =  "",
      cancel_reason = "";
  String? notes;
  Specific_Stiching_History_Data? specificData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("customer Id is : ${widget.contact}");
    loadUpdateData();
  }
  loadUpdateData(){
    setState(() {
      isLoading = true;
      dressOrderId = widget.contact.toString();
      print("customer Id is : ${widget.contact}");
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Specific_Stitching_History_Response_Model model =
        await CallService().getSpecificHistoryOrderDetails(dressOrderId);
        setState(() {
          isLoading = false;
          specificData = model.data;
          dueDate = model.data!.dueDate.toString();
          DateTime fudgeThis = DateFormat("yyyy-MM-dd").parse(dueDate.toString());
          dateTime = DateFormat("dd-MM-yyyy").format(fudgeThis);
          notes = model.data!.notes.toString();
          cancel_reason = model.data!.cancelledReason.toString();
          customerId1 = model.data!.customerId.toString();
          print("customer Id is : $customerId1");
          print("list Value is: $cancel_reason");
        });
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    String dressId = widget.contact!.toString();
    print("Dress Id is : $dressId");
    print("Final Date is : $dateTime");
    return WillPopScope(
        onWillPop: () async {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TailorStitchingHistory(locale: widget.locale,)),
      );
      return false;
    }, child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.order_details,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
          textAlign: TextAlign.center,),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true, // 👈 yeh add karo
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TailorStitchingHistory(
                    locale: widget.locale,
                  )),
            );
            Navigator.pop(context, true);
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ActiveDress(locale: widget.locale,)));
          },
        ),
      ),
      body: isLoading == true
          ? Center(
          child: CircularProgressIndicator(
            color: AppColors.newUpdateColor,
          ))
          : Stack(
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
                errorWidget: (context, url, error) => Image.network(
                    'https://dummyimage.com/500x500/aaa/000000.png&text= No+Image+Available',
                    fit: BoxFit.fill),
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${AppLocalizations.of(context)!.userName} :",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              specificData!.name ??
                                  AppLocalizations.of(context)!
                                      .noUserName,
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
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              specificData!.dressName ??
                                  AppLocalizations.of(context)!
                                      .noDressName,
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
                            SizedBox(
                              width: 5,
                            ),
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
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "₹${specificData?.advanceReceived ?? 0}",
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
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "₹${specificData!.outstandingBalance ?? 0}",
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
                            SizedBox(
                              width: 5,
                            ),
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
                              // 👈 Yeh add kiya
                              child: Text(
                                notes.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                ),
                                softWrap: true,
                                overflow: TextOverflow
                                    .visible, // text wrap hoga
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Visibility(
                          visible:
                          specificData?.cancelledReason != null &&
                              specificData!.cancelledReason!
                                  .trim()
                                  .isNotEmpty,
                          child: Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
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
                                  padding:
                                  const EdgeInsets.only(top: 2),
                                  child: Text(
                                    specificData?.cancelledReason
                                        ?.trim()
                                        .isNotEmpty ==
                                        true
                                        ? specificData!.cancelledReason!
                                        : AppLocalizations.of(context)!
                                        .no_cancel_reason,
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
                                color:
                                specificData!.status.toString() ==
                                    "Received" ||
                                    specificData!.status
                                        .toString() ==
                                        "InProgress" ||
                                    specificData!.status ==
                                        "PaymentDone"
                                    ? AppColors.statusColor
                                    : AppColors.primaryRed,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                specificData!.status.toString() ==
                                    "Received"
                                    ? AppLocalizations.of(context)!
                                    .order_Received
                                    : specificData!.status.toString() ==
                                    "InProgress"
                                    ? AppLocalizations.of(context)!
                                    .dressProgress
                                    : specificData!.status
                                    .toString() ==
                                    "Cancelled"
                                    ? AppLocalizations.of(
                                    context)!
                                    .order_cancelled
                                    : specificData!.status
                                    .toString() ==
                                    "PaymentDone"
                                    ? AppLocalizations.of(
                                    context)!
                                    .payment_done
                                    : AppLocalizations.of(
                                    context)!
                                    .dressComplete,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color:
                                  specificData!.status.toString() ==
                                      "Received" ||
                                      specificData!.status
                                          .toString() ==
                                          "InProgress" ||
                                      specificData!.status
                                          .toString() ==
                                          "PaymentDone"
                                      ? AppColors.statusColor
                                      : AppColors.primaryRed,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
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
}
