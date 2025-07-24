import 'package:darzi/apiData/model/monthly_report_tailor_rsponse_model.dart';
import 'package:darzi/l10n/app_localizations.dart';
import 'package:darzi/pages/tailor/screens/tailor_dashboard/view/tailor_dashboard_new.dart';
import 'package:darzi/pages/tailor/screens/tailor_report/view/cancelled_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import '../../../../../apiData/call_api_service/call_service.dart';
import '../../../../../colors.dart';
import '../../../../../common/widgets/tailor/common_app_bar_with_back.dart';


class TailorReport extends StatefulWidget {
  final Locale locale;
  const TailorReport({super.key, required this.locale});

  @override
  State<TailorReport> createState() => _TailorReportState();
}

class _TailorReportState extends State<TailorReport> {
  bool isLoading = false;
  String totalEarning="",estimate_earning = "",orderReceived="",paymentReceived="",orderCancelled="",
      total_customer = "",new_customer = "",selectedYear = "",selectedMonth = "";
  DateTime _selectedDate = DateTime.now();

  void _selectMonthYear(BuildContext context) async {
    final DateTime? picked = await showMonthYearPicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.yellow[100], // Background of dialog
            colorScheme: ColorScheme.light(
              primary: AppColors.newUpdateColor, // Header color and selected date
              onPrimary: Colors.white,    // Text color on header
              onSurface: Colors.black,    // Default text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                  foregroundColor: AppColors.newUpdateColor
                // foregroundColor: Colors.deepOrange, // Button text color
              ),
            ),
          ),
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                constraints: const BoxConstraints(
                  maxHeight: 500,
                  maxWidth: 350,
                ),
                child: child,
              ),
            ),
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedYear = picked.year.toString();
        selectedMonth = picked.month.toString().padLeft(2, '0');
        print("Selected Month: $selectedMonth");
        print("Selected Year: $selectedYear");
        getMonthlySalesData(selectedMonth, selectedYear);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getMonthlySalesData(selectedMonth,selectedYear);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => TailorDashboardNew(
                locale: widget.locale,
              )),
        );
        return false;
      },
      child: Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height,),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBarWithBack(
              title: AppLocalizations.of(context)!.report,
              hasBackButton: true,
              elevation: 2.0,
              leadingIcon: SvgPicture.asset(
                'assets/svgIcon/report.svg',
                //just change my image with your image
                color: Colors.black,
              ),
              onBackButtonPressed: () async {
                Navigator.pop(context, true);
              }),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                SizedBox(height: 20,),
                Row(children: [
                  GestureDetector(
                    onTap: () => _selectMonthYear(context), // Open Date Picker
                    child: SvgPicture.asset(
                      'assets/svgIcon/calender.svg',
                      width: 24,
                      height: 24,
                    ),
                  ),
                  SizedBox(width: 10,),
                  Text(
                    selectedMonth.isNotEmpty && selectedYear.isNotEmpty
                        ? "${DateFormat('MMMM').format(DateTime(int.parse(selectedYear), int.parse(selectedMonth)))} $selectedYear"
                        : DateFormat('MMMM yyyy').format(_selectedDate), // Default: Current month-year
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                      fontSize: 17,
                    ),
                  ),
                ],),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    statCard(
                      title:AppLocalizations.of(context)!.total_earning,
                      value: totalEarning,
                      onTap: () {
                      },
                    ),
                    statCard(
                      title:AppLocalizations.of(context)!.estimated_earning,
                      value: estimate_earning,
                      onTap: () {},
                    ),


                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    statCard(
                      title: AppLocalizations.of(context)!.order_received_title,
                      value: orderReceived,
                      onTap: () {},
                    ),
                    statCard(
                      title: AppLocalizations.of(context)!.cancelled_order_title,
                      value: orderCancelled,
                      onTap: () {
                        if (orderCancelled!="0") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CancelledOrder(locale: widget.locale,)),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(AppLocalizations.of(context)!.no_cancel_order,),backgroundColor: AppColors.primaryRed,),
                          );
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    statCard(
                      title: AppLocalizations.of(context)!.total_customer,
                      value: total_customer,
                      onTap: () {},
                    ),
                    statCard(
                      title: AppLocalizations.of(context)!.new_customer,
                      value: new_customer,
                      onTap: () {},
                    ),
                  ],
                ),
                SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getMonthlySalesData(String month, String year) {
    setState(() {
      isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Monthly_Sales_Tailor_Response_Model model =
        await CallService().getTailorMonthlySales(month,year);
        setState(() {
          isLoading = false;
          var data = model.data;
          totalEarning = data?.metrics?.actualEarnings?.toString() ?? "0";
          estimate_earning = data?.metrics?.totalEstimate?.toString() ?? "0";
          orderReceived = data?.metrics?.ordersReceived?.toString() ?? "0";
          paymentReceived = data?.metrics?.paymentsReceived?.toString() ?? "0";
          orderCancelled = data?.metrics?.ordersCancelled?.toString() ?? "0";
          total_customer = data?.metrics?.allCustomers?.toString() ?? "0";
          new_customer = data?.metrics?.newCustomers?.toString() ?? "0";
          print('Total Earning is :$totalEarning');
          print('Estimate Earning is :$estimate_earning');
          print('Order Received is :$orderReceived');
          print('Payment Received is :$paymentReceived');
          print('Cancel Order is :$orderCancelled');
          print('Total Customer is :$total_customer');
          print('New Customer is :$totalEarning');
        });
      });
    });
  }

  Widget statCard({
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    final card = Container(
      width: MediaQuery.of(context).size.width * 0.45, // responsive width
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            spreadRadius: 1,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style:TextStyle(
              fontSize: 16, color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
    return onTap != null ? GestureDetector(onTap: onTap, child: card) : card;
  }
}