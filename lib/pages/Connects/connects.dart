import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gatheuprksa/pages/Connects/connects_controller.dart';
import 'package:gatheuprksa/theme/app_theme.dart';
import 'package:gatheuprksa/util/_string.dart';
import 'package:gatheuprksa/util/constants.dart';
import 'package:gatheuprksa/util/resources.dart';
import 'package:gatheuprksa/widgets/Custom_Textfield.dart';
import 'package:gatheuprksa/widgets/Custombutton.dart';
import 'package:gatheuprksa/widgets/_appbar.dart';
import 'package:gatheuprksa/widgets/connectTile.dart';
import 'package:gatheuprksa/widgets/custom_text.dart';
import 'package:gatheuprksa/widgets/no_appbar.dart';

import '../../widgets/showToast.dart';

class Connect extends StatefulWidget {
  const Connect({super.key});

  @override
  State<Connect> createState() => _ConnectState();
}

class _ConnectState extends State<Connect> {
  double? height;
  double? width;
  Stream<QuerySnapshot> stream = FirebaseFirestore.instance.collection('visitorEvents').snapshots();

  final connectController = Get.put(ConnectController());
  final title = TextEditingController();
  final address = TextEditingController();
  final landmark = TextEditingController();
  final description = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // دالة لإضافة تجربة جديدة
  Future addEvent() async {
    CollectionReference userref = FirebaseFirestore.instance.collection('visitorEvents');
    userref.add({
      "title": title.text,
      'landmark': landmark.text,
      'address': address.text,
      'description': description.text,
    });
    showShortToast("تمت الإضافة بنجاح");
    // بعد إضافة الفعالية، نقوم بالانتقال إلى الشاشة الرئيسية
    connectController.index = Constant.INT_ONE;
    connectController.update();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    // يتم استخدام GetBuilder للتحكم في حالة الـ ConnectController
    return GetBuilder(
        init: connectController,
        builder: (_) {
          return Scaffold(body: _body());
        });
  }

