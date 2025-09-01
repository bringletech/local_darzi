import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/apiData/model/notification_response_model.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/common/widgets/tailor/common_app_bar_with_back.dart';
import 'package:darzi/l10n/app_localizations.dart';
import 'package:darzi/pages/tailor/screens/tailor_dashboard/view/tailor_dashboard_new.dart';
import 'package:darzi/pages/tailor/screens/tailor_notification/view/user_profile_review.dart';
import 'package:flutter/material.dart';

class TailorNotificationScreen extends StatefulWidget {
  final Locale? locale;
  const TailorNotificationScreen({super.key, this.locale});

  @override
  State<TailorNotificationScreen> createState() =>
      _TailorNotificationScreenState();
}

class _TailorNotificationScreenState extends State<TailorNotificationScreen> {
  List<NotificationData>? notificationData = [];
  bool isLoading = false;
  int? selectedNotificationIndex;

  @override
  void initState() {
    super.initState();
    getTailorNotification();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => TailorDashboardNew(
                locale: widget.locale!,
              )),
        );
        return false;
      },
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.application_notifications,
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => TailorDashboardNew(
                      locale: widget.locale!,
                    )),
              );
            },
          ),
        ),
        // CustomAppBarWithBack(
        //   title: AppLocalizations.of(context)!.application_notifications,
        //   hasBackButton: true,
        //   elevation: 2.0,
        //   onBackButtonPressed: () {
        //     Navigator.pushReplacement(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) => TailorDashboardNew(
        //             locale: widget.locale!,
        //           )),
        //     );
        //   },
        // ),
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
            Image.asset(
              "assets/images/no_results.png",
              height: 80,
            ),
            Center(
              child: Text(
                  AppLocalizations.of(context)!
                      .no_notification_message,
                  style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: Colors.grey)),
            ),
          ],
        )
            : Padding(
          padding: const EdgeInsets.only(top: 5),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: notificationData!.length,
            itemBuilder: (context, index) {
              final item = notificationData![index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: GestureDetector(
                  onTap: () async {
                    setState(() {
                      selectedNotificationIndex = index;
                    });

                    // Navigate to next screen and wait for return
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfileReview(
                          notificationId: item.id.toString(),
                          locale: widget.locale,
                        ),
                      ),
                    );

                    // Refresh notifications on return
                    if (result == true) {
                      getTailorNotification();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: item.isViewed == false
                          ? AppColors
                          .newNotificationBackgroundColor
                          : Colors.white,
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
                          item.title ?? '',
                          style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.message ?? '',
                          style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                              color: Colors.black54),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            item.time ?? '',
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w300,
                                fontSize: 12,
                                color: Colors.black54),
                          ),
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

  void getTailorNotification() async {
    setState(() {
      isLoading = true;
    });
    NotificationResponseModel model =
    await CallService().getNotification();
    setState(() {
      isLoading = false;
      notificationData = model.data;
    });
  }
}
