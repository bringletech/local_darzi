import 'package:darzi/colors.dart';
import 'package:darzi/homePage.dart';
import 'package:darzi/pages/customer/screens/customer_dashboard/view/customer_dashboard_new.dart';
import 'package:darzi/pages/tailor/screens/tailor_dashboard/view/tailor_dashboard_new.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  final Function(Locale) onChangeLanguage;

  const SplashScreen({Key? key, required this.onChangeLanguage}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _animationController= AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );

  late final animation = Tween<Offset>(
    begin: Offset(0, 1),  // Start position (bottom of the screen)
    end: Offset(0, 0),    // End position (center of the screen)
  ).animate(CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeInOut,
  ));

  Animation<double>? _fadeAnimation;
  Animation<double>? _scaleAnimation;
  bool isAuth = false;
  Future<bool>?loginCheckFuture;
  String userType = "", token = "";
  Locale locale = const Locale('en'); // Default Locale

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController.forward();
    navigateUser();
    // Timer(Duration(seconds: 3), () {
    //   //It will redirect  after 3 seconds
    // });
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>  HomePage(onChangeLanguage: widget.onChangeLanguage),
      transitionDuration: Duration(seconds: 2),
      barrierColor: AppColors.darkRed,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0, 1);
        const end = Offset(0, 0);
        const curve = Curves.fastOutSlowIn;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  void navigateUser() async {
    final SharedPreferences localStorage = await SharedPreferences.getInstance();

    // Retrieve language code
    final String? languageCode = localStorage.getString('selectedLanguage');
    print("Save language is $languageCode");
    if (languageCode != null) {
      setState(() {
        locale = Locale(languageCode);
      });
    }

    token = localStorage.getString("userToken") ?? "";
    userType = localStorage.getString('userType') ?? "";

    print("UserType value is $token");
    print("UserType value is $userType");
    print("Language Code is $languageCode");

    Timer(Duration(seconds: 3), () {
      if (userType == "tailor") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TailorDashboardNew(locale: locale),
          ),
        );
      } else if (userType == "customer") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CustomerDashboardNew(locale: locale)),
        );
      } else {
        Navigator.of(context).pushReplacement(_createRoute());
      }
    });
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SlideTransition(
            position: animation,
            child: Image.asset('assets/images/darzi_logo.png')),
      ),
    );
  }
}