  // دالة تقوم بإرجاع الجزء الرئيسي للصفحة
  _body() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [
          Builder(builder: (context) {
            // يتم استخدام switch لتحديد الجزء الذي يتم عرضه على الشاشة
            switch (connectController.index) {
              case Constant.INT_ONE:
                return __body();
              case Constant.INT_TWO:
                return _addEvent();

              case Constant.INT_FOUR:
                return _superLeadsBody();

              default:
                return __body();
            }
          }),
        ],
      ),
    );
  }

  // دالة لعرض الجزء الأول من الشاشة
  __body() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // عناصر لتحديد الخيارات المتاحة للمستخدم
          optionBox(
              icon: superLeads,
              title: Strings.visitorEvents,
              onTap: () {
                connectController.index = Constant.INT_FOUR;
                connectController.update();
              }),
          optionBox(
              icon: group,
              title: Strings.addEvent,
              onTap: () {
                connectController.index = Constant.INT_TWO;
                connectController.update();
              })
        ],
      ),
    );
  }

  // دالة لعرض الجزء المتعلق بإضافة تجربة جديدة
  _addEvent() {
    return Scaffold(
      backgroundColor: AppTheme.connectBodyColor,
      appBar: NoAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: Constant.bookingTileLeftPadding,
            right: Constant.bookingTileRightPadding,
          ),
          child: Column(
            children: [
              Padding(
                padding: Constant.constantPadding(Constant.SIZE100 / 2),
                child: CustomAppBar(
                    leftPadding: 15,
                    bottomPadding: 10,
                    title: Strings.addEvent,
                    space: Constant.SIZE15,
                    onTap: () {
                      connectController.index = Constant.INT_ONE;
                      connectController.update();
                    }),
              ),
              Container(
                color: AppTheme.loginPageColor,
                height: height,
                width: width,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 22,
                        ),
                        // واجهات إدخال لإدخال بيانات الفعالية
                        CustomTextFeild(
                          controller: title,
                          hintText: "إسم الفعالية :",
                          hintSize: 16,
                          contentRightPadding: 10,
                          onTap: () {},
                          onChanged: (newValue) => newValue,
                        ),
                        CustomTextFeild(
                          controller: landmark,
                          hintText: "المنطقة :",
                          hintSize: 16,
                          contentRightPadding: 10,
                          onTap: () {},
                          onChanged: (newValue) => newValue,
                        ),
                        CustomTextFeild(
                          controller: address,
                          hintText: "العنوان :",
                          hintSize: 16,
                          contentRightPadding: 10,
                          onTap: () {},
                          onChanged: (newValue) => newValue,
                        ),
                        CustomTextFeild(
                          controller: description,
                          hintText: "وصف الفعالية :",
                          hintSize: 16,
                          contentRightPadding: 10,
                          onTap: () {},
                          onChanged: (newValue) => newValue,
                        ),
                        CustomButton(
                          backgroundColor: AppTheme.customButtonBgColor,
                          borderColor: AppTheme.customButtonBgColor,
                          buttonTitle: Strings.add,
                          height: Constant.customButtonHeight,
                          onTap: () {
                            // التحقق من صحة البيانات قبل إضافة الفعاليه
                            if (_formKey.currentState!.validate()) {
                              addEvent();
                            }
                          },
                          textColor: AppTheme.colorWhite,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // دالة لعرض الجزء المتعلق بعرض التجارب
  _superLeadsBody() {
    return Scaffold(
      backgroundColor: AppTheme.connectBodyColor,
      appBar: NoAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(
          left: Constant.bookingTileLeftPadding,
          right: Constant.bookingTileRightPadding,
        ),
        child: Padding(
          padding: Constant.constantPadding(Constant.SIZE100 / 2),
          child: Column(
            children: [
              // شريط عنوان لعرض عنوان الصفحة
              CustomAppBar(
                  title: Strings.visitorEvents,
                  space: Constant.SIZE15,
                  leftPadding: 15,
                  bottomPadding: 10,
                  onTap: () {
                    connectController.index = Constant.INT_ONE;
                    connectController.update();
                  }),
              const SizedBox(
                height: Constant.SIZE15,
              ),
              Expanded(
                // عرض التجارب باستخدام StreamBuilder
                child: StreamBuilder<QuerySnapshot>(
                    stream: stream,
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(width: 40, height: 40, child: CircularProgressIndicator());
                      }
                      if (snapshot.hasData) {
                        // استخدام ListView.builder لعرض التجارب بشكل ديناميكي
                        return ListView.builder(
                          padding: const EdgeInsets.only(
                            left: Constant.searchTileListLeftPadding,
                            right: Constant.searchTileListRightPadding,
                            top: Constant.searchTileListTopPadding,
                          ),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot document = snapshot.data!.docs[index];
                            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                            String title = data['title'];
                            String landmark = data['landmark'];
                            String address = data['address'];
                            String description = data['description'];

                            // عرض بيانات الفعالية باستخدام ConnectTile
                            return ConnectTile(
                              isGroupTile: false,
                              title: title,
                              address: address,
                              description: description,
                              landmark: landmark,
                            );
                          },
                        );
                      }
                      return const SizedBox();
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  // دالة لعرض مربع خيارات
  optionBox({required String icon, required String title, void Function()? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(top: Constant.connectOptionBoxTopPadding),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: height! * Constant.connectOptionBoxHeight,
          width: width! * Constant.connectOptionBoxWidth * 1.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Constant.connectOptionBoxRadius),
            color: AppTheme.colorWhite,
            boxShadow: [
              Constant.boxShadow(
                color: AppTheme.greyColor,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: Constant.connectOptionBoxIconRightPadding),
                child: SvgPicture.asset(
                  icon,
                  color: AppTheme.themeColor,
                  height: Constant.connectOptionBoxIconSize,
                  width: Constant.connectOptionBoxIconSize,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              CustomText(
                title: title,
                fontfamily: Strings.emptyString,
                color: AppTheme.themeColor,
                fontWight: FontWeight.w400,
                fontSize: Constant.connectOptionBoxTitleSize,
              )
            ],
          ),
        ),
      ),
    );
  }
}
