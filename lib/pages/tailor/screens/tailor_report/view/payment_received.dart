import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/apiData/model/get_received_payment_list_response_model.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/l10n/app_localizations.dart';
import 'package:darzi/pages/tailor/screens/tailor_report/view/payment_done_order_fullview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../common/widgets/tailor/common_app_bar_with_back.dart';

class PaymentReceived extends StatefulWidget {
  final Locale locale;
  final String month;
  final String year;
  const PaymentReceived({super.key, required this.locale,required this.month,required this.year});


  @override
  State<PaymentReceived> createState() => _PaymentReceivedState();
}

class _PaymentReceivedState extends State<PaymentReceived> {
  bool isLoading = false;
  File? _selectedImage;


  List<PaymentDoneData> receivedPaymentData=[];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getReceivedPaymentOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      //     title: AppLocalizations.of(context)!.payment_received,
      //     hasBackButton: true,
      //     elevation: 2.0,
      //     leadingIcon: SvgPicture.asset(
      //       'assets/svgIcon/payment.svg', //just change my image with your image
      //     ),
      //     onBackButtonPressed:  () {
      //       Navigator.pop(context, true );
      //     }
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 10,),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(AppLocalizations.of(context)!.recentData,
                  style: TextStyle(
                      fontSize: 19,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height*0.8,
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount:  receivedPaymentData.length,
                    itemBuilder: (context, index){
                      final payment  = receivedPaymentData[index];
                      return GestureDetector(
                        onTap: (){
                          if (receivedPaymentData.isNotEmpty) {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context)=>PaymentDoneOrderFullview(locale: widget.locale,orderId: payment.id.toString(),)));
                          } else {
                            // Optionally show a message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(AppLocalizations.of(context)!.no_receive_order,)),
                            );
                          }

                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: SizedBox(
                                  child: _selectedImage != null
                                      ? Image.file(
                                    _selectedImage!,
                                    fit: BoxFit.cover,
                                    width: 90,
                                    height: 90,
                                  )
                                      : (payment.dressImgUrl.toString().isNotEmpty)
                                      ? CachedNetworkImage(
                                    height: 70,
                                    width: 70,
                                    imageUrl:payment.dressImgUrl.toString(),
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                        CircularProgressIndicator(
                                          value: downloadProgress.progress,
                                          color: AppColors.newUpdateColor,
                                        ),
                                    errorWidget: (context, url, error) =>
                                        Image.network(
                                            'https://dummyimage.com/500x500/aaa/000000.png&text=No+Image',
                                            width: 70,
                                            height:70,
                                            fit: BoxFit.cover),
                                  )
                                      : SvgPicture.asset(
                                    'assets/svgIcon/profilepic.svg',
                                    // Default profile icon
                                    width: 120,
                                    height: 120,
                                  ),
                                ),
                              ),

                              Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text( payment.customerName.toString(),
                                    style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 19,fontFamily: 'Poppins'),
                                  ),
                                  Text("Due Date: ${payment.dueDate}",
                                    style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 14,fontFamily: 'Poppins'),),
                                  Text(
                                    "Status: ${payment.status == "PaymentDone"?AppLocalizations.of(context)!.payment_done:""}",
                                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(width: 10,),
                              Column(crossAxisAlignment:CrossAxisAlignment.end,
                                children: [
                                  Text('Cost',style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 19
                                  ),),
                                  Text(
                                    payment.stitchingCost.toString(),
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  void getReceivedPaymentOrder() {
    setState(() {
      isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        GetPaymentDoneListResponseModel model =
        await CallService().getPaymentDoneOrder(widget.month,widget.year);
        setState(() {
          isLoading = false;
          receivedPaymentData = model.data!;
          print('Received Payment Order Data Length is :$receivedPaymentData');
        });
      });
    });
  }

}
