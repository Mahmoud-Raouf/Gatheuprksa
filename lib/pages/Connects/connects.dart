import 'dart:io';

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
import 'package:gatheuprksa/widgets/custom_text.dart';
import 'package:gatheuprksa/widgets/no_appbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gatheuprksa/webservices/firebase_data.dart';

import '../../widgets/showToast.dart';

class Connect extends StatefulWidget {
  const Connect({super.key});

  @override
  State<Connect> createState() => _ConnectState();
}

class _ConnectState extends State<Connect> {
  double? height;
  double? width;
  static String? useruid;

  Stream<QuerySnapshot> stream = FirebaseFirestore.instance.collection('visitorEvents').snapshots();

  final connectController = Get.put(ConnectController());
  final title = TextEditingController();
  final address = TextEditingController();
  final totalTicketsAvailable = TextEditingController();
  final ticketPrice = TextEditingController();
  final landmark = TextEditingController();
  final description = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? _startingDate;
  DateTime? _endDate;

  String? imageFile;

  List<Map<String, dynamic>> cities = [
    {'id': 'dMdaehwSyMbu2nxgs1KO', 'name': 'مدينة الرياض'},
    {'id': '7Tpjxhrhm6gume5JWlxL', 'name': 'مدينة جدة'},
    {'id': 'sFKDBYmpC7cmn6dWWNvh', 'name': 'مدينة الطائف'},
    {'id': 'e1nVyLMvMvhoNHIKOv5k', 'name': 'مدينة العلا'},
    {'id': 'h2RZWOgq8bEmOgQ9Wd5f', 'name': 'مدينة ابها'},
  ];
  String selectedCityId = 'dMdaehwSyMbu2nxgs1KO'; // تحديد قيمة متوافقة مع المدن المتاحة

  // دالة لتحديث قيمة معرف المدينة المختارة
  void updateSelectedCity(String cityId) {
    setState(() {
      selectedCityId = cityId;
    });
  }

  Future addEvent() async {
    CollectionReference userref =
        FirebaseFirestore.instance.collection('cities').doc(selectedCityId).collection('events');
    String descriptionText = description.text;
    int numberOfCharacters = 30; // عدد الأحرف التي تريد استخراجها
    String notesText = descriptionText.length > numberOfCharacters
        ? descriptionText.substring(0, numberOfCharacters)
        : descriptionText;
    setState(() {
      imageFile = imageFile; // يمكنك إعادة تعيين القيمة إلى null بعد الرفع بنجاح إذا كنت ترغب في ذلك
    });
    // إضافة بيانات الحدث مع رابط الصورة إلى قاعدة البيانات
    userref.add({
      "title": title.text,
      'cityId': selectedCityId,
      'landmark': landmark.text,
      'address': address.text,
      'totalTicketsAvailable': totalTicketsAvailable.text,
      'ticketPrice': ticketPrice.text,
      'startingDate': _startingDate,
      'endingDate': _endDate,
      'description': description.text,
      'notes': notesText,
      'imageUrl': imageFile, // رابط الصورة في Firebase Storage
      'uid': useruid,
    });

    showShortToast("تمت الإضافة بنجاح");
    // بعد إضافة الفعالية، نقوم بالانتقال إلى الشاشة الرئيسية
    connectController.index = Constant.INT_ONE;
    connectController.update();
  }

// دالة لرفع الصور إلى Firebase Storage
  Future<void> uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    showShortToast("يتم رفع الصورة الأن برجاء الانتظار");

    if (pickedFile != null) {
      FirebaseStorage storage = FirebaseStorage.instanceFor(bucket: 'gs://gatherup-74d27.appspot.com');
      Reference ref = storage.ref().child('${DateTime.now()}.png');
      UploadTask uploadTask = ref.putFile(File(pickedFile.path));

      await uploadTask.whenComplete(() async {
        String downloadURL = await ref.getDownloadURL();

        setState(() {
          imageFile = downloadURL; // Resetting imageFile to null after successful upload if desired
        });
        print('downloadURL ::::::::::::: $downloadURL');

        // Use downloadURL as the value for the imageUrl key when adding data to Firestore
      });
    } else {
      print('No image selected');
    }
  }

  @override
  void initState() {
    super.initState();

    // تحديث الـ state بمعلومات المستخدم
    setState(() {
      useruid = currentUser.uid;
    });
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppTheme.connectBodyColor,
      appBar: NoAppBar(),
      body: SingleChildScrollView(
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
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
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
                      Row(
                        children: [
                          SizedBox(
                            width: width * 0.5,
                            child: CustomTextFeild(
                              controller: landmark,
                              hintText: "المنطقة :",
                              hintSize: 16,
                              contentRightPadding: 10,
                              onTap: () {},
                              onChanged: (newValue) => newValue,
                            ),
                          ),
                          SizedBox(
                            width: width * 0.5,
                            child: CustomTextFeild(
                              controller: address,
                              hintText: "العنوان :",
                              hintSize: 16,
                              contentRightPadding: 10,
                              onTap: () {},
                              onChanged: (newValue) => newValue,
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          SizedBox(
                            width: width * 0.5,
                            child: CustomTextFeild(
                              controller: totalTicketsAvailable,
                              hintText: "عدد التذاكر المتاحة :",
                              hintSize: 16,
                              contentRightPadding: 10,
                              onTap: () {},
                              onChanged: (newValue) => newValue,
                            ),
                          ),
                          SizedBox(
                            width: width * 0.5,
                            child: CustomTextFeild(
                              controller: ticketPrice,
                              hintText: "سعر التذكرة :",
                              hintSize: 16,
                              contentRightPadding: 10,
                              onTap: () {},
                              onChanged: (newValue) => newValue,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.buttonThemeColor,
                          ),
                          child: const Text('تحديد موعد بدأ الفعالية'),
                          onPressed: () async {
                            // Show the date picker
                            DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );

                            // Update the selected date
                            setState(() {
                              _startingDate = selectedDate ?? _startingDate;
                            });
                          }),
                      const SizedBox(
                        width: 15,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.buttonThemeColor,
                          ),
                          child: const Text('تحديد موعد إنتهاء الفعالية'),
                          onPressed: () async {
                            // Show the date picker
                            DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );

                            // Update the selected date
                            setState(() {
                              _endDate = selectedDate ?? _endDate;
                            });
                          }),
                      // عرض قائمة المدن للاختيار من بينها
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 14.0, right: 14),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                dropdownColor: Colors.white,
                                value: selectedCityId,
                                items: cities
                                    .map((city) => DropdownMenuItem<String>(
                                          value: city['id'] as String, // تحويل قيمة المفتاح إلى String
                                          child: Text(city['name'] as String), // تحويل قيمة الاسم إلى String
                                        ))
                                    .toList(),
                                onChanged: (String? newValue) {
                                  // تغيير النوع ليكون String
                                  if (newValue != null) {
                                    updateSelectedCity(newValue);
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),

                      CustomTextFeild(
                        controller: description,
                        hintText: "وصف الفعالية :",
                        hintSize: 16,
                        contentRightPadding: 10,
                        onTap: () {},
                        onChanged: (newValue) => newValue,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: width * 0.5,
                            child: CustomButton(
                              backgroundColor: AppTheme.customButtonBgColor,
                              borderColor: AppTheme.customButtonBgColor,
                              buttonTitle: "رفع صورة",
                              height: Constant.customButtonHeight,
                              onTap: uploadImage,
                              textColor: AppTheme.colorWhite,
                            ),
                          ),
                          imageFile != null
                              ? SizedBox(
                                  width: width * 0.5,
                                  child: CustomButton(
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
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
