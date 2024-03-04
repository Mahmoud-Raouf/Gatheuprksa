// تجاهل التحذير "must_be_immutable" لأننا لا نقوم بتغيير حالة العنصر الرسومي لاحقًا.
// يستخدم هذا عنوان البريد الإلكتروني لتصفية التحذيرات ذات الصلة.

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gatheuprksa/theme/app_theme.dart';
import 'package:gatheuprksa/util/_string.dart';
import 'package:gatheuprksa/util/constants.dart';
import 'package:gatheuprksa/util/resources.dart';
import 'package:gatheuprksa/widgets/custom_text.dart';

// تعريف عنصر شريط التطبيق المخصص
class CustomAppBar extends StatefulWidget {
  String title; // عنوان شريط التطبيق
  double space; // المسافة بين الرمز والنص في شريط التطبيق
  void Function()? onTap; // دالة التفاعل عند النقر على شريط التطبيق
  double leftPadding; // التبديل الأيسر لحاشية شريط التطبيق
  double rightPadding; // التبديل الأيمن لحاشية شريط التطبيق
  double topPadding; // التبديل العلوي لحاشية شريط التطبيق
  double bottomPadding; // التبديل السفلي لحاشية شريط التطبيق

  CustomAppBar(
      {super.key,
      required this.title,
      required this.space,
      this.onTap,
      this.leftPadding = Constant.zero,
      this.bottomPadding = Constant.zero,
      this.rightPadding = Constant.zero,
      this.topPadding = Constant.zero});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    // بناء شريط التطبيق المخصص باستخدام Padding و InkWell و Row
    return Padding(
      padding: EdgeInsets.only(
          left: widget.leftPadding, right: widget.rightPadding, top: widget.topPadding, bottom: widget.bottomPadding),
      child: InkWell(
        splashColor: AppTheme.colorTransprant,
        highlightColor: AppTheme.colorTransprant,
        onTap: widget.onTap, // تعيين الدالة عند النقر
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // استخدام SvgPicture.asset لعرض الرمز
              RotationTransition(
                turns: const AlwaysStoppedAnimation(
                    180 / 360), // Specify the fraction of a complete rotation (60 degrees out of 360 degrees)
                child: SvgPicture.asset(
                  vector,
                  width: Constant.vectorHeight,
                  height: Constant.vectorWidth,
                  color: AppTheme.colorblack,
                ),
              ),

              // مسافة بين الرمز والنص
              SizedBox(
                width: widget.space,
              ),
              // استخدام CustomText لعرض النص
              CustomText(
                title: widget.title,
                fontWight: FontWeight.bold,
                fontfamily: Strings.emptyString,
                fontSize: Constant.appbarTitleSize,
              )
            ],
          ),
        ),
      ),
    );
  }
}
