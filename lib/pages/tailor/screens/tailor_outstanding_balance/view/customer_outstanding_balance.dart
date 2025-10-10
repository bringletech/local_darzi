import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/apiData/model/outstanding_balance_response_model.dart';
import 'package:darzi/apiData/model/recieve_payment_response_model.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/common/widgets/tailor/common_app_bar_with_back.dart';
import 'package:darzi/l10n/app_localizations.dart';
import 'package:darzi/pages/tailor/screens/tailor_dashboard/view/tailor_dashboard_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class CustomerOutstandingBalance extends StatefulWidget {
  final Locale locale;
  const CustomerOutstandingBalance({
    super.key,
    required this.locale,
  });

  @override
  _CustomerOutstandingBalanceState createState() =>
      _CustomerOutstandingBalanceState();
}

class _CustomerOutstandingBalanceState
    extends State<CustomerOutstandingBalance> {
  int? selected;
  bool isLoading = false;

  // 🔥 Users List (Dynamic Data)
  List<Customers>? customers = [];
  List<CompletedOrders> completedOrders = [];
  String formattedDate1 = "", dressAmount = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTailorOutstandingBalance();
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
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
          ),
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.outstandingBalance1,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,),
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true, // 👈 yeh add karo
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
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
            // CustomAppBarWithBack(
            //     title: AppLocalizations.of(context)!.outstandingBalance1,
            //     hasBackButton: true,
            //     elevation: 2.0,
            //     leadingIcon: SvgPicture.asset(
            //       'assets/svgIcon/outstanding_balance_black.svg', //just change my image with your image
            //       color: Colors.black,
            //     ),
            //     onBackButtonPressed: () async {
            //       final result = await Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => TailorDashboardNew(
            //                   locale: widget.locale,
            //                 )),
            //       );
            //       Navigator.pop(context, true);
            //     }),
            body: Container(
              height: MediaQuery.of(context).size.height,
              child: customers==null || customers!.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/no_results.png",
                          height: 80,
                        ),
                        Center(
                          // Show this message when no outstanding balance exists
                          child: Text(
                              AppLocalizations.of(context)!.no_outstanding_data,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey)),
                        ),
                      ],
                    )
                  : ListView.builder(
                      key: Key('builder ${selected.toString()}'),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      itemCount: customers!.length,
                      itemBuilder: (context, index) {
                        bool isExpanded = selected == index;
                        final balance = customers![index];
                        completedOrders = balance.completedOrders!;
                        //dressOrderId = completedOrders![index].id.toString();
                        return Column(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors
                                      .newUpdateColor, // ✅ **Title part is red**
                                  border: Border.all(
                                      color: Colors.grey.shade500,
                                      width: 1), // ✅ Fixed uniform border
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ExpansionTile(
                                  key: Key(index.toString()),
                                  initiallyExpanded: isExpanded,
                                  trailing: Icon(
                                    isExpanded ? Icons.remove : Icons.add,
                                    color: Colors.white, // ✅ **White icon**
                                  ),
                                  title: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 22,
                                        backgroundColor: Colors.transparent,
                                        child: ClipOval(
                                            child: CachedNetworkImage(
                                          height: 40,
                                          width: 40,
                                          imageUrl:
                                              balance.profileUrl.toString(),
                                          fit: BoxFit.cover,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              CircularProgressIndicator(
                                            value: downloadProgress.progress,
                                            color: AppColors.newUpdateColor,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Image.network(
                                                  'https://dummyimage.com/500x500/aaa/000000.png&text=No+Image',
                                                  width: 40,
                                                  height: 40,
                                                  fit: BoxFit.cover),
                                        )),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          balance.customerName.toString(),
                                          //users[index]['name'],
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  children: <Widget>[
                                    Container(
                                      color: Colors.white,
                                      child: Column(
                                        children: [
                                          _infoRow(
                                            'assets/svgIcon/phone.svg',
                                            AppLocalizations.of(context)!
                                                .mobileNumber,
                                            balance.mobileNo.toString(),
                                          ),
                                          _infoRow(
                                              'assets/svgIcon/rupee_icon.svg',
                                              AppLocalizations.of(context)!
                                                  .pending_Payment,
                                              "₹${balance.totalOutstandingBalance}"),
                                          _infoRow(
                                              'assets/svgIcon/complete_order_icon.svg',
                                              AppLocalizations.of(context)!
                                                  .complete_Orders,
                                              completedOrders.length
                                                  .toString()),
                                          if (isExpanded)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: SizedBox(
                                                height: 47,
                                                width: 200,
                                                child: Card(
                                                  color: AppColors.newUpdateColor,
                                                  elevation: 4,
                                                  shadowColor: Colors.grey,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: TextButton(
                                                    onPressed: () async {
                                                      _showCustomDialog(
                                                        context,
                                                        locale: widget.locale,
                                                        onChangeLanguage:
                                                            (newLocale) {
                                                          // Handle the language change
                                                          print(
                                                              "Language changed to: ${newLocale.languageCode}");
                                                        },
                                                        id: balance.completedOrders!.first.id.toString(),
                                                      );
                                                    },
                                                    child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .payment_Received,
                                                      style: TextStyle(
                                                          fontFamily: 'Inter',
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 13),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  onExpansionChanged: (expanded) {
                                    setState(() {
                                      selected = expanded ? index : null;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        );
                      },
                    ),
            ),
          ),
        ));
  }

  // ✅ **Row Widget for Each Info Line**
  Widget _infoRow(String svgPath, String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding:
                    EdgeInsets.all(8), // ✅ Proper padding inside the circle
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade300, // ✅ Grey circular background
                ),
                child: SvgPicture.asset(
                  svgPath,
                  width: 20, // ✅ Adjust size if needed
                  height: 20,
                  color: Colors.black, // ✅ Black icon
                ), // ✅ Black icon
              ),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w300),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }



  Widget _buildDateField(
      BuildContext context, String hintText, TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
            builder: (context, child) {
              return Theme(
                  data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                    primary: Colors.red,
                    onPrimary: Colors.white,
                    onSurface: Colors.black,
                  )),
                  child: child!);
            });
        if (pickedDate != null) {
          print(pickedDate);
          formattedDate1 = DateFormat('yyyy-MM-dd').format(pickedDate);
          print("Date Value is : $formattedDate1");
          setState(() {
            controller.text = formattedDate1;
          });
          value:
          formattedDate1;
        }
        if (pickedDate != null) {
          formattedDate1 = DateFormat('yyyy-MM-dd').format(pickedDate);
          controller.text = formattedDate1;
        }
      },
    );
  }

  Widget _buildTextField(String hintText, TextEditingController controller,
      {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // ✅ **For Showing Alert Dialog**
  void _showCustomDialog(BuildContext context,
      {required Locale locale, required Function(Locale) onChangeLanguage,required String id}) {
    TextEditingController dateController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    print("My DressId is $id");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            AppLocalizations.of(context)!.payment_information,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                fontSize: 20),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDateField(context,
                  AppLocalizations.of(context)!.payment_Date, dateController),
              const SizedBox(height: 12),
              _buildTextField(AppLocalizations.of(context)!.amount_Received,
                  amountController,
                  isNumber: true),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 47,
                    width: 120,
                    child: Card(
                      color: AppColors.newUpdateColor,
                      elevation: 4,
                      shadowColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          formattedDate1 = dateController.text;
                          dressAmount = amountController.text;
                          // Navigator.of(context).pop(formattedDate1);
                          callTailorPaymentApi(id,formattedDate1, dressAmount);
                          Navigator.of(context).pop(false);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.saveDetails,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 47,
                    width: 120,
                    child: Card(
                      color: Colors.white,
                      elevation: 4,
                      shadowColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                            color: AppColors.newUpdateColor, width: 1.5),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false); // Close the dialog
                        },
                        child: Text(
                          AppLocalizations.of(context)!.cancel,
                          style: TextStyle(
                              color: AppColors.newUpdateColor,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void getTailorOutstandingBalance() {
    setState(() {
      isLoading = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Tailor_Outstanding_Balance_Response_Model model =
      await CallService().getTailorOutstandingBalance();
      setState(() {
        isLoading = false;
        customers = model.data?.customers ?? [];
        print('Outstanding Balance Data Length is: ${customers!.length}');
      });
    });
  }


  void callTailorPaymentApi(String dressId,String formattedDate1, String dressAmount) {
    var map = Map<String, dynamic>();
    map['orderId'] = dressId;
    map['paymentDate'] = formattedDate1;
    map['amount'] = dressAmount;
    print("Map is $map");
    isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Receive_Payment_Response_Model model =
          await CallService().customerDressPayment(map);
      isLoading = false;
      String message = model.message.toString();
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      getTailorOutstandingBalance();
    });
  }
}
