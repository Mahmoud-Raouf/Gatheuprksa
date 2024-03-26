import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as se;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:gatheuprksa/routes/app_pages.dart';
import 'package:gatheuprksa/routes/app_routes.dart';
import 'package:gatheuprksa/theme/app_theme.dart';
import 'package:gatheuprksa/util/_string.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  se.SystemChrome.setPreferredOrientations([se.DeviceOrientation.portraitDown, se.DeviceOrientation.portraitUp]);
  await GetStorage.init();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, dtype) {
      return GetMaterialApp(
        textDirection: TextDirection.rtl,

        // تعريف سمة التصميم الرئيسية للتطبيق
        theme: ThemeData(
          primaryColor: AppTheme.primaryColor,
          fontFamily: AppTheme.appFontName,
          textTheme: AppTheme.textTheme,
          appBarTheme: const AppBarTheme(
            // تعريف نمط تراكب النظام لشريط الحالة
            systemOverlayStyle: se.SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
          ),
          textSelectionTheme: const TextSelectionThemeData(
            // تحديد ألوان تحديد النص
            cursorColor: Color.fromARGB(162, 8, 105, 138),
            selectionColor: AppTheme.colorPrimaryTheme,
            selectionHandleColor: AppTheme.colorPrimaryTheme,
          ),
        ),
        defaultTransition: Transition.size,
        title: Strings.appName,
        initialRoute: AppRoute.Auth,
        getPages: AppPages.list,
        debugShowCheckedModeBanner: false,
      );
    });
  }
}
