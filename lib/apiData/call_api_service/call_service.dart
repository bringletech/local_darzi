import 'package:darzi/apiData/all_urls/all_urls.dart';
import 'package:darzi/apiData/model/add_new_customer_order_response_model.dart';
import 'package:darzi/apiData/model/add_new_customer_response_model.dart';
import 'package:darzi/apiData/model/aws_response_model.dart';
import 'package:darzi/apiData/model/current_customer_response_model.dart';
import 'package:darzi/apiData/model/current_tailor_detail_response.dart';
import 'package:darzi/apiData/model/customer_add_to_favourite_response_model.dart';
import 'package:darzi/apiData/model/customer_delete_account_response_model.dart';
import 'package:darzi/apiData/model/customer_delete_response_model.dart';
import 'package:darzi/apiData/model/customer_favourite_response_model.dart';
import 'package:darzi/apiData/model/customer_otp_verification_model.dart';
import 'package:darzi/apiData/model/customer_payment_history_response_model.dart';
import 'package:darzi/apiData/model/customer_update_response_model.dart';
import 'package:darzi/apiData/model/get_all_tailors_model.dart';
import 'package:darzi/apiData/model/get_cancelled_order_response_model.dart';
import 'package:darzi/apiData/model/get_current_customer_list_details_model.dart';
import 'package:darzi/apiData/model/get_received_payment_list_response_model.dart';
import 'package:darzi/apiData/model/get_tailor_review_response_model.dart';
import 'package:darzi/apiData/model/login_model.dart';
import 'package:darzi/apiData/model/monthly_report_tailor_rsponse_model.dart';
import 'package:darzi/apiData/model/my_tailor_details_response_model.dart';
import 'package:darzi/apiData/model/notification_response_model.dart';
import 'package:darzi/apiData/model/order_status_change_model.dart';
import 'package:darzi/apiData/model/otp_verification_model.dart';
import 'package:darzi/apiData/model/outstanding_balance_response_model.dart';
import 'package:darzi/apiData/model/particular_customer_order_payment_history_response_model.dart';
import 'package:darzi/apiData/model/recieve_payment_response_model.dart';
import 'package:darzi/apiData/model/reopen_cancelled_order_response_model.dart';
import 'package:darzi/apiData/model/specific_customer_dress_detail_response_model.dart';
import 'package:darzi/apiData/model/specific_customer_dress_details_model.dart';
import 'package:darzi/apiData/model/specific_notification_response_model.dart';
import 'package:darzi/apiData/model/specific_notification_review_response_model.dart';
import 'package:darzi/apiData/model/specific_order_detail_response_model.dart';
import 'package:darzi/apiData/model/speicific_customer_mearsure_model.dart';
import 'package:darzi/apiData/model/tailor_List_Response_Model.dart';
import 'package:darzi/apiData/model/tailor_account_delete_response_model.dart';
import 'package:darzi/apiData/model/tailor_profile_update_response_model.dart';
import 'package:darzi/apiData/model/tailor_registration_response_model.dart';
import 'package:darzi/apiData/model/tailor_review_list_response_model.dart';
import 'package:darzi/apiData/model/tailor_review_response_model.dart';
import 'package:darzi/apiData/model/update_customer_measurement_details_model.dart';
import 'package:darzi/apiData/model/update_customer_profile.dart';
import 'package:darzi/apiData/model/verify_mobile_model.dart';
import 'package:darzi/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_connect/connect.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CallService extends GetConnect{

  // Tailor
  //1). For Getting Otp(For Tailor)
  Future<LoginResponseModel> userLogin(dynamic body) async {
    httpClient.baseUrl = apiBaseUrl;
      var res = await post('tailor/get-otp', body, headers: {
        'accept': 'application/json',
      });
      print("response is ${res.statusCode}");
      if (res.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        print("Login Response is : ${res.statusCode.toString()}");
        return LoginResponseModel.fromJson(res.body);
      } else {

        throw Fluttertoast.showToast(
            msg: res.body["message"],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
    }
  }

  //2). For Verifying Otp
  Future<OtpVerificationResponseModel> tailorOtpVerification(dynamic body) async {
    httpClient.baseUrl = apiBaseUrl;
    var res = await post('tailor/otp-verification', body, headers: {
      'accept': 'application/json',
    });
    if (res.statusCode == 200) {
      print("Login Response is : ${res.statusCode.toString()}");
      return OtpVerificationResponseModel.fromJson(res.body);
    }else{
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //3). For Registering New Tailor
  Future<Tailor_Registration_Response_Model> tailor_registration(dynamic body) async {
    httpClient.baseUrl = apiBaseUrl;
    var res = await post('tailor/register', body, headers: {
      'accept': 'application/json',
    });
    print("Registration Response is : ${res.statusCode.toString()}");
    if (res.statusCode == 200) {
      print("Registration Response is : ${res.statusCode.toString()}");
      return Tailor_Registration_Response_Model.fromJson(res.body);
    }else{
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //3). For Getting Current Tailor Details
  Future<Current_Tailor_Response> getCurrentTailorDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    var res = await get('tailor/getCurrentTailor', headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    if (res.statusCode == 200) {
      return Current_Tailor_Response.fromJson(res.body);
    } else {
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //3). For Getting Current Tailor Details
  Future<My_Tailor_Details_Respone_Model> getMyTailorDetails(String tailorId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    print("Tailor Id Value is : $tailorId");

    httpClient.baseUrl = apiBaseUrl;

    // Prepare headers conditionally
    Map<String, String> headers = {
      'accept': 'application/json',
    };

    if (accessToken != null) {
      headers['Authorization'] = "Bearer $accessToken";
    }

    var res = await get('tailor/getSpecificTailorDetails/$tailorId', headers: headers);
    print("Specific Tailor Details Response is ${res.statusCode}");

    if (res.statusCode == 200) {
      return My_Tailor_Details_Respone_Model.fromJson(res.body);
    } else {
      Fluttertoast.showToast(
        msg: res.body["message"] ?? "Something went wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      throw Exception(res.body["message"]);
    }
  }


  //4). For Getting Specific Customer's Measurement  Details
  Future<Specific_Cutomer_Measurement_Response_Model> getSpecificCustomerMeasurementDetails(String customerId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    print("User Access Token Value is : $customerId");
    httpClient.baseUrl = apiBaseUrl;

    var res = await get('customer/getSpecificCustomersDetails/$customerId', headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    print("Tailor Response is ${res.statusCode}");
    if (res.statusCode == 200) {
      return Specific_Cutomer_Measurement_Response_Model.fromJson(res.body);
    } else {
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //5). For Getting Specific Customer Dress Details
  Future<Specific_Customer_Dress_Details_Model> getSpecificCustomerDressDetails(String customerId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    print("User Access Token Value is : $customerId");
    httpClient.baseUrl = apiBaseUrl;

    var res = await get('customer/getSpecificCustomerOrders/$customerId', headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    print("Tailor Response is ${res.statusCode}");
    if (res.statusCode == 200) {
      return Specific_Customer_Dress_Details_Model.fromJson(res.body);
    } else {
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //6). For Updating Measurement Details
  Future<Update_Customer_Measurement_Details_Model> updateCustomerMeasurementDressDetails(dynamic body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    print("Map Value is $body");
    var res = await put('customer/updateCustomerMeasurements', body, headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    if (res.statusCode == 200) {
      print("Update Measurement Response is : ${res.statusCode.toString()}");
      return Update_Customer_Measurement_Details_Model.fromJson(res.body);
    }else{
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //7). For Verifying Measurement Details
  Future<Mobile_Verify_Model> verifyCustomerMobile(dynamic body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    print("Map Value is $body");
    var res = await post('customer/verifyCustomerMobileNo', body, headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    print("Response is ${res.statusCode.toString()}");
    if (res.statusCode == 200) {
      print("Update Measurement Response is : ${res.statusCode.toString()}");
      return Mobile_Verify_Model.fromJson(res.body);
    }else{
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //8). For Updating The Dress Status
  Future<Order_Status_Change_Model> updateDreesOrderStatus(dynamic body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    print("Map Value is $body");
    var res = await post('order/changeOrderStatus', body, headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    print("Map Value is ${res.body}");
    if (res.statusCode == 200) {
      print("Update Measurement Response is : ${res.statusCode.toString()}");
      return Order_Status_Change_Model.fromJson(res.body);
    }else{
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //9). For Getting The Specific Dress Details
  Future<Specific_Order_Detail_Response_Model> getSpecificDreesDetails(String dressId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    print("Map Value is $dressId");
    var res = await get('order/getSpecificOrderDetails/$dressId', headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    print("Map Value is ${res.body}");
    if (res.statusCode == 200) {
      print("Update Measurement Response is : ${res.statusCode.toString()}");
      return Specific_Order_Detail_Response_Model.fromJson(res.body);
    }else{
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //10). For Updating The Dress Status
  Future<CustomerDeleteResponseModel> removeCustomerFromList(dynamic body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    print("Map Value is $body");
    var res = await post('tailor/removeCustomerFromTailor', body, headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    print("Map Value is ${res.body}");
    print("Map Value is ${res.statusCode}");
    if (res.statusCode == 200) {
      print("Update Delete Customer Response is : ${res.statusCode.toString()}");
      return CustomerDeleteResponseModel.fromJson(res.body);
    }else{
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

//11). For Deleting Tailor Account
  Future<Tailor_Account_Delete_Response_Model> removeTailor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    var res = await delete('tailor/deleteTailor', headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    print("Map Value is ${res.statusCode}");
    if (res.statusCode == 200) {
      print("Delete Tailor Response is : ${res.statusCode.toString()}");
      return Tailor_Account_Delete_Response_Model.fromJson(res.body);
    }else{
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

//12). For Calling Aws in For Uploading Profile Picture User/Counsellor
  Future<AwsResponseModel> getAwsUrl(String fileType,folder_name) async {
    httpClient.baseUrl = apiBaseUrl;
    print("Story Response is ${fileType}");
    print("Story Response is ${folder_name}");
    var res = await get('aws/aws-s3-puturl?fileType=$fileType&folderName=$folder_name', headers: {
      'accept': 'application/json',
    });

    print("Story Response is ${res.statusCode}");
    if (res.statusCode == 200) {
      return AwsResponseModel.fromJson(res.body);
    } else {
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.newUpdateColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

//13). For Updating Tailor Profile(With Image/Without Image)
  Future<Tailor_Profile_Update_Response_Model> updateTailorProfile(dynamic body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    var res = await put('tailor/updateTailorDetails',body, headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });

    print("Story Response is ${res.statusCode}");
    if (res.statusCode == 200) {
      return Tailor_Profile_Update_Response_Model.fromJson(res.body);
    } else {
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.newUpdateColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

//14). For Adding New Customer
  Future<Add_New_Customer_Response_Model> addNewCustomer(dynamic body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    var res = await post('order/addCustomerOrder',body, headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });

    print("Story Response is ${res.statusCode}");
    if (res.statusCode == 200) {
      return Add_New_Customer_Response_Model.fromJson(res.body);
    } else {
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.newUpdateColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

//15). For Adding New Order For Specific Customer
  Future<Add_New_Customer_Order_Response_Model> addNewCustomerOrder(dynamic body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    var res = await post('order/addNewOrder',body, headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });

    print("Story Response is ${res.statusCode}");
    if (res.statusCode == 200) {
      return Add_New_Customer_Order_Response_Model.fromJson(res.body);
    } else {
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.newUpdateColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }


  //Customer
//1). For Getting Otp(For Customer)
  Future<LoginResponseModel> customerLogin(dynamic body) async {
    httpClient.baseUrl = apiBaseUrl;
    var res = await post('customer/login', body, headers: {
      'accept': 'application/json',
      /*'Authorization': "Bearer $accessToken",*/
    });
    if (res.statusCode == 200) {
      print("Login Response is : ${res.statusCode.toString()}");
      return LoginResponseModel.fromJson(res.body);
    }else{
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //2). For Verifying Otp
  Future<Customer_Otp_Verification_Model> customerOtpVerification(dynamic body) async {
    httpClient.baseUrl = apiBaseUrl;
    var res = await post('customer/otp-verification', body, headers: {
      'accept': 'application/json',
      /*'Authorization': "Bearer $accessToken",*/
    });
    if (res.statusCode == 200) {
      print("Login Response is : ${res.statusCode.toString()}");
      return Customer_Otp_Verification_Model.fromJson(res.body);
    }else{
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //3). For updating details in profile of customer
  Future<Update_Customer_Profile_response_Model> customerUpdateProfile(dynamic body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("Customer Access Token is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    print("base url is $apiBaseUrl");
    print("base url is $body");
    var res = await put('customer/updateCustomerDetails', body, headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    print("Otp Response is ${res.statusCode}");
    if (res.statusCode == 200) {
      print("Login Response is : ${res.statusCode.toString()}");
      return Update_Customer_Profile_response_Model.fromJson(res.body);
    }else{
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //4. For Getting Current Customer Details
  Future<Current_Customer_response_Model> getCurrentCustomerDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    var res = await get('customer/getCurrentCustomer', headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    if (res.statusCode == 200) {
      return Current_Customer_response_Model.fromJson(res.body);
    } else {
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //5. For Getting All tailors list
  Future<Get_All_Tailors_response_Model> getAllTailorsList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");

    httpClient.baseUrl = apiBaseUrl;

    // Conditionally add Authorization header
    final headers = {
      'accept': 'application/json',
      if (accessToken != null) 'Authorization': "Bearer $accessToken",
    };

    var res = await get('tailor/getAllTailors', headers: headers);

    if (res.statusCode == 200) {
      return Get_All_Tailors_response_Model.fromJson(res.body);
    } else {
      Fluttertoast.showToast(
        msg: res.body["message"] ?? "Something went wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      throw Exception(res.body["message"] ?? "API call failed");
    }
  }


  //6). For Getting My Tailor List And Order List
  Future<Get_Current_Customer_Response_Model> getMyTailorList_order() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    var res = await get('customer/getCurrentCustomer', headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    if (res.statusCode == 200) {
      return Get_Current_Customer_Response_Model.fromJson(res.body);
    } else {
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //7). For Getting My Tailor List And Order List
  Future<Customer_Favourites_Response_Model> getMyFavourite_TailorList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    var res = await get('customer/getCurrentCustomerFavourites', headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    if (res.statusCode == 200) {
      return Customer_Favourites_Response_Model.fromJson(res.body);
    } else {
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

//8). For Getting My Tailor Review List
  Future<Get_Customer_Tailor_Reviews_Response_Model> get_Tailor_Review_List(String tailorId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    print("Tailor Id Value is : $tailorId");

    httpClient.baseUrl = apiBaseUrl;

    // Prepare headers conditionally
    Map<String, String> headers = {
      'accept': 'application/json',
    };

    if (accessToken != null) {
      headers['Authorization'] = "Bearer $accessToken";
    }

    var res = await get('tailor/getTailorReviews?tailorId=$tailorId', headers: headers);

    print("Response is : ${res.statusCode}");

    if (res.statusCode == 200) {
      return Get_Customer_Tailor_Reviews_Response_Model.fromJson(res.body);
    } else {
      Fluttertoast.showToast(
        msg: res.body["message"] ?? "Something went wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      throw Exception(res.body["message"]);
    }
  }


  //9). For Getting My Tailor List And Order List
  Future<Tailor_List_Response_Model> getMyTailorList(int page,int pageLimit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    var res = await get('customer/getMyTailors?page=$page&limit=$pageLimit', headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    if (res.statusCode == 200) {
      return Tailor_List_Response_Model.fromJson(res.body);
    } else {
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //10). For Getting Specific Customer Dress Details
  Future<Specific_Customer_Dress_Detail_Response_Model> getCustomerSpecificDressDetail(String dressId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    var res = await get('order/getSpecificOrderDetails/$dressId', headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    if (res.statusCode == 200) {
      return Specific_Customer_Dress_Detail_Response_Model.fromJson(res.body);
    } else {
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //11). For Getting Specific Customer Notification Details
  Future<SpecificNotificationResponseModel> getCustomerSpecificNotificationDetail(String notificationId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    var res = await get('notification/notification/$notificationId', headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    if (res.statusCode == 200) {
      return SpecificNotificationResponseModel.fromJson(res.body);
    } else {
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //12). For Getting Specific Tailor Review Details
  Future<Specific_Notification_Review_Response_Model> getSpecificTailorReviewNotificationDetail(String notificationId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    var res = await get('notification/getTailorReviewsByNotificationId/$notificationId/reviews', headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    if (res.statusCode == 200) {
      return Specific_Notification_Review_Response_Model.fromJson(res.body);
    } else {
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //13). For Getting Specific Customer Payment
  Future<Receive_Payment_Response_Model> customerDressPayment(dynamic body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    var res = await post('order/receivePayment', body, headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    if (res.statusCode == 200) {
      print("Dress Payment Response is : ${res.statusCode.toString()}");
      return Receive_Payment_Response_Model.fromJson(res.body);
    }else{
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //13). For Adding Specific Tailor As A Favourite
  Future<Customer_Add_To_Favourite_Response_Model> add_Tailor_To_Favourites(dynamic body) async {
    httpClient.baseUrl = apiBaseUrl;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    print("Map Value is : $body");
    var res = await post('customer/toogleToFavourites', body, headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    print("Login Response is : ${res.statusCode.toString()}");
    if (res.statusCode == 200) {
      return Customer_Add_To_Favourite_Response_Model.fromJson(res.body);
    }else{
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //14). For Getting Tailor Review
  Future<Get_Tailor_Review_Response_Model> getCurrentTailorReviewDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    var res = await get('tailor/getTailorReviews', headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    print(" Tailor Review Response is ${res.statusCode}");
    if (res.statusCode == 200) {
      return Get_Tailor_Review_Response_Model.fromJson(res.body);
    } else {
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //15). For Getting Tailor Monthly Sales
  Future<Monthly_Sales_Tailor_Response_Model> getTailorMonthlySales(String month, String year) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    var res = await get('order/getMonthlyPerformance?month=$month&year=$year', headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    print("Tailor monthly salesResponse is ${res.statusCode}");
    if (res.statusCode == 200) {
      return Monthly_Sales_Tailor_Response_Model.fromJson(res.body);
    } else {
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //16). For Getting Outstanding Balance Of Tailor
  Future<Tailor_Outstanding_Balance_Response_Model> getTailorOutstandingBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    var res = await get('tailor/getUserOutstandingData', headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    print("Tailor Outstanding Balance Response is ${res.statusCode}");
    if (res.statusCode == 200) {
      return Tailor_Outstanding_Balance_Response_Model.fromJson(res.body);
    } else {
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }


  //17). For Getting Cancelled order
  Future<GetCancelled_Order_Response_Model> getCancelledOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    var res = await get('order/getCancelledOrder', headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    print(" Cancelled order Response is ${res.statusCode}");
    if (res.statusCode == 200) {
      return GetCancelled_Order_Response_Model.fromJson(res.body);
    } else {
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //18). For Getting PaymentDone order
  Future<GetPaymentDoneListResponseModel> getPaymentDoneOrder(String month, String year) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    var res = await get('tailor/getPaymentReceived?month=$month&year=$year', headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    print(" Received Payment order Response is ${res.statusCode}");
    if (res.statusCode == 200) {
      return GetPaymentDoneListResponseModel.fromJson(res.body);
    } else {
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //19). For Getting Notification
  Future<NotificationResponseModel> getNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    var res = await get('notification/getNotifications', headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    print("Notification Response is ${res.statusCode}");
    if (res.statusCode == 200) {
      return NotificationResponseModel.fromJson(res.body);
    } else {
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //20). For Reopening Cancelled Order
  Future<Re_Open_Cancelled_Order_Response_Model> reopenOrder(dynamic body) async {
    print("otp body value is $body");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("Access Token is $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    var res = await post('order/reopenOrder', body, headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    print("Reopen Order Response is ${res.statusCode}");
    if (res.statusCode == 200) {
      return Re_Open_Cancelled_Order_Response_Model.fromJson(res.body);
    } else {
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //21). For Getting Customer Payment History List
  Future<Customer_Payment_History_Response_Model> getPaymentHistory(String customerId,page,limit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    print("User Customer Id Value is : $customerId");
    httpClient.baseUrl = apiBaseUrl;
    var res = await get('order/history?customerId=$customerId&page=$page&limit=$limit', headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    print("Notification Response is ${res.statusCode}");
    if (res.statusCode == 200) {
      return Customer_Payment_History_Response_Model.fromJson(res.body);
    } else {
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //22). For Getting Customer Payment History List
  Future<Particular_Customer_Order_Payment_History_Response_Model> getParticularOrderPaymentHistory(String orderId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    print("User Customer Id Value is : $orderId");
    httpClient.baseUrl = apiBaseUrl;
    var res = await get('order/getReceivePayment?orderId=$orderId', headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    print("Notification Response is ${res.statusCode}");
    if (res.statusCode == 200) {
      return Particular_Customer_Order_Payment_History_Response_Model.fromJson(res.body);
    } else {
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //23). For Deleting Customer Account
  Future<Customer_Delete_Account_Response_Model> removeCustomer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    var res = await delete('customer/deleteCustomer', headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });
    print("Map Value is ${res.statusCode}");
    if (res.statusCode == 200) {
      print("Delete Tailor Response is : ${res.statusCode.toString()}");
      return Customer_Delete_Account_Response_Model.fromJson(res.body);
    }else{
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

//24). For Updating Customer Profile(With Image/Without Image)
  Future<Customer_Update_Response_Model> updateCustomerProfile(dynamic body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    var res = await put('customer/updateCustomerDetails',body, headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });

    print("Story Response is ${res.statusCode}");
    if (res.statusCode == 200) {
      return Customer_Update_Response_Model.fromJson(res.body);
    } else {
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.newUpdateColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }


//25).For Uploading Tailor Review By Customer(With Image/Without Image)
  Future<Tailor_Review_Response_Model> uploadTailorReviewByCustomer(dynamic body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('userToken');
    print("User Access Token Value is : $accessToken");
    httpClient.baseUrl = apiBaseUrl;
    var res = await post('tailor/addTailorReview',body, headers: {
      'accept': 'application/json',
      'Authorization': "Bearer $accessToken",
    });

    print("Story Response is ${res.statusCode}");
    if (res.statusCode == 201) {
      return Tailor_Review_Response_Model.fromJson(res.body);
    } else {
      throw Fluttertoast.showToast(
          msg: res.body["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.newUpdateColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
