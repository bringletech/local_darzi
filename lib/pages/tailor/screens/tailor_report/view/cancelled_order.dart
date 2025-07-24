import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:darzi/apiData/model/get_cancelled_order_response_model.dart';
import 'package:darzi/l10n/app_localizations.dart';
import 'package:darzi/pages/tailor/screens/tailor_dashboard/view/tailor_dashboard_new.dart';
import 'package:darzi/pages/tailor/screens/tailor_report/view/tailor_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../apiData/call_api_service/call_service.dart';
import '../../../../../colors.dart';
import '../../../../../common/widgets/tailor/common_app_bar_with_back.dart';
import 'cancelled_order_fullView.dart';

class CancelledOrder extends StatefulWidget {
  final Locale locale;
  const CancelledOrder({super.key, required this.locale});

  @override
  State<CancelledOrder> createState() => _CancelledOrderState();
}

class _CancelledOrderState extends State<CancelledOrder> {
  bool isLoading = false;
  File? _selectedImage;
  List<CancelledOrderData>? cancelledData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTailorCancelledOrder();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Navigate to TailorDashboardNew when device back button is pressed
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => TailorDashboardNew(
                      locale: widget.locale,
                    )),
          );
          return false; // Prevent default back behavior
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBarWithBack(
              title: AppLocalizations.of(context)!.cancel_order_title,
              hasBackButton: true,
              elevation: 2.0,
              leadingIcon: SvgPicture.asset(
                'assets/svgIcon/dress.svg', //just change my image with your image
                color: Colors.black,
              ),
              onBackButtonPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          TailorDashboardNew(locale: widget.locale)),
                );
                Navigator.pop(context, true);
              }),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context)!.recentData,
                      style: TextStyle(
                          fontSize: 19,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: cancelledData!.length,
                        itemBuilder: (context, index) {
                          final order = cancelledData![index];
                          return GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CancelledOrderFullview(
                                            orderId: order.id.toString(),
                                            locale: widget.locale,
                                          )));

                              // For Refreshing this screen
                             //  final result = await Navigator.push(
                             //    context,
                             //    MaterialPageRoute(
                             //      builder: (context) => CancelledOrderFullview(
                             //        orderId: order.id.toString(),
                             //        locale: widget.locale,
                             //      ),
                             //    ),
                             //  );
                             //
                             // // Refresh list if result is true
                             //  if (result == true) {
                             //    getTailorCancelledOrder();
                             //  }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: Row(
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
                                          : (order.dressImgUrl
                                                  .toString()
                                                  .isNotEmpty)
                                              ? CachedNetworkImage(
                                                  height: 70,
                                                  width: 70,
                                                  imageUrl: order.dressImgUrl
                                                      .toString(),
                                                  fit: BoxFit.cover,
                                                  progressIndicatorBuilder: (context,
                                                          url,
                                                          downloadProgress) =>
                                                      CircularProgressIndicator(
                                                    value: downloadProgress
                                                        .progress,
                                                    color: AppColors.newUpdateColor,
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      Image.network(
                                                          'https://dummyimage.com/500x500/aaa/000000.png&text=No+Image',
                                                          width: 70,
                                                          height: 70,
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
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order.customer!.name != null
                                            ? order.customer!.name.toString()
                                            : AppLocalizations.of(context)!
                                                .noUserName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text("Due Date: ${order.dueDate}"),
                                      Text(
                                        "Status: ${order.status}",
                                        style: const TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )
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
        ));
  }

  void getTailorCancelledOrder() {
    setState(() {
      isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        GetCancelled_Order_Response_Model model =
            await CallService().getCancelledOrder();
        setState(() {
          isLoading = false;
          cancelledData = model.data;
          print('Cancelled order Data Length is :$cancelledData');
        });
      });
    });
  }
}
