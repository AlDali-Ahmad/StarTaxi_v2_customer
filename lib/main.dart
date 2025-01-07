import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tawsella_final/NotificationController.dart';
import 'package:tawsella_final/Pages/splash_screen.dart';
import 'package:tawsella_final/local/local_Controller.dart';
import 'package:tawsella_final/local/translations.dart';
import 'package:tawsella_final/utils/app_colors.dart';

SharedPreferences? sharepref;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharepref = await SharedPreferences.getInstance();
  Get.put(NotificationController());
  runApp(
    ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) => const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    setState(() {
      isLoggedIn = token != null && token.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    MyLocalController controller = Get.put(MyLocalController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: /*isLoggedIn ? const Bottombar() : const*/ const SplashScreen(),
      //home: const WelcomePage(),
      // locale: const Locale('en', ''),
      // locale: controller.initialLang,
      locale: const Locale('ar', 'SA'),
      fallbackLocale: const Locale('ar', 'SA'),
      translations: MyTranslations(),
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: AppColors.BackgroundColor,
        fontFamily: 'Cairo',
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedLabelStyle: TextStyle(color: Colors.white),
          unselectedLabelStyle: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
