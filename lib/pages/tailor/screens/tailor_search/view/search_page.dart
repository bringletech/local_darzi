import 'package:cached_network_image/cached_network_image.dart';
import 'package:darzi/apiData/call_api_service/call_service.dart';
import 'package:darzi/apiData/model/current_tailor_detail_response.dart';
import 'package:darzi/apiData/model/customer_delete_response_model.dart';
import 'package:darzi/colors.dart';
import 'package:darzi/common/widgets/tailor/common_app_bar_search_customer_without_back.dart';
import 'package:darzi/l10n/app_localizations.dart';
import 'package:darzi/pages/tailor/screens/tailor_dashboard/view/tailor_dashboard_new.dart';
import 'package:darzi/pages/tailor/screens/tailor_search/view/payment_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import 'add_new_dress.dart';
import 'dresses.dart';
import 'measurments.dart';

class SearchPage extends StatefulWidget {
  static const TextStyle titleStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  final Locale locale;
  SearchPage({super.key, required this.locale});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Customers> filteredContacts = [];
  final TextEditingController _searchController = TextEditingController();
  List<Customers> customersList = [];
  List<SpecificCustomerOrder> order = [];
  bool isLoading = false;
  bool isRefreshing = false;
  String customerId = "";


  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_filterContacts);
  }

  Future<void> _loadData() async {
    if (!isRefreshing) {
      // Show loading indicator only for initial load, not during refresh
      setState(() {
        isLoading = true;
      });
    }
    try {
      Current_Tailor_Response model =
      await CallService().getCurrentTailorDetails();
      setState(() {
        customersList = model.data?.customers ?? [];
        filteredContacts = customersList;
        order = model.data?.order ?? [];
        print("Customer list length is ${customersList.length}");
        print("Customer list length is ${order.length}");
      });
    } finally {
      setState(() {
        isLoading = false;
        isRefreshing = false; // Reset refresh state
      });
    }
  }

  void _filterContacts() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredContacts = customersList.where((contact) {
        return contact.name!.toLowerCase().contains(query) ||
            contact.mobileNo!.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _deleteCustomerData(String customerId) async {
    var map = Map<String, dynamic>();
    map['customerId'] = customerId;
    print("Map is $map");
    setState(() {
      isLoading = true;
    });

    try {
      CustomerDeleteResponseModel model =
      await CallService().removeCustomerFromList(map);
      String deleteMessage = model.message.toString();
      print("Delete Response: $deleteMessage");

      // Refresh the list after deletion
      await _loadData();
    } catch (error) {
      print("Error deleting customer: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
      child: isLoading == true?Center(child: CircularProgressIndicator(
        color: AppColors.newUpdateColor,
      ),):Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBarSearchCustomerWithOutBack(
          title: AppLocalizations.of(context)!.searchCustomer,
          hasBackButton: true,
          elevation: 2.0,
          leadingIcon: SvgPicture.asset(
            'assets/svgIcon/searchCustomer.svg',
            color: Colors.black,
          ),
          onBackButtonPressed: () {
            Navigator.pop(context);
          },
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              isRefreshing = true; // Show RefreshIndicator
            });
            await _loadData();
          },
          child: Column(
            children: [
              const SizedBox(height: 5),
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                        color: const Color(0xFF000000),
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
                        icon: const Icon(Icons.search,size: 30,),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: isLoading && !isRefreshing
                      ? Center(
                    child:
                    CircularProgressIndicator(color: AppColors.newUpdateColor),
                  )
                      : filteredContacts.isEmpty
                      ? Column(
                    children: [
                      Image.asset("assets/images/no_results.png",height: 80,),
                      Center(
                        child: Text(
                          AppLocalizations.of(context)!.no_customer_found,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  )
                      :ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: filteredContacts.length,
                    itemBuilder: (context, index) {
                      final contact = filteredContacts[index];
                      //customerId = contact.id.toString();
                      // print("Customer Id is $customerId");
                      String profile = contact.profileUrl.toString();
                      print("profile url is $profile");
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15), // 👈 Card ke beech ka space kam kiya
                        child: InkWell(
                          onTap: (){
                            final id = contact.id.toString(); // Local reference to avoid delay
                            //print("Customer Id is $id");
                            final name = contact.name.toString();
                            final mobileNumber = contact.mobileNo.toString();
                            Future.microtask(() {
                              showSearchBottomSheet(context, id,name,mobileNumber);
                            });
                          },
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 10,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// IMAGE VIEW ///
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: InkWell(
                                      onTap: (){
                                        final id = contact.id.toString(); // Local reference to avoid delay
                                        final name = contact.name.toString();
                                        final mobileNumber = contact.mobileNo.toString();
                                        final orderId = order[index].id.toString();
                                        Future.microtask(() {
                                          showSearchBottomSheet(context, id,name,mobileNumber);
                                        });
                                      },
                                      child: CachedNetworkImage(
                                        width: 70,
                                        height: 70,
                                        imageUrl: contact.profileUrl.toString(),
                                        fit: BoxFit.cover,
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                            CircularProgressIndicator(
                                              value: downloadProgress.progress,
                                              color: AppColors.newUpdateColor,
                                            ),
                                        errorWidget: (context, url, error) =>
                                            SvgPicture.asset(
                                              'assets/svgIcon/profilepic.svg',
                                              // Default profile icon
                                              width: 120,
                                              height: 120,
                                            ),
                                      ),
                                    ),
                                  ),
                                  /// CARD DETAIL VIEW ///
                                  const SizedBox(width: 8), // 👈 Spacing Between Image and Text Kam Kiya
                                  Expanded(
                                    flex: 5,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          contact.name ?? AppLocalizations.of(context)!.noUserName,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 19,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Row(crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/svgIcon/location.svg',
                                            ),
                                            SizedBox(width: 5,),
                                            Expanded(
                                              child: Container(
                                                width: MediaQuery.of(context).size.width*0.2,
                                                child: Text(
                                                  contact.address ?? AppLocalizations.of(context)!.userNoAddress,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: const TextStyle(
                                                    color: Color(0xFF000000),
                                                    fontSize: 13,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "${AppLocalizations.of(context)!.ph_no}: ${contact.mobileNo!}",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 13,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  /// ICON BUTTONS ///
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          final id = contact.id.toString(); // Local reference to avoid delay
                                          final name = contact.name.toString();
                                          final mobileNumber = contact.mobileNo.toString();
                                          Future.microtask(() {
                                            showSearchBottomSheet(context, id,name,mobileNumber);
                                          });
                                        },
                                        borderRadius: BorderRadius.circular(15),
                                        child: Container(
                                          width: 50,
                                          // height: 50,
                                          //color: Colors.red,
                                          child: SvgPicture.asset(
                                            'assets/svgIcon/more_option.svg',
                                            width: 25,
                                            height: 25,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      GestureDetector(
                                        onTap: (){
                                          _makePhoneCall(context,contact.mobileNo.toString());
                                        },
                                        child: SvgPicture.asset(
                                          'assets/svgIcon/phone_color.svg',
                                          width: 25,
                                          height: 25,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )

              ),
            ],
          ),
        ),
      ),
    );
  }

  void _makePhoneCall(BuildContext context,String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);

    // 📌 कॉल परमिशन चेक करें
    var status = await Permission.phone.status;
    if (!status.isGranted) {
      status = await Permission.phone.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Call permission is required")),
        );
        return;
      }
    }

    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not launch $callUri")),
      );
    }
  }
  void showSearchBottomSheet(BuildContext context1, String customerId, String name, String mobile_Number) {
    showModalBottomSheet(
      context: context1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Draggable handle
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            // List of options
            ListTile(
              leading: SvgPicture.asset('assets/svgIcon/circleMeasure.svg'),
              title: Text(
                AppLocalizations.of(context)!.measurements,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 17,
                    color: Colors.black),
              ),
              onTap: () {
                Navigator.pop(context1);
                Navigator.push(
                    context1,
                    MaterialPageRoute(
                        builder: (context1) => MeasurementsScreen(
                            context1, customerId, widget.locale)));
              },
            ),
            Divider(),
            ListTile(
              leading: SvgPicture.asset('assets/svgIcon/dresses.svg'),
              title: Text(AppLocalizations.of(context)!.dresses,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                      color: Colors.black)),
              onTap: () {
                Navigator.pop(context1);
                Navigator.push(
                    context1,
                    MaterialPageRoute(
                        builder: (context1) =>
                            oldDress(locale:widget.locale,customerId: customerId, context: context1)));
              },
            ),
            Divider(),
            ListTile(
              leading: SvgPicture.asset('assets/svgIcon/add.svg'),
              title: Text(AppLocalizations.of(context)!.addNewDress,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                      color: Colors.black)),
              onTap: () {
                Navigator.pop(context1);
                Navigator.push(
                    context1,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddNewDress(context1, customerId, widget.locale)));
              },
            ),
            Divider(),
            ListTile(
              leading: SvgPicture.asset('assets/svgIcon/remove_icon.svg'),
              title: Text(AppLocalizations.of(context)!.remove_customer,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                      color: Colors.black)),
              onTap: () {
                Navigator.pop(context1);
                showRemoveCustomerDialog(context1, customerId, widget.locale);
                //Navigator.push(context1,  MaterialPageRoute(builder: (context) =>AddNewDress(context1,customerId,widget.locale)));
              },
            ),
            Divider(),
            ListTile(
              leading: SvgPicture.asset('assets/svgIcon/payment_history_icon.svg'),
              title: Text(AppLocalizations.of(context)!.payment_history,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                      color: Colors.black)),
              onTap: () {
                Navigator.pop(context1);
                Navigator.push(
                    context1,
                    MaterialPageRoute(
                        builder: (context) =>
                            PaymentHistoryScreen(context1,customerId,name,mobile_Number,widget.locale)));
                //Navigator.push(context1,  MaterialPageRoute(builder: (context) =>AddNewDress(context1,customerId,widget.locale)));
              },
            ),
            Divider(),
          ],
        );
      },
    );
  }

  void showRemoveCustomerDialog(
      BuildContext context, String customerId, Locale locale) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            AppLocalizations.of(context)!.confirm_remove_customer,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                fontSize: 20),
          ),
          content: Text(
            AppLocalizations.of(context)!.confirm_remove_customer_message,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontFamily: 'Inter',
                fontSize: 16,
                color: Colors.grey),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 47,
                  width: 100,
                  child: Card(
                    color: AppColors.newUpdateColor,
                    elevation: 4,
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop(); // Close the dialog
                        await _deleteCustomerData(
                            customerId); // Delete customer and refresh list
                      },
                      child: Text(
                        AppLocalizations.of(context)!.yesMessage,
                        style: TextStyle(fontFamily: 'Inter',fontSize: 18,fontWeight: FontWeight.w600,color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20,),
                SizedBox(
                  height: 47,
                  width: 100,
                  child: Card(
                    color: Colors.white,
                    elevation: 4,
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: AppColors.newUpdateColor, width: 1.5),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: TextStyle(fontFamily: 'Inter',fontSize: 18,fontWeight: FontWeight.w600,color: AppColors.newUpdateColor),
                      ),
                    ),
                  ),
                ),

              ],
            )
          ],
        );
      },
    );
  }
}