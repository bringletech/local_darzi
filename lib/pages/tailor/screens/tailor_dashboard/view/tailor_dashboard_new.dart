import 'package:darzi/common/common_bottom_navigation.dart';
import 'package:darzi/common/widgets/tab_data.dart';
import 'package:darzi/pages/tailor/screens/tailor_dashboard/view/darzi_home_screen.dart';
import 'package:darzi/pages/tailor/screens/tailor_profile/view/profile_page.dart';
import 'package:darzi/pages/tailor/screens/tailor_search/view/search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// Import the new routes file
import '../../../../../colors.dart';

class TailorDashboardNew extends StatefulWidget {
  static const TextStyle titleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 22,
    color: Colors.black,
  );

  final PageController tabController = PageController(initialPage: 1);

  var selectedIndex = 1;
  final Locale locale;

  TailorDashboardNew({super.key, required this.locale,});

  @override
  State<TailorDashboardNew> createState() => _TailorDashboardState();
}

class _TailorDashboardState extends State<TailorDashboardNew> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(24),
          topLeft: Radius.circular(24),
        ),
        child: CircleBottomNavigation(
          barHeight: 80,
          circleSize: 65,
          initialSelection: widget.selectedIndex,
          activeIconColor: AppColors.newUpdateColor,
          inactiveIconColor: Colors.white,
          barBackgroundColor: AppColors.newUpdateColor,
          textColor: AppColors.newUpdateColor,
          hasElevationShadows: false,
          tabs: [
            TabData(
              onClick: () {
              },
              icon: Icons.search,
              iconSize: 35,
              title: '',
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
            TabData(
              onClick: () {
              },
              icon: Icons.grid_view,
              iconSize: 35,
              title: '',
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
            TabData(
              onClick: () {

              },
              icon: Icons.person,
              iconSize: 35,
              title: '',
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),

          ],
          onTabChangedListener: (index) {
            setState(() {
              widget.selectedIndex = index;
              widget.tabController.jumpToPage(index);

              print("index..............    $index");
            });
          },
        ),
      ),
      body: PageView(
        controller: widget.tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          Center(
            child: SearchPage(locale: widget.locale),
          ),
          Center(
            child: DarziHomeScreen(locale: widget.locale),
          ),
          Center(
            child: TailorProfilePage(locale: widget.locale),
          ),
        ],
      ),
    );
  }
}
