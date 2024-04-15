import 'package:flutter/material.dart';
import 'package:medireminder/Views/HomePage/home_page.dart';
import 'package:medireminder/Views/Settings/settings.dart';
import 'package:medireminder/Views/Add%20Medication/text_extraction.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class NavTab extends StatefulWidget {
  const NavTab({super.key});

  @override
  State<StatefulWidget> createState() => NavTabState();
}

PersistentTabController _controller = PersistentTabController(initialIndex: 0);

List<Widget> _screens() {
  return [HomePage(), TextExtraction(), Settings()];
}

List<PersistentBottomNavBarItem> _tabItems() {
  return [
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.home_rounded, size: 30),
      title: (""),
      activeColorPrimary: Colors.blue,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.add_rounded, size: 30),
      title: (""),
      activeColorPrimary: Colors.green,
      inactiveColorPrimary: Colors.grey,
      routeAndNavigatorSettings: RouteAndNavigatorSettings(
        initialRoute: '/cart',
        routes: {
          '/': (context) => TextExtraction(),
//            '/second': (context) => MainScreen3(),
        },
      ),
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.settings_rounded, size: 30),
      title: (""),
      activeColorPrimary: Colors.purple,
      inactiveColorPrimary: Colors.grey,
    )
  ];
}

class NavTabState extends State<NavTab> {
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      screens: _screens(),
      items: _tabItems(),
      resizeToAvoidBottomInset: true,
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      navBarStyle: NavBarStyle.style13,
    );
  }
}
