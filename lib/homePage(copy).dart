import 'package:darzi/constants/string_constant.dart';
import 'package:darzi/l10n/app_localizations.dart';
import 'package:darzi/pages/tailor/screens/tailorLogin/view/tailorRegisterPage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'colors.dart';
import 'pages/customer/screens/customer_Login/view/customerRegisterPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
class HomePage extends StatefulWidget {
  final Function(Locale) onChangeLanguage;

  const HomePage({Key? key, required this.onChangeLanguage}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isPressedTailor = false;
  bool _isPressedCustomer = false;
  Locale? _currentLocale;

  //Locale? _currentLocale = const Locale('en'); // Default to English

  String tailorLabel = StringConstant.tailor; // Default Tailor label
  String customerLabel = StringConstant.customer; // Default Customer label
  String selectLanguage = StringConstant.selectLanguage;

  // Function to save the selected language to SharedPreferences
  Future<void> _saveLanguage(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', locale.languageCode);
    print("Language saved: ${locale.languageCode}");
  }

// Function to load the saved language from SharedPreferences
  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('selectedLanguage');
    if (languageCode != null) {
      setState(() {
        _currentLocale = Locale(languageCode); // Load saved language
        _updateLabels(_currentLocale!); // Update UI labels
      });
      widget.onChangeLanguage(_currentLocale!); // Update app language
    }
  }

  // Call this in initState
  @override
  void initState() {
    super.initState();
    _loadSavedLanguage(); // Load saved language on app start
    _initDeviceToken();   // Save device token after logout
  }

