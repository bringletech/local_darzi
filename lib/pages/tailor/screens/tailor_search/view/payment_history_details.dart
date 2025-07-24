import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/apiData/model/particular_customer_order_payment_history_response_model.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/common/all_text.dart';
import 'package:darzi/common/widgets/tailor/common_app_bar_with_back.dart';
import 'package:darzi/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';


class PaymentHistoryDetail extends StatefulWidget {
  final String orderId;
  final String name;
  final String phoneNumber;
  final Locale locale;

  PaymentHistoryDetail(this.orderId,this.name,this.phoneNumber,this.locale, {super.key});

  @override
  _PaymentHistoryDetailState createState() => _PaymentHistoryDetailState();
}

class _PaymentHistoryDetailState extends State<PaymentHistoryDetail> {
  bool isLoading = false;
  Specific_Order_Payment_History_Data? data;
  List<PaymentHistory> paymentData = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSpecificOrderPaymentHistoryData();
  }

  // Call the API to fetch the tailor list
  Future<void> getSpecificOrderPaymentHistoryData() async {
    setState(() {
      isLoading = true;
    });
    try {
      Particular_Customer_Order_Payment_History_Response_Model model =
      await CallService().getParticularOrderPaymentHistory(widget.orderId);
      setState(() {
        data = model.data!;
        paymentData = data!.paymentHistory!;
        print('Previous payment History List Length is : ${paymentData.length}');
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching tailors: $e');
      setState(() {
        isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBarWithBack(
          title: AppLocalizations.of(context)!.payment_history,
          hasBackButton: true,
          elevation: 2.0,
          leadingIcon: SvgPicture.asset(
            'assets/svgIcon/payment_history_icon_1.svg',
            color: Colors.black,
          ),
          onBackButtonPressed: () async {
            Navigator.pop(context, true);
          },
        ),
        body: isLoading == true?Center(child: CircularProgressIndicator(color: AppColors.newUpdateColor,),):
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AllText(
                    text: '${AppLocalizations.of(context)!.userName} : ',
                    fontFamily: 'Poppins',
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(width: 10),
                  AllText(
                    text: widget.name,
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  AllText(
                    text: '${AppLocalizations.of(context)!.mobileNumber} : ',
                    fontFamily: 'Poppins',
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(width: 10),
                  AllText(
                    text: widget.phoneNumber,
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Payment Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15)],
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AllText(text:'${AppLocalizations.of(context)!.dressName} :',
                          fontFamily: 'Poppins',
                          fontSize: 17,
                          fontWeight: FontWeight.w500,),
                        SizedBox(width: 10),
                        AllText(
                          text: data!.dressName.toString(),
                          fontFamily: 'Poppins',
                          fontSize: 17,
                          fontWeight: FontWeight.w300,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        AllText(text:'${AppLocalizations.of(context)!.advance_payment} :',
                          fontFamily: 'Poppins',
                          fontSize: 17,
                          fontWeight: FontWeight.w500,),
                        SizedBox(width: 10),
                        AllText(
                          text: '₹${data!.advanceReceived.toString()}',
                          fontFamily: 'Poppins',
                          fontSize: 17,
                          fontWeight: FontWeight.w300,
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Divider(),

                    // Headers
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${AppLocalizations.of(context)!.date}', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${AppLocalizations.of(context)!.payment}', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 12),

                    // Payment List
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: paymentData.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                paymentData[index].date != null
                                    ? DateFormat('dd-MM-yyyy').format(DateTime.parse(paymentData[index].date.toString()))
                                    : '',
                              ),
                              Text(
                                paymentData[index].amount.toString() ?? '',
                                style: TextStyle(color: Colors.green),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 16),
                    // Total Payment
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.total_payment,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          '₹${data!.totalAmount.toString()}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20), // bottom padding
            ],
          ),
        ),
      ),
    );
  }
}
