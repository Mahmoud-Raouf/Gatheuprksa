import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gatheuprksa/routes/app_routes.dart';
import 'package:gatheuprksa/theme/app_theme.dart';
import 'package:gatheuprksa/util/_string.dart';
import 'package:gatheuprksa/util/constants.dart';
import 'package:gatheuprksa/util/resources.dart';
import 'package:gatheuprksa/widgets/Custombutton.dart';
import 'package:gatheuprksa/widgets/custom_text.dart';
import 'package:gatheuprksa/widgets/glashMorphisam.dart';
import 'package:gatheuprksa/widgets/no_appbar.dart';

class EventDetail extends StatefulWidget {
  const EventDetail({super.key});

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  double height = Constant.zero;
  double width = Constant.zero;
  final TextEditingController _commentController = TextEditingController();

  List<String> comments = []; // قائمة التعليقات
  @override
  Widget build(BuildContext context) {
    // استخدام MediaQuery للحصول على أبعاد الشاشة
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    // Scaffold: الهيكل الرئيسي للصفحة
    return Scaffold(
        appBar: NoAppBar(
          colors: AppTheme.colorblack,
        ),
        body: _body());
  }

  // الجزء الرئيسي لتصميم الصفحة
  _body() {
    return SizedBox(
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // الجزء العلوي من الصفحة يحتوي على الصور والرموز
              Container(
                height: height / Constant.detailPageHeight,
                width: width,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(Constant.detailViewImageBorder),
                        bottomRight: Radius.circular(Constant.detailViewImageBorder)),
                    image: DecorationImage(image: AssetImage(detailImage), fit: BoxFit.cover)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // رموز في أعلى الصفحة (رمز الرجوع ورمز الحفظ)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: Constant.topIconPadding, right: Constant.topIconPadding, top: Constant.topIconPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // زر الرجوع
                          Stack(
                            children: [
                              BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: Constant.imageBlurness, sigmaY: Constant.imageBlurness),
                              ),
                              InkWell(
                                onTap: () {
                                  // إرجاع المستخدم إلى الصفحة الرئيسية
                                  Get.toNamed(AppRoute.HOME);
                                },
                                child: // إنشاء حاوية تحتوي على زر الرجوع
                                    Container(
                                  // تحديد الحشو للحاوية
                                  padding: const EdgeInsets.all(Constant.backIconPadding),
                                  // تحديد ارتفاع الحاوية
                                  height: Constant.topIconContainerRadius,
                                  // تحديد عرض الحاوية
                                  width: Constant.topIconContainerRadius,
                                  // تزيين الحاوية باستخدام الخصائص المعينة مسبقًا
                                  decoration: Constant.deatailBoxDecoration,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          // تحديد الحشو للرمز داخل الحاوية
                                          left: Constant.backIconLeftBottomTopPadding,
                                          right: Constant.backIconRightPadding,
                                          bottom: Constant.backIconLeftBottomTopPadding,
                                          top: Constant.backIconLeftBottomTopPadding),
                                      // إضافة الرمز مع تحديد اللون
                                      child: SvgPicture.asset(
                                        vector,
                                        color: AppTheme.colorWhite,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // رمز الحفظ
                          // بناء صف من الأيقونات المُراد عرضها في الجزء العلوي من الصفحة
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // عمود يحتوي على صورة (أيقونة الحب)
                              Column(
                                children: [
                                  // حاوية لعرض الصورة
                                  Container(
                                    height: Constant.topIconContainerRadius,
                                    width: Constant.topIconContainerRadius,
                                    // تزيين الحاوية بالشكل المحدد
                                    decoration: Constant.deatailBoxDecoration,
                                    // الهامش الداخلي للحاوية
                                    padding: const EdgeInsets.all(Constant.loveIconPadding),
                                    child: Center(
                                      // عرض الصورة (أيقونة الحب) باستخدام SvgPicture
                                      child: SvgPicture.asset(
                                        love,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    // عرض الصور في الجزء السفلي
                    Padding(
                        padding: const EdgeInsets.only(
                            left: Constant.blureBoxLeftPadding,
                            right: Constant.blureBoxRightPadding,
                            bottom: Constant.blureBoxBottomPadding),
                        child: GlassmorPhism(
                          blure: Constant.blureBoxBlureness,
                          opacity: Constant.blureBoxopacity,
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: Constant.blureBoxContentPadding, right: Constant.blureBoxContentPadding),
                            height: height * Constant.blureBoxHeight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                images(image: detailImage1),
                                images(image: detailImage2),
                                images(image: detailImage3),
                                image4(image: image2)
                              ],
                            ),
                          ),
                        ))
                  ],
                ),
              ),
              // الجزء الأساسي لتفاصيل الحدث
              Column(
                children: [
                  // عنوان ومعلومات عن الحدث
                  Padding(
                    padding: const EdgeInsets.only(
                        left: Constant.detailFirstLeftPadding,
                        right: Constant.detailFirstRightPadding,
                        top: Constant.detailFirstTopPadding,
                        bottom: Constant.detailFirstBottomPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // معلومات عن الحدث (العنوان والموقع)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              title: Strings.communityMeet,
                              fontSize: Constant.detailFirstHeadingSize,
                              fontWight: FontWeight.w900,
                            ),
                            CustomText(
                              topPadding: Constant.detailSecondHeadingTopPadding,
                              title: Strings.paris,
                              fontSize: Constant.detailSecondHeadingSize,
                              fontWight: FontWeight.bold,
                              color: AppTheme.greyColor,
                            ),
                          ],
                        ),
                        // معلومات أخرى (التكلفة وعدد الأشخاص)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CustomText(
                              title: Strings.dollar20,
                              fontSize: Constant.detailFirstHeadingSize,
                              fontWight: FontWeight.w800,
                            ),
                            CustomText(
                              topPadding: Constant.detailSecondHeadingTopPadding,
                              title: Strings.person,
                              fontSize: Constant.detailSecondHeadingSize,
                              fontWight: FontWeight.bold,
                              color: AppTheme.greyColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // معلومات عن الموقع والوقت
                  Padding(
                    padding: const EdgeInsets.only(left: Constant.detailMapLeftPadding),
                    child: Column(
                      children: [
                        detailMap(title: Strings.redstoneStreet, wordSpacing: Constant.detailMapTitleWordSpacing),
                        detailMap(title: Strings.pM9_30, wordSpacing: Constant.detailMapTimeTitleWordSpacing)
                      ],
                    ),
                  ),
                  // زر الحجز وعرض الخريطة
                  Padding(
                    padding: const EdgeInsets.only(
                        left: Constant.detailMapImagePadding, right: Constant.detailMapImagePadding),
                    child: InkWell(
                      onTap: () {
                        // الانتقال إلى صفحة الدفع
                        Get.toNamed(AppRoute.PAYMENT);
                      },
                      child: Container(
                        height: height * Constant.detailMapImageHeight,
                        padding: EdgeInsets.zero,
                        // صورة خلفية للزر
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Constant.detailMapImageRadius),
                            image: const DecorationImage(image: AssetImage(searchMap), fit: BoxFit.cover)),
                        child: Center(
                          child: SizedBox(
                            height: height * Constant.bookButtonHeight,
                            child: CustomButton(
                                leftPadding: Constant.zero,
                                rightPadding: Constant.zero,
                                topPadding: Constant.bookButtonTopPadding,
                                backgroundColor: AppTheme.themeColor,
                                borderColor: AppTheme.themeColor,
                                buttonTitle: Strings.book,
                                height: height,
                                textColor: AppTheme.colorWhite),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                          itemCount: comments.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(comments[index]),
                              // يمكنك إضافة مزيد من التخصيصات لكل عنصر في القائمة هنا
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(9.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                controller: _commentController,
                                decoration: const InputDecoration(
                                  hintText: 'اكتب تعليقك...',
                                  border: OutlineInputBorder(),
                                ),
                                maxLines: null,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            ElevatedButton(
                              onPressed: _commentController.text.isEmpty
                                  ? null
                                  : () {
                                      // إضافة التعليق إلى قائمة التعليقات
                                      setState(() {
                                        comments.add(_commentController.text);
                                        _commentController.clear();
                                      });
                                    },
                              child: const Text('إرسال'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ));
  }

  // عنصر لعرض التفاصيل على الخريطة
  detailMap({required String title, required double wordSpacing}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Constant.detailMapRowBottomPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // صورة دائرية تحتوي على رمز الخريطة
          Container(
            decoration: BoxDecoration(
                color: AppTheme.detailMapBoxColor.withOpacity(Constant.customOpacity),
                borderRadius: BorderRadius.circular(Constant.detailMapCircleRadius)),
            padding: const EdgeInsets.only(
                right: Constant.detailMapCircleContentPadding,
                left: Constant.detailMapCircleContentPadding,
                top: Constant.detailMapCircleContentPadding,
                bottom: Constant.detailMapCircleContentTopPadding),
            child: SvgPicture.asset(
              map,
              height: Constant.detailMapCircleSize,
              width: Constant.detailMapCircleSize,
              color: AppTheme.detailMapBoxIconColor,
            ),
          ),
          // عنوان المكان على الخريطة
          CustomText(
            leftPadding: Constant.detailMapTitleLeftPadding,
            bottomPadding: Constant.detailMapTitleBottomPadding,
            title: title,
            fontSize: Constant.detailMapTitleSize,
            fontfamily: Strings.emptyString,
            wordSpacing: wordSpacing,
            fontWight: FontWeight.w500,
          )
        ],
      ),
    );
  }

  // عرض صورة مع تأثير زجاجي
  image4({required String image}) {
    return Container(
      // إنشاء حاوية بارتفاع وعرض ثابتة
      height: Constant.blureMapBoxSize,
      width: Constant.blureMapBoxSize,
      // تزيين الحاوية باللون والشكل المعين
      decoration: BoxDecoration(
          color: AppTheme.colorTransprant,
          borderRadius: BorderRadius.circular(Constant.blureMapBoxRadius),
          image: DecorationImage(image: AssetImage(image))),
      child: GlassmorPhism(
        // إضافة تأثير الزجاج المعتم
        blure: Constant.blureMapBoxBlureness,
        opacity: Constant.blureMapBoxOpacity,
        radius: Constant.blureMapBoxRadius,
        child: Center(
          child: CustomText(
            // عرض نص مخصص
            title: '+ 5 ',
            // تحديد حجم النص
            fontSize: Constant.doublemoreImageTextSize,
            // تحديد نوع الخط وزنه
            fontWight: FontWeight.bold,
            // تحديد لون النص
            color: AppTheme.colorWhite,
          ),
        ),
      ),
    );
  }

  // عرض صورة بدون تأثير زجاجي
  images({required String image}) {
    return Container(
      // تعيين ارتفاع الحاوية للخريطة المُعتمة
      height: Constant.blureMapBoxSize,
      // تعيين عرض الحاوية للخريطة المُعتمة
      width: Constant.blureMapBoxSize,
      decoration: BoxDecoration(
        // تعيين لون الحاوية ليكون شفافًا
        color: AppTheme.colorTransprant,
        // تعيين زوايا مدورة للحاوية
        borderRadius: BorderRadius.circular(Constant.blureMapBoxRadius),
        // إضافة صورة خلفية للحاوية
        image: DecorationImage(
          image: AssetImage(image), // استخدام الصورة المُحددة
        ),
      ),
    );
  }
}
