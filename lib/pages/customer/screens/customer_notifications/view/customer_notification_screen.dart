import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/apiData/model/notification_response_model.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/common/widgets/tailor/common_app_bar_with_back.dart';
import 'package:darzi/l10n/app_localizations.dart';
import 'package:darzi/pages/customer/screens/customer_dashboard/view/customer_dashboard_new.dart';
import 'package:darzi/pages/customer/screens/customer_notifications/view/cancelled_order_notification_screen.dart';
import 'package:darzi/pages/customer/screens/customer_notifications/view/completed_order_notification_screen.dart';
import 'package:darzi/pages/customer/screens/customer_notifications/view/new_order_received_notification_screen.dart';
import 'package:darzi/pages/customer/screens/customer_notifications/view/order_progress_notification_screen.dart';
import 'package:darzi/pages/customer/screens/customer_notifications/view/received_payment_notification_screen.dart';
import 'package:darzi/pages/customer/screens/customer_notifications/view/reopened_order_notification_screen.dart';
import 'package:flutter/material.dart';


class CustomerNotificationScreen extends StatefulWidget {
  final Locale? locale;
  const CustomerNotificationScreen({super.key, this.locale});

  @override
  State<CustomerNotificationScreen> createState() =>
      _CustomerNotificationScreenState();
}

class _CustomerNotificationScreenState extends State<CustomerNotificationScreen> {
  List<NotificationData>? notificationData = [];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTailorNotification();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      // Navigate to TailorDashboardNew when device back button is pressed
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => CustomerDashboardNew(
              locale: widget.locale!,
            )),
      );
      return false; // Prevent default back behavior
    },
    child:Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height,
        ),
        child: Scaffold(
            extendBody: true,
            backgroundColor: Colors.white,
            appBar: CustomAppBarWithBack(
              title: AppLocalizations.of(context)!.application_notifications,
              hasBackButton: true,
              elevation: 2.0,
              onBackButtonPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomerDashboardNew(
                        locale: widget.locale!,
                      )),
                );
                Navigator.pop(context, true);
              },
            ),
            body: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                    color: AppColors.primaryRed,
                  ))
                : notificationData == null || notificationData!.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/no_results.png",height: 80,),
                          Center(
                            child: Text(
                              AppLocalizations.of(context)!
                                  .no_notification_message,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey)
                            ),
                          ),
                        ],
                      )
                    : Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Container(
                          color: Colors.white,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: notificationData!.length,
                            itemBuilder: (context, index) {
                              final item = notificationData![index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 5,),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: GestureDetector(
                                      onTap: (){
                                        item.title.toString() == "Your Order is in Progress"?
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => OrderProgressNotificationScreen(notificationId:item.id.toString(),locale: widget.locale!),
                                            )):item.title.toString() == "Good News! Your Order is Ready"?
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CompletedOrderNotificationScreen(notificationId:item.id.toString(),locale: widget.locale!),
                                            )):item.title.toString() == "Order Cancelled"?
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CancelledOrderNotificationScreen(notificationId:item.id.toString(),locale: widget.locale!),
                                            )):item.title.toString() == "New Order Placed"?
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => NewOrderReceivedNotificationScreen(notificationId:item.id.toString(),locale: widget.locale!),
                                            )):item.title.toString() == "Order Reopened"?
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ReopenedOrderNotificationScreen(notificationId:item.id.toString(),locale: widget.locale!),
                                            )):item.title.toString() == "Payment Received"?
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ReceivedPaymentNotificationScreen(notificationId:item.id.toString(),locale: widget.locale!),
                                            )):Container();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: item.isViewed==false?AppColors.newNotificationBackgroundColor:Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.25),
                                              blurRadius: 8,
                                              spreadRadius: 1,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.title.toString(),
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 17,
                                                  color: Colors.black),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              item.message.toString(),
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 12, color: Colors.black54),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  item.time.toString(),
                                                  style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontWeight: FontWeight.w300,
                                                      fontSize: 12, color: Colors.black54),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                                  ),
                    ),
        ),
     ),
    );
  }

  void getTailorNotification() {
    setState(() {
      isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        NotificationResponseModel model = await CallService().getNotification();
        setState(() {
          isLoading = false;
          notificationData = model.data;
          print('Notification Data Length is :$notificationData');
        });
      });
    });
  }
}