  Future<void> _initDeviceToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    try {
      String? token = await messaging.getToken();
      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('deviceToken', token);
        print("Device Token saved: $token");
      } else {
        print("Failed to generate device token.");
      }
    } catch (e) {
      print("Error getting device token: $e");
    }
  }


  void _updateLabels(Locale locale) {
    setState(() {
      // Update labels based on the selected locale
      if (locale.languageCode == 'en') {
        tailorLabel = "Tailor";
        customerLabel = "Customer";
        selectLanguage = "Select Your Language";
      } else if (locale.languageCode == 'hi') {
        tailorLabel = "दर्जी";
        customerLabel = "ग्राहक";
        selectLanguage = "अपनी भाषा चुनें।";
      } else if (locale.languageCode == 'pa') {
        tailorLabel = "ਦਰਜੀ";
        customerLabel = "ਗਾਹਕ";
        selectLanguage = "ਆਪਣੀ ਭਾਸ਼ਾ ਚੁਣੋ।";
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(180),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 8,
          shadowColor: Colors.black.withOpacity(1.0),
          flexibleSpace: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Image.asset(
                //'assets/images/darzi_logo.png',
                'assets/images/darzi_Final_logo.png',
                width: 250,
                height: 250,
              ),
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Tailor Button
            GestureDetector(
              onTapDown: (_) {
                setState(() {
                  _isPressedTailor = true;
                });
              },
              onTapUp: (_) async {
                setState(() {
                  _isPressedTailor = false;
                });
                if (_currentLocale == null) {
                  //Show a warning message if no language is selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(context)!.language_selection_first,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      backgroundColor: AppColors.newUpdateColor,
                    ),
                  );
                } else if (_currentLocale == Locale('selectLanguage')) {
                  // Show a warning message if "Select Language" is still selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(context)!.language_selection_first,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      backgroundColor: AppColors.newUpdateColor,
                    ),
                  );
                } else {
                  // Proceed to the Tailor page
                  await _saveLanguage(_currentLocale!);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TailorPage(locale: _currentLocale!),
                    ),
                  );
                }
              },
              onTapCancel: () {
                setState(() {
                  _isPressedTailor = false;
                });
              },
              child: Container(
                width: 300,
                height: 50,
                decoration: BoxDecoration(
                  //color: _isPressedTailor?AppColors.newUpdateColor:Colors.white,
                  color: AppColors.newUpdateColor,
                  // gradient: LinearGradient(
                  //   colors: _isPressedTailor
                  //       ? AppColors.Gradient1
                  //       : [Colors.white, Colors.white],
                  // ),
                  borderRadius: BorderRadius.circular(8),
                  //border: Border.all(color: AppColors.newUpdateColor, width: 2),
                ),
                child: Center(
                  child: Text(
                    tailorLabel,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      //color: _isPressedTailor ? Colors.white : AppColors.newUpdateColor,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 19,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
            GestureDetector(
              onTapDown: (_) {
                setState(() {
                  _isPressedCustomer = true;
                });
              },
              onTapUp: (_) async {
                setState(() {
                  _isPressedCustomer = false;
                });
                if (_currentLocale == null) {
                  // Show a warning message if no language is selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(context)!.language_selection_first,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      backgroundColor: AppColors.newUpdateColor,
                    ),
                  );
                } else if (_currentLocale == Locale('selectLanguage')) {
                  // Show a warning message if "Select Language" is still selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(context)!.language_selection_first,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      backgroundColor: AppColors.newUpdateColor,
                    ),
                  );
                } else {
                  // Proceed to the Customer page
                  await _saveLanguage(_currentLocale!);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomerregisterpagePage(locale: _currentLocale!),
                    ),
                  );
                }
              },

              onTapCancel: () {
                setState(() {
                  _isPressedCustomer = false;
                });
              },
              child: Container(
                width: 300,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.newUpdateColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    customerLabel,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 19,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
            //Language Dropdown
            Container(
              height: 50,
              width: 300,
              child: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: AppColors.newUpdateColor, // Changes the dropdown menu background
                ),
                child: DropdownButtonFormField<Locale>(
                  value: _currentLocale,
                  onChanged: (Locale? newLocale) async {
                    if (newLocale == null) {
                      // If user selects "Select Your Language", clear SharedPreferences and show a warning
                      setState(() {
                        _currentLocale = null; // Reset the current locale
                        tailorLabel = "Tailor";
                        customerLabel = "Customer";
                        selectLanguage = "Select Your Language"; // Reset UI labels
                      });

                      // Clear saved language from SharedPreferences
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('selectedLanguage');

                      // Show a warning message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.language_selection_first,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          backgroundColor: AppColors.newUpdateColor,
                        ),
                      );
                    } else {
                      // If a valid language is selected
                      setState(() {
                        _currentLocale = newLocale; // Update the current locale
                      });

                      // Update app language and labels
                      widget.onChangeLanguage(newLocale);
                      _updateLabels(newLocale);

                      // Save the selected language to SharedPreferences
                      await _saveLanguage(newLocale);
                    }
                  },
                  // onChanged: (Locale? newLocale) {
                  //   if (newLocale != null) {
                  //     setState(() {
                  //       _currentLocale = newLocale; // Update the current locale
                  //     });
                  //     widget.onChangeLanguage(newLocale); // Update app language
                  //     _updateLabels(newLocale); // Update button labels
                  //     _saveLanguage(newLocale); // Save selected language
                  //   }
                  // },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.newUpdateColor,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.newUpdateColor, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.newUpdateColor, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: null, // Placeholder value is treated as null
                      child: Text(
                        selectLanguage,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          //color: AppColors.newUpdateColor,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 19,
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: Locale('en'),
                      child: Text("English",  style: TextStyle( fontFamily: 'Poppins',
                        //color: AppColors.newUpdateColor, // Change text color based on state
                        color: Colors.white, // Change text color based on state
                        fontWeight: FontWeight.w600,
                        fontSize: 19,) ),
                    ),
                    DropdownMenuItem(
                      value: Locale('hi'),
                      child: Text("हिन्दी (Hindi)",  style: TextStyle( fontFamily: 'Poppins',
                        //color: AppColors.newUpdateColor, // Change text color based on state
                        color: Colors.white, // Change text color based on state
                        fontWeight: FontWeight.w600,
                        fontSize: 19,) ),
                    ),
                    DropdownMenuItem(
                      value: Locale('pa'),
                      child: Text("ਪੰਜਾਬੀ (Punjabi)",  style: TextStyle( fontFamily: 'Poppins',
                        //color: AppColors.newUpdateColor, // Change text color based on state
                        color: Colors.white, // Change text color based on state
                        fontWeight: FontWeight.w600,
                        fontSize: 19,) ),
                    ),
                  ],
                  icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                  isExpanded: true,
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}

