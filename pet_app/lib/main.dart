import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Petter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      return Scaffold(
          appBar: AppBar(
            title: Text("Petter"),
          ),
          body: PersistentTabView(
            context,
            screens: screens(),
            items: navBarItems(),
          ));
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text("Petter"),
          ),
          body: LoginPage());
    }
  }
}

List<Widget> screens() {
  return [MainPage(email: "TEST"), MapSample(), ProfilePage()];
}

List<PersistentBottomNavBarItem> navBarItems() {
  return [
    PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.home),
        title: "Home",
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorSecondary: CupertinoColors.systemGrey),
    PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.map),
        title: "Map",
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorSecondary: CupertinoColors.systemGrey),
    PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.profile_circled),
        title: "Profile",
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorSecondary: CupertinoColors.systemGrey)
  ];
}
