import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/apiData/model/customer_payment_history_response_model.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/common/all_text.dart';
import 'package:darzi/common/widgets/tailor/common_app_bar_with_back.dart';
import 'package:darzi/l10n/app_localizations.dart';
import 'package:darzi/pages/tailor/screens/tailor_search/view/payment_history_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class PaymentHistoryScreen extends StatefulWidget {
  final BuildContext context;
  final String customerId;
  final String name;
  final String mobile_Number;
  final Locale locale;

  const PaymentHistoryScreen(
      this.context,
      this.customerId,
      this.name,
      this.mobile_Number,
      this.locale, {
        super.key,
      });

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  bool isLoading = false;
  bool isFetchingMore  = false;

  List<Customer_Payment_History_Data> data = [];
  List<Customer_Payment_History_Data> filteredTailors = [];
  String dateTime = "", amount_paid = "", payment_status = "";
  String amount = "", paymentDate = "", orderStatus = "", advanceAmount = "",advancepaymentDate = "",advanceReceivedStatus = "";
  bool _showStaticPaymentView = false;
  int page = 1, limit = 10;
  final ScrollController scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    setState(() {
      fetchTailorList();
    });

    // Add listener to the scroll controller for pagination
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent &&
          !isFetchingMore) {
        loadMoreStories();
      }
    });
  }

  void loadMoreStories() async {
    if (isFetchingMore) return;

    setState(() {
      isFetchingMore = true;
    });

    try {
      page++;
      //print("My Current Page Value is : ${page++}");
      print("My Current Page Value is : $limit");
      try {
        Customer_Payment_History_Response_Model model =
        await CallService().getPaymentHistory(widget.customerId,page, limit);
        setState(() {
          filteredTailors.addAll(model.data!);
        });
      } catch (e) {
        print('Error fetching tailors: $e');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading more stories: $e");
    } finally {
      setState(() {
        isFetchingMore = false;
      });
    }
  }

  // Call the API to fetch the tailor list
  Future<void> fetchTailorList() async {
    setState(() {
      isLoading = true;
    });
    try {
      Customer_Payment_History_Response_Model model =
      await CallService().getPaymentHistory(widget.customerId,page, limit);
      setState(() {
        data = model.data!;
        filteredTailors = data;
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
  void dispose() {
    super.dispose();
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
        body:  isLoading
            ? const Center(
          child: CircularProgressIndicator(
            color: AppColors.newUpdateColor,
          ),
        )
            : filteredTailors.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/no_results.png",
                height: 80,
              ),
              SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!
                    .no_payment_history_data_available,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
            :Padding(
          padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                SizedBox(height: 20),
                Row(
                  children: [
                    AllText(
                      text:
                      '${AppLocalizations.of(context)!.userName} : ',
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
                SizedBox(height: 10),
                Row(
                  children: [
                    AllText(
                      text:
                      '${AppLocalizations.of(context)!.mobileNumber} : ',
                      fontFamily: 'Poppins',
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(width: 10),
                    AllText(
                      text: widget.mobile_Number,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.all(10),
                        itemCount: filteredTailors.length,
                        itemBuilder: (builder,index){
                          final tailor = filteredTailors[index];
                          String orderId = tailor.orderId.toString();
                          print("specific Order id is ${orderId}");
                          return Container(
                            padding: EdgeInsets.all(12),
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 0,
                                  blurRadius: 4,
                                  offset: const Offset(0, -2),
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 0,
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(  width: MediaQuery.of(context).size.width*0.5,
                                      child: Text('${AppLocalizations.of(context)!.dressName} : ',style: TextStyle(
                                          fontFamily: "Poppins",fontSize: 17,fontWeight: FontWeight.w500
                                      ),),
                                    ),
                                    Container(
                                      child: Text(tailor.dressName.toString(),style: TextStyle(
                                          fontFamily: "Poppins",fontSize: 17,fontWeight: FontWeight.w300
                                      ),),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.5,
                                      child: Text('${AppLocalizations.of(context)!.advance_payment} :',style: TextStyle(
                                          fontFamily: "Poppins",fontSize: 17,fontWeight: FontWeight.w500
                                      ),),
                                    ),
                                    Container(
                                      child: Text('₹${tailor.advanceReceived}',style: TextStyle(
                                          fontFamily: "Poppins",fontSize: 17,fontWeight: FontWeight.w300
                                      ),),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                GestureDetector(
                                  onTap:(){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PaymentHistoryDetail(orderId,widget.name,widget.mobile_Number,widget.locale,)));
                                  },
                                  child: Container(
                                    width: 250,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: AppColors.newUpdateColor,
                                      borderRadius: BorderRadius.circular(8),
                                      // border: Border.all(color: AppColors.newUpdateColor, width: 2),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(AppLocalizations.of(context)!.show_payment_history,
                                            style: TextStyle(
                                              color: Colors.white,
                                              // color: isPressed ? Colors.white : AppColors.newUpdateColor,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
