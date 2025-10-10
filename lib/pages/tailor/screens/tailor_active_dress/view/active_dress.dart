import 'package:cached_network_image/cached_network_image.dart';
import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/apiData/model/current_tailor_detail_response.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/l10n/app_localizations.dart';
import 'package:darzi/pages/tailor/screens/tailor_active_dress/view/tailor_full_active_dress.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../tailor_dashboard/view/tailor_dashboard_new.dart';

class ActiveDress extends StatefulWidget {
  final Locale locale;
  const ActiveDress({super.key, required this.locale});

  @override
  State<ActiveDress> createState() => _ActiveDressState();
}

class _ActiveDressState extends State<ActiveDress> {
  bool isLoading = false;

  SpecificCustomerOrder? orderActiveList;
  List<Customers> customersList = [];
  List<Missed> missed = [];
  List<Today> today = [];
  List<ThisWeek> thisWeek = [];
  List<NextWeek> nextWeek = [];
  List<Later> later = [];
  int? expandedIndex; // track which tile is open

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    Current_Tailor_Details_Response model =
    await CallService().getCurrentTailorDetails();
    setState(() {
      isLoading = false;
      customersList = model.data!.customers!;
      orderActiveList = model.data!.order;
      missed = orderActiveList?.missed ?? [];
      today = orderActiveList?.today ?? [];
      thisWeek = orderActiveList?.thisWeek ?? [];
      nextWeek = orderActiveList?.nextWeek ?? [];
      later = orderActiveList?.later ?? [];
    });
  }

  Widget _buildList<T>(List<T> list) {
    if (list.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(12.0),
        child: Text("No data available"),
      );
    }
    return Column(
      children: list.map((item) {
        final dynamic contact = item;
        DateTime fudgeThis =
        DateFormat("yyyy-MM-dd").parse(contact.dueDate.toString());
        String dateTime = DateFormat("dd-MM-yyyy").format(fudgeThis);
        String URL = contact.dressImgUrl.toString();

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    TailorFullActiveDress(contact.id.toString(), locale: widget.locale),
              ),
            );
          },
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  height: 70,
                  width: 70,
                  imageUrl: URL,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress,
                          color: AppColors.newUpdateColor),
                  errorWidget: (context, url, error) => Image.network(
                      'https://dummyimage.com/500x500/aaa/000000.png&text=No+Image',
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover),
                ),
              ),
              title: Text(
                "${contact.name ?? AppLocalizations.of(context)!.noUserName} (${contact.dressName ?? AppLocalizations.of(context)!.noDressName})",
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${AppLocalizations.of(context)!.dueDate}: $dateTime",
                    style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 13,
                        fontWeight: FontWeight.w400),
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
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: contact.status == "Received" ||
                          contact.status == "InProgress"
                          ? AppColors.statusColor
                          : AppColors.primaryRed,
                    ),
                  )
                ],
              ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${AppLocalizations.of(context)!.cost}",
                    style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  Text(
                    '₹${contact.stitchingCost.toString()}',
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
      }).toList(),
    );
  }


  Widget _buildExpansionTile({
    required String title,
    required int index,
    required List list,
  }) {
    bool isExpanded = expandedIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        children: [
          // 🔹 Header hamesha orange
          InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  expandedIndex = null; // agar open h toh close ho jaye
                } else {
                  expandedIndex = index; // sirf ek hi open hoga
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.newUpdateColor, // 🔸 Always orange
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  isExpanded
                      ? const Icon(Icons.remove, color: Colors.white)
                      : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (list.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            list.length.toString(),
                            style: const TextStyle(
                                color: Colors.black, fontSize: 12),
                          ),
                        ),
                      const SizedBox(width: 8),
                      const Icon(Icons.add, color: Colors.white),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 🔹 Expand hone par white list
          if (isExpanded)
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(10),
              child: _buildList(list), // 👈 yaha tumhara list widget
            ),
        ],
      ),
    );
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
            AppLocalizations.of(context)!.my_orders,
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
        body: isLoading
            ? Center(
            child: CircularProgressIndicator(
                color: AppColors.newUpdateColor))
            : (
            missed.isEmpty &&
            today.isEmpty &&
            thisWeek.isEmpty &&
            nextWeek.isEmpty &&
            later.isEmpty)
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/no_results.png", height: 80),
            Center(
              child: Text(
                AppLocalizations.of(context)!.no_active_dress,
                style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: Colors.grey),
              ),
            ),
          ],
        )
            : SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30,),
              _buildExpansionTile(
                  title: AppLocalizations.of(context)!.missed, index: 0, list: missed),
              _buildExpansionTile(
                  title: AppLocalizations.of(context)!.today, index: 1, list: today),
              _buildExpansionTile(
                  title: AppLocalizations.of(context)!.this_week, index: 2, list: thisWeek),
              _buildExpansionTile(
                  title: AppLocalizations.of(context)!.next_week, index: 3, list: nextWeek),
              _buildExpansionTile(
                  title: AppLocalizations.of(context)!.later, index: 4, list: later),
              // _buildExpansionTile(
              //     title: AppLocalizations.of(context)!.complete_Orders, index: 0, list: missed),
            ],
          ),
        ),
      ),
    );
  }
}
