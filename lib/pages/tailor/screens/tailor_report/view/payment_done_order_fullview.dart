import 'package:cached_network_image/cached_network_image.dart';
import 'package:darzi/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../../../../apiData/call_api_service/call_service.dart';
import '../../../../../apiData/model/specific_order_detail_response_model.dart';
import '../../../../../colors.dart';
import '../../../../../common/widgets/tailor/common_app_bar_with_back.dart';

class PaymentDoneOrderFullview extends StatefulWidget {
  final Locale locale;
  final String orderId;

  const PaymentDoneOrderFullview({super.key, required this.locale, required this.orderId});

  @override
  State<PaymentDoneOrderFullview> createState() => _PaymentDoneOrderFullviewState();
}

class _PaymentDoneOrderFullviewState extends State<PaymentDoneOrderFullview> {
  bool isLoading = false;
  String customerId = "", dressOrderId = "", dueDate = "",dateTime = "",formattedDate1 = "",dressAmount =  "", status="";
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
      print("customer Id is : $dressOrderId");
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
          // print("list Value is: ${customersList.length}");
        });
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.payment_received,
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
      //   title: AppLocalizations.of(context)!.payment_received,
      //   hasBackButton: true,
      //   onBackButtonPressed: () async{
      //     Navigator.pop(context, true);
      //     // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ActiveDress(locale: widget.locale,)));
      //   },
      //   elevation: 2.0,
      //   leadingIcon: SvgPicture.asset(
      //     'assets/svgIcon/activeDress.svg',
      //     color: Colors.black,
      //   ),
      // ),
      body: isLoading == true?Center(child: CircularProgressIndicator(color: AppColors.darkRed,)):Stack(
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
                              "${AppLocalizations.of(context)!.dressStatus} :",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Inter',
                                  color: AppColors.statusColor,
                              ),
                            ),
                            SizedBox(width: 5,),
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(status == "PaymentDone"?AppLocalizations.of(context)!.payment_done:"",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.statusColor,
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
    );
  }
}
