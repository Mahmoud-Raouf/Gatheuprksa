import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gatheuprksa/pages/Dashboard/home.dart';
import 'package:gatheuprksa/pages/Login/login_controller.dart';
import 'package:gatheuprksa/theme/app_theme.dart';
import 'package:gatheuprksa/util/_string.dart';
import 'package:gatheuprksa/util/constants.dart';
import 'package:gatheuprksa/widgets/Custombutton.dart';
import 'package:gatheuprksa/widgets/app_logo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gatheuprksa/pages/signup/signup.dart';

class RegistrationType extends StatefulWidget {
  const RegistrationType({super.key});

  @override
  State<RegistrationType> createState() => _RegistrationTypeState();
}

class _RegistrationTypeState extends State<RegistrationType> {
  double? height;
  double? width;


  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    // استخدام GetBuilder لإدارة حالة الواجهة
    return Scaffold(
            body: GestureDetector(
              onTap: () {
                // إخفاء لوحة المفاتيح عند النقر في أي مكان خارج حقول الإدخال
                FocusScope.of(context).unfocus();
              },
              child: Container(
                color: AppTheme.loginPageColor,
                height: height,
                width: width,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // شعار التطبيق
                      AppLogo(),

                      // زر تسجيل الدخول
                      CustomButton(
                        backgroundColor: AppTheme.customButtonBgColor,
                        borderColor: AppTheme.customButtonBgColor,
                        buttonTitle: "التسجيل كشركة",
                        height: Constant.customButtonHeight,
                        onTap: () {
                            Get.to(SignUp(userRole: 'company'));
                        },
                        textColor: AppTheme.colorWhite,
                      ),
                      CustomButton(
                        backgroundColor: AppTheme.customButtonBgColor,
                        borderColor: AppTheme.customButtonBgColor,
                        buttonTitle: "التسجيل كزائر",
                        height: Constant.customButtonHeight,
                        onTap: () {
                            Get.to(SignUp(userRole: 'user'));

                        },
                        textColor: AppTheme.colorWhite,
                      ),

                     
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  // دالة تُنشئ خط فاصل بين العناصر
  Widget devider() {
    return Container(
      height: Constant.dividerSize,
      width: width! / Constant.size5,
      color: AppTheme.colorblack12,
    );
  }
}
