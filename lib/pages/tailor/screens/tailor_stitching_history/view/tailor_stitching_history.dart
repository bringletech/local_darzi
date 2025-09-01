import 'package:cached_network_image/cached_network_image.dart';
import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/apiData/model/tailor_completed_dress_response_model.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/l10n/app_localizations.dart';
import 'package:darzi/pages/tailor/screens/tailor_dashboard/view/tailor_dashboard_new.dart';
import 'package:darzi/pages/tailor/screens/tailor_stitching_history/view/tailor_specific_order_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

class TailorStitchingHistory extends StatefulWidget {
  final Locale locale;
  const TailorStitchingHistory({super.key, required this.locale});

  @override
  State<TailorStitchingHistory> createState() => _TailorStitchingHistoryState();
}

class _TailorStitchingHistoryState extends State<TailorStitchingHistory> {
  bool isLoading = false;
  List<Tailor_Completed_Dress_Data> orderActiveList = [];
  List<Tailor_Completed_Dress_Data> filteredContacts = [];
  final TextEditingController _searchController = TextEditingController();
  String selectedYear = "", selectedMonth = "";
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    //_loadData(); // Call the async method
    // setState(() {
    //   isLoading = true;
    //   WidgetsBinding.instance.addPostFrameCallback((_) async {
    //     Tailor_Completed_Dress_Response_Model model =
    //         await CallService().getCurrentTailorCompletedDress(selectedMonth,selectedYear);
    //     setState(() {
    //       isLoading = false;
    //       orderActiveList = model.data!;
    //       // customersList = model.data!.customers!;
    //       print("list Value is: $orderActiveList");
    //       // print("list Value is: ${customersList.length}");
    //     });
    //   });
    // });
    getMonthlySalesData();
    _searchController.addListener(_filterContacts);
  }

  void _filterContacts() {
    String query = _searchController.text.toLowerCase();

    setState(() {
      filteredContacts = orderActiveList.where((contact) {
        final name = contact.name?.toLowerCase() ?? '';
        final dressName = contact.dressName?.toLowerCase() ?? '';
        final mobileNo = contact.mobileNo?.toLowerCase() ?? '';

        return name.contains(query) ||
            dressName.contains(query) ||
            mobileNo.contains(query);
      }).toList();
    });
  }


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
              primary:
                  AppColors.newUpdateColor, // Header color and selected date
              onPrimary: Colors.white, // Text color on header
              onSurface: Colors.black, // Default text color
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
        // selectedYear = picked.year.toString();
        // selectedMonth = picked.month.toString().padLeft(2, '0');
        // print("Selected Month: $selectedMonth");
        // print("Selected Year: $selectedYear");
        selectedYear = picked.year.toString();
        selectedMonth = picked.month.toString(); // yahan padLeft hata diya

        print("Selected Month: $selectedMonth");  // Example: 1,2,...,9,10,11,12
        print("Selected Year: $selectedYear");

        // getMonthlyFilterSalesData(selectedMonth, selectedYear);

        getMonthlyFilterSalesData(selectedMonth, selectedYear);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
          onWillPop: () async {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => TailorDashboardNew(locale: widget.locale)),
            );
            return false;
          },
      child: Scaffold(
        backgroundColor: Colors.white,
    appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.stitching_history,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true, // 👈 yeh add karo
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TailorDashboardNew(
                        locale: widget.locale,
                      )),
                );
                Navigator.pop(context, true);
              },
            ),
          ),
        body: Column(
          children: [
            const SizedBox(height: 5),
                      // Search bar
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: AppColors.newUpdateColor,
                                width: 1.0,
                                style: BorderStyle.solid),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            ),
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)!.mobileOrName,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.search,
                                  size: 30,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => _selectMonthYear(context), // Open Date Picker
                              child: SvgPicture.asset(
                                'assets/svgIcon/calender.svg',
                                width: 24,
                                height: 24,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              selectedMonth.isNotEmpty && selectedYear.isNotEmpty
                                  ? "${DateFormat('MMMM').format(DateTime(int.parse(selectedYear), int.parse(selectedMonth)))} $selectedYear"
                                  : DateFormat('MMMM yyyy').format(
                                      _selectedDate), // Default: Current month-year
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
            // 🔹 Agar Active List me data hai
            isLoading == true
                ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.newUpdateColor,
                )) :
            orderActiveList.isNotEmpty
                ? Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _searchController.text.isEmpty
                    ? orderActiveList.length
                    : filteredContacts.length,
                itemBuilder: (context, index) {
                  final contact = _searchController.text.isEmpty
                      ? orderActiveList[index]
                      : filteredContacts[index];

                  DateTime fudgeThis = DateFormat("yyyy-MM-dd")
                      .parse(contact.dueDate.toString());
                  String dateTime =
                  DateFormat("dd-MM-yyyy").format(fudgeThis);

                  String URL = contact.dressImgUrl.toString();

                  return GestureDetector(
                    onTap: () {
                      // Yaha navigation code add karna hai
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                TailorSpecificOrderDetails(contact.id,
                                    locale: widget.locale)),
                      );

                    },
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 9,
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: CachedNetworkImage(
                            height: 90,
                            width: 80,
                            imageUrl: URL,
                            // progressIndicatorBuilder: (context, url,
                            //     downloadProgress) =>
                            //     CircularProgressIndicator(
                            //         value: downloadProgress.progress,
                            //         color: AppColors.newUpdateColor),
                            errorWidget: (context, url, error) =>
                                Image.network(
                                    'https://dummyimage.com/500x500/aaa/000000.png&text=No+Image',
                                    width: 110,
                                    height: 110,
                                    fit: BoxFit.cover),
                          ),
                        ),
                        title: Text(
                          "${contact.name ?? AppLocalizations.of(context)!.noUserName} "
                              "(${contact.dressName ?? AppLocalizations.of(context)!.noDressName})",
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 19,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${AppLocalizations.of(context)!.dueDate}:  $dateTime",
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              contact.status == "Received"
                                  ? "${AppLocalizations.of(context)!.dressStatus}: ${AppLocalizations.of(context)!.order_Received}"
                                  : contact.status == "InProgress"
                                  ? "${AppLocalizations.of(context)!.dressStatus}: ${AppLocalizations.of(context)!.dressProgress}"
                                  : contact.status == "Cancelled"
                                  ? "${AppLocalizations.of(context)!.dressStatus}: ${AppLocalizations.of(context)!.order_cancelled}"
                                  : contact.status == "PaymentDone"
                                  ? "${AppLocalizations.of(context)!.dressStatus}: ${AppLocalizations.of(context)!.payment_done}"
                                  : "${AppLocalizations.of(context)!.dressStatus}: ${AppLocalizations.of(context)!.dressComplete}",
                              style: TextStyle(
                                fontFamily: "Inter",
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: contact.status == "Received" ||
                                    contact.status == "InProgress"
                                    ? AppColors.statusColor
                                    : AppColors.primaryRed,
                              ),
                            ),
                          ],
                        ),
                        trailing: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.cost,
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 19,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '₹${contact.stitchingCost.toString()}',
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ) : Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/no_results.png", height: 80),
                    const SizedBox(height: 10),
                    Text(
                      AppLocalizations.of(context)!.no_stitching_history,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getMonthlySalesData() async {
    setState(() {
      isLoading = true;
    });

    try {
      Tailor_Completed_Dress_Response_Model model =
      await CallService().getCurrentTailorCompletedDress();

      setState(() {
        isLoading = false;
        orderActiveList = model.data ?? []; // null safety
        print("list Value is: $orderActiveList");
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error while fetching sales data: $e");
    }
  }

  void getMonthlyFilterSalesData(String month, String year) {
    setState(() {
      isLoading = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Tailor_Completed_Dress_Response_Model model =
      await CallService().getCurrentTailorFilterCompletedDress(month, year);

      setState(() {
        isLoading = false;
        orderActiveList = model.data ?? [];
        print("Filtered list Value is: $orderActiveList");
      });
    });
  }

}
