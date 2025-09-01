import 'package:cached_network_image/cached_network_image.dart';
import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/apiData/model/get_current_customer_list_details_model.dart';
import 'package:darzi/common/widgets/tailor/common_app_bar_with_back.dart';
import 'package:darzi/constants/string_constant.dart';
import 'package:darzi/l10n/app_localizations.dart';
import 'package:darzi/pages/customer/screens/customer_dashboard/view/customer_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../../../colors.dart';
import 'customer_dashboard_new.dart';
import 'mydressesfullview.dart';

class MyDresses extends StatefulWidget {
  final Locale locale;
 MyDresses({super.key, required this.locale});

  @override
  State<MyDresses> createState() => _MyDressesState();
}

class _MyDressesState extends State<MyDresses> {
  List<CustomerOrder> orderList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders(); // Fetch orders when the screen loads
  }

  Future<void> _fetchOrders() async {
    setState(() {
      isLoading = true;
    });
    try {
      // Call the API to get orders list
      Get_Current_Customer_Response_Model model = await CallService().getMyTailorList_order();
      setState(() {
        orderList = model.data?.order ?? []; // Safely assign the order list
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching orders: $e");
      setState(() {
        isLoading = false;
      });
    }
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
              locale: widget.locale,
            )),
      );
      return false; // Prevent default back behavior
    },
      child:Scaffold(
        backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.myDresses,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.white,
        centerTitle: true, // 👈 yeh add karo
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomerDashboardNew(
                        locale: widget.locale,
                      )),
                );
                Navigator.pop(context, true);
          },
        ),
      ),
      // CustomAppBarWithBack(
      //   title: AppLocalizations.of(context)!.myDresses,
      //   hasBackButton: true,
      //   onBackButtonPressed: () async {
      //     final result = await Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //           builder: (context) => CustomerDashboardNew(
      //             locale: widget.locale,
      //           )),
      //     );
      //     Navigator.pop(context, true);
      //   },
      //   elevation: 2.0,
      //   leadingIcon: SvgPicture.asset(
      //     'assets/svgIcon/dress.svg', // Replace with actual SVG asset
      //     color: Colors.black,
      //   ),
      //   color: Colors.white,
      // ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(), // Show loader while fetching
      )
          : orderList.isEmpty
          ?
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/no_results.png",
              height: 80,
            ),
            Center(
            child: Text(
              AppLocalizations.of(context)!.no_dresses_found,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
            ),
                  ),
          ],
        )
          : Container(
        padding: const EdgeInsets.only(top: 20),
        color: Colors.white,
        child: ListView.builder(
          itemCount: orderList.length,
          itemBuilder: (context, index) {
            final order = orderList[index];
            String dressId = order.id.toString();
            print('Specific Dress Id is $dressId');
            DateTime fudgeThis = DateFormat("yyyy-MM-dd").parse(order.dueDate.toString());
            String dateTime = DateFormat("dd-MM-yyyy").format(fudgeThis);
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CustomerFullActiveDress(
                                    dressId,locale: widget.locale)),
                          );
                        },
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          elevation: 9,
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child:
                                  // Image.asset('assets/images/dresssample.png', // Replace with actual image URL
                                  CachedNetworkImage(
                                    imageUrl: order.dressImgUrl.toString(),
                                fit: BoxFit.cover,
                                height: 50,
                                width: 50,
                               errorWidget: (context, url, error) =>  Image.network(
                                'https://dummyimage.com/500x500/aaa/000000.png&text= No+Image+Available',
                                fit: BoxFit.fill
                            ),
                              ),
                            ),
                            title: Text(
                              order.dressName ??
                                  'Dress Name', // Dynamic dress name
                              style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 19,
                                  fontWeight: FontWeight.w500),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${AppLocalizations.of(context)!.dueDate}:  $dateTime",
                                  //"Due Date :  ${dateTime.toString()}",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                    order.status == "Received"
                                        ? "${AppLocalizations.of(context)!.dressStatus}: "
                                        "${AppLocalizations.of(context)!.order_Received}"
                                        : order.status == "InProgress"
                                        ? "${AppLocalizations.of(context)!.dressStatus}: "
                                        "${AppLocalizations.of(context)!.dressProgress}"
                                        : order.status ==
                                        "Cancelled"
                                        ? "${AppLocalizations.of(context)!.dressStatus}: "
                                        "${AppLocalizations.of(context)!.order_cancelled}"
                                        : order.status == "PaymentDone"? "${AppLocalizations.of(context)!.dressStatus}: "
                                        "${AppLocalizations.of(context)!.payment_done}"
                                        : "${AppLocalizations.of(context)!.dressStatus}: "
                                        "${AppLocalizations.of(context)!.dressComplete}",
                                    style: TextStyle(
                                        fontFamily: "Inter",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: order.status == "Received"
                                            || order.status == "InProgress"
                                            || order.status == "PaymentDone"
                                            ? AppColors.statusColor
                                            : AppColors.primaryRed))
                              ],
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'Cost',
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 19,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                                Text(
                                  '₹${order.stitchingCost ?? "0.00"}', // Dynamic cost
                                  style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
        ),
      ),
      ),
    );
  }
}
