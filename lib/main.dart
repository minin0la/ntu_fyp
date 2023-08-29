import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:pet_app/screens/calendar_screen.dart';
import 'package:pet_app/screens/editpet_screen.dart';
import 'package:pet_app/screens/login_screen.dart';
import 'package:pet_app/screens/main_screen.dart';
import 'package:pet_app/screens/map_screen.dart';
import 'package:pet_app/screens/profile_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Petter',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.deepOrange,
        // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepOrange),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  // final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // late PersistentTabController _controller;

  final _controller = PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      return Scaffold(
          body: PersistentTabView(
        context,
        controller: _controller,
        screens: screens(),
        items: navBarItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset:
            true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows:
            true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
            NavBarStyle.style6, // Choose the nav bar style with this property.
      ));
    } else {
      return Scaffold(body: LoginPageScreen());
    }
  }
}

List<Widget> screens() {
  return [
    MainScreen(email: "TEST"),
    const CalendarScreen(),
    const MapScreen(),
    const ProfileScreen(),
    const EditPetScreen(),
  ];
}

List<PersistentBottomNavBarItem> navBarItems() {
  return [
    PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.home),
        title: "Home",
        activeColorPrimary: Colors.deepOrange,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        inactiveColorSecondary: CupertinoColors.systemGrey),
    PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.calendar),
        title: "Calendar",
        activeColorPrimary: Colors.deepOrange,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        inactiveColorSecondary: CupertinoColors.systemGrey),
    PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.map),
        title: "Map",
        activeColorPrimary: Colors.deepOrange,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        inactiveColorSecondary: CupertinoColors.systemGrey),
    PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.profile_circled),
        title: "Profile",
        activeColorPrimary: Colors.deepOrange,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        inactiveColorSecondary: CupertinoColors.systemGrey),
    PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.gear),
        title: "Test",
        activeColorPrimary: Colors.deepOrange,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        inactiveColorSecondary: CupertinoColors.systemGrey)
  ];
}
