import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:pet_app/core/common/loader.dart';
import 'package:pet_app/features/auth/controller/auth_controller.dart';
import 'package:pet_app/features/calendar/screens/calendar_screen.dart';
import 'package:pet_app/features/home/screens/home_screen.dart';
import 'package:pet_app/models/user_model.dart';
import 'package:pet_app/router.dart';
import 'package:pet_app/features/maps/map_screen.dart';
import 'package:pet_app/screens/profile_screen.dart';
import 'package:routemaster/routemaster.dart';

import 'core/common/error_text.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(
    child: MyApp(),
  ));
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;
  void getData(WidgetRef ref, User data) async {
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUserdata(data.uid)
        .first;
    ref.read(userProvider.notifier).update((state) => userModel);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangeProvider).when(
        data: (data) => MaterialApp.router(
              title: 'Petter',
              theme: ThemeData(
                scaffoldBackgroundColor: Colors.white,
                primarySwatch: Colors.deepOrange,
              ),
              routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
                if (data != null) {
                  getData(ref, data);
                  if (userModel != null) {
                    return loggedInRoute;
                  }
                }

                return loggedOutRoute;
              }),
              routeInformationParser: const RoutemasterParser(),
            ),
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader());
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
    // if (FirebaseAuth.instance.currentUser != null) {
    return Scaffold(
        body: PersistentTabView(
      context,
      controller: _controller,
      screens: screens(),
      items: navBarItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style6,
    ));
    // } else {
    //   return Scaffold(body: LoginPageScreen());
    // }
  }
}

List<Widget> screens() {
  return [
    const HomeScreen(),
    const CalendarScreen(),
    const MapScreen(),
    const ProfileScreen(),
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
        title: "Nearby",
        activeColorPrimary: Colors.deepOrange,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        inactiveColorSecondary: CupertinoColors.systemGrey),
    PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.profile_circled),
        title: "Profile",
        activeColorPrimary: Colors.deepOrange,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        inactiveColorSecondary: CupertinoColors.systemGrey)
  ];
}
