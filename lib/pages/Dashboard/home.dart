import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gatheuprksa/pages/Connects/connects.dart';
import 'package:gatheuprksa/pages/Dashboard/event_Fav_detail.dart';
import 'package:gatheuprksa/pages/Dashboard/home_controller.dart';
import 'package:gatheuprksa/pages/Profile/profile.dart';
import 'package:gatheuprksa/theme/app_theme.dart';
import 'package:gatheuprksa/util/_string.dart';
import 'package:gatheuprksa/util/constants.dart';
import 'package:gatheuprksa/util/places.dart';
import 'package:gatheuprksa/util/resources.dart';
import 'package:gatheuprksa/webservices/firebase_data.dart';
import 'package:gatheuprksa/widgets/Custombutton.dart';
import 'package:gatheuprksa/widgets/_appbar.dart';
import 'package:gatheuprksa/widgets/custom_text.dart';
import 'package:gatheuprksa/widgets/glashMorphisam.dart';
import 'package:gatheuprksa/widgets/no_appbar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double height = Constant.zero;
  double width = Constant.zero;
  Stream<QuerySnapshot> stream = FirebaseFirestore.instance.collection('cities').snapshots();
  String? commentContent;
  String userId = "";
  String userName = "";

  final homeController = Get.put(HomeController());
  String documentId = "";
  String citiesdocumentId = "";
  String documentDetailId = "";
  String _title = "";
  String _description1 = "";
  String _description2 = "";
  String _subImage1 = "";
  String _subImage2 = "";
  String _subImage3 = "";
  String _subImage4 = "";

  String? imageUrl; // حقل مؤقت لعنوان الصورة
  Future<String> downloadImage(String imagePath) async {
    try {
      // تحميل الصورة من Firebase Storage
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref(imagePath);
      final imageUrl = await ref.getDownloadURL();
      print("imageUrl ::::::::::::: $imageUrl");
      return imageUrl;
    } catch (e) {
      print('Error downloading image: $e');
      return ''; // يمكنك تعديل هذا الجزء ليتناسب مع متطلبات التعامل مع الأخطاء
    }
  }

  Future<void> fetchDocument() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('cities')
        .doc(documentId)
        .collection('events')
        .where('id', isEqualTo: documentDetailId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final data = querySnapshot.docs[0].data();

      setState(() {
        _title = data['title'] ?? '';
        _description1 = data['description1'] ?? '';
        _description2 = data['description2'] ?? ''; // Fix the typo here
        _subImage1 = data['subImage1'] ?? '';
        _subImage2 = data['subImage2'] ?? '';
        _subImage3 = data['subImage3'] ?? '';
        _subImage4 = data['subImage4'] ?? '';
      });
    } else {
      setState(() {
        _title = '';
        _description1 = '';
        _description2 = '';
        _subImage1 = '';
        _subImage2 = '';
        _subImage3 = '';
        _subImage4 = '';
      });
    }
  }

// لعرض جميع الوثائق المفضلة للمستخدم
  void showFavorites() {
    // استعرض وثائق المفضلة للمستخدم من Firestore
    FirebaseFirestore.instance
        .collection('usersFav')
        .doc(userId)
        .collection('favorites')
        .snapshots()
        .listen((snapshot) {
      // استخدم snapshot.data للوصول إلى قائمة الوثائق المفضلة
      for (var doc in snapshot.docs) {
        var favoriteDocumentId = doc.id;
        print("favoriteDocumentId ::::::::::::::::::::::::::: $favoriteDocumentId");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserUid().then((uid) {
      setState(() {
        userId = uid;
        print("userId :::::::::::: $userId");
      });
    });
    getCurrentUseData().then((name) {
      setState(() {
        userName = name;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return GetBuilder(
        init: homeController,
        builder: (_) {
          return Scaffold(body: _body());
        });
  }

  _body() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // إغلاق لوحة المفاتيح عند النقر على أي مكان في الشاشة
      },
      child: Stack(
        children: [
          Builder(builder: (context) {
            switch (homeController.index) {
              case Constant.INT_ONE:
                return _home(); // عرض واجهة الصفحة الرئيسية
              case Constant.INT_TWO:
                return Profile(
                  homeController: homeController,
                ); // عرض واجهة الصفحة الشخصية
              case Constant.INT_THREE:
                return const Connect(); // عرض واجهة الصفحة "Connect"
              case Constant.INT_FOUR:
                return allEvents(documentId); // عرض واجهة قائمة الحجوزات
              case Constant.INT_SIX:
                return detailsPage(); // عرض واجهة تفاصيل مكان
              case Constant.INT_FAV:
                return allFavEvents(documentId); // عرض واجهة تفاصيل مكان

              default:
                return _home();
            }
          }),
          bottomNavBar() // عرض شريط التنقل السفلي
        ],
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  List<String> images = [image1, image2, image3, image4, image5, image6];

  mainTitle({
    double topPadding = Constant.categoriesPadding,
    double leftPadding = 0,
    double rightPadding = 0,
    required String title,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding, left: leftPadding, right: rightPadding),
      child: CustomText(
        title: title,
        fontWight: FontWeight.w900,
      ),
    );
  }

  _home() {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          colors: homeController.isSearchOpened ? AppTheme.homeBgColor2 : AppTheme.homeBgColor,
        ),
      ),
      child: Padding(
        padding: Constant.constantPadding(Constant.SIZE100),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: Constant.homeFirstHeadingPadding,
                  right: Constant.homeFirstHeadingPadding,
                ), // هامش للعنصر الرئيسي
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // تنظيم العناصر بشكل أفقي بين الحواف
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start, // محاذاة العناصر إلى الأعلى
                      crossAxisAlignment: CrossAxisAlignment.start, // محاذاة العناصر إلى اليسار
                      children: [
                        CustomText(
                          title: Strings.whereDo, // نص العنصر الأول
                          fontfamily: Strings.emptyString, // نوع الخط
                          fontSize: Constant.homeFirstHeadingSize, // حجم الخط
                          fontWight: FontWeight.w400, // وزن الخط
                        ),
                        CustomText(
                          fontSize: Constant.homeFirstHeadingSize, // حجم الخط
                          height: Constant.homeFirstHeadingHeight, // ارتفاع العنصر
                          fontWight: FontWeight.w600, // وزن الخط
                          title: homeController.isSearchOpened
                              ? Strings.youWantToSee
                              : Strings.youWantToGo, // نص العنصر الثاني يعتمد على حالة البحث
                          fontfamily: Strings.emptyString, // نوع الخط
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: Constant.circleImageRadius, // نصف قطر الصورة الدائرية
                      child: IconButton(
                        icon: const Icon(Icons.exit_to_app), // أيقونة خروج
                        onPressed: () {
                          _signOut(context); // استدعاء دالة الخروج عند النقر
                        },
                      ),
                    )
                  ],
                ),
              ),
              planedTile(),
            ],
          ),
        ),
      ),
    );
  }

  planedTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasData) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 1.4,
              width: width,
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot document = snapshot.data!.docs[index];
                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                  String name = data['name'];
                  String picture = data['picture'];
                  String documentuid = document.id;
                  return InkWell(
                    onTap: () {
                      homeController.index = Constant.INT_FOUR;
                      homeController.update();
                      setState(() {
                        documentId = documentuid;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0), // هامش للعنصر الرئيسي
                      child: Container(
                        height: Constant.planImageTopBoxHeight * 5.5, // تحديد ارتفاع العنصر
                        width: width, // تحديد عرض العنصر
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Constant.planImageRadius), // تحديد شكل حواف العنصر
                          image: DecorationImage(
                            image: NetworkImage(picture), // استخدام صورة من الإنترنت باستخدام رابط الصورة
                            fit: BoxFit.fill, // طريقة ملء الصورة داخل الحاوية
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(Constant.planImageTopBoxPadding), // هامش داخلي للعنصر
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end, // محاذاة العناصر إلى اليمين
                            crossAxisAlignment: CrossAxisAlignment.start, // محاذاة العناصر إلى الأعلى
                            children: [
                              GlassmorPhism(
                                // Widget خاص بإضافة تأثير الـGlassmorphism للعنصر
                                blure: Constant.planImageTopBoxBlurness, // درجة التمويه (blurness)
                                opacity: Constant.planImageTopBoxOpacity, // درجة الشفافية
                                radius: Constant.planImageTopBoxRadius, // نصف قطر التأثير
                                child: SizedBox(
                                  height: Constant.planImageTopBoxHeight * 1.2, // ارتفاع العنصر الداخلي
                                  width: Constant.planImageTopBoxWidth * 1.4, // عرض العنصر الداخلي
                                  child: Center(
                                    child: CustomText(
                                      title: name, // نص العنصر
                                      color: AppTheme.colorblack, // لون النص
                                      fontfamily: Strings.emptyString, // خط النص
                                      fontWight: FontWeight.w400, // وزن الخط
                                      fontSize: name.length > 6 ? 12 : 15, // حجم الخط يعتمد على طول النص
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  allEvents(String cityName) {
    return Scaffold(
      backgroundColor: AppTheme.colorTransprant,
      appBar: NoAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(
          left: Constant.bookingTileLeftPadding,
          right: Constant.bookingTileRightPadding,
        ),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: Constant.constantPadding(Constant.SIZE100 / 2),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 300),
              child: Column(
                children: [
                  // شريط العنوان الخاص بالتطبيق
                  CustomAppBar(
                    title: "كل الفعاليات",
                    space: Constant.SIZE15,
                    leftPadding: 15,
                    bottomPadding: 10,
                    onTap: () {
                      // تحديث حالة التطبيق عند النقر على شريط العنوان
                      homeController.index = Constant.INT_ONE;
                      homeController.update();
                    },
                  ),
                  SizedBox(
                    height: height * Constant.searchBodyHeight,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('cities')
                          .doc(documentId)
                          .collection('events')
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                          // عرض قائمة الأماكن السياحية
                          return ListView.builder(
                            padding: EdgeInsets.only(
                              left: Constant.searchTileListLeftPadding,
                              bottom: height * Constant.searchTileListBottomPadding,
                              right: Constant.searchTileListRightPadding,
                              top: Constant.searchTileListTopPadding,
                            ),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot document = snapshot.data!.docs[index];
                              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                              String title = data['title'];
                              String picture = data['imageUrl'];
                              String notes = data['notes'];
                              String documentDetailuid = document.id;

                              // تحميل الصورة من Firebase Storage
                              firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref(picture);
                              print("ref ::::::::::::::::::::::::::::::: $ref");

                              return Stack(
                                children: [
                                  // تأثير زجاجي خلفي للعنصر
                                  BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: Constant.blurSigmaX, sigmaY: Constant.blurSigmaY),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      // إخفاء لوحة المفاتيح عند النقر على العنصر
                                      FocusScope.of(context).unfocus();
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(Constant.searchTileMargin),
                                      padding: const EdgeInsets.only(bottom: Constant.searchTileContentBottomPadding),
                                      decoration: Constant.boxDecoration,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // عرض صورة الأماكن السياحية
                                          // عرض صورة الأماكن السياحية
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: Constant.bookingTileImageRightPadding,
                                              top: Constant.bookingTileTopRightPadding,
                                            ),
                                            child: Container(
                                              height: height * Constant.searchTileImageHeight * 1.2,
                                              width: width / Constant.searchTileImageWidth,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(Constant.searchTileImageCircularRadius),
                                                image: DecorationImage(
                                                  // استخدام قيمة الصورة المؤقتة
                                                  // استخدام قيمة الصورة المؤقتة
                                                  image: picture != null
                                                      ? NetworkImage(picture) // استخدام عنوان URL للصورة
                                                      : const NetworkImage(
                                                              'https://letsenhance.io/static/8f5e523ee6b2479e26ecc91b9c25261e/1015f/MainAfter.jpg')
                                                          as ImageProvider<Object>,

                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),

                                          // معلومات الأماكن السياحية
                                          Padding(
                                            padding: const EdgeInsets.only(right: 8.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                // عنوان الأماكن السياحية
                                                CustomText(
                                                  title: title,
                                                  fontSize: Constant.searchTileTitleSize,
                                                  color: AppTheme.colorblack,
                                                  fontWight: FontWeight.w900,
                                                ),
                                                // عنوان التفاصيل والموقع
                                                Padding(
                                                  padding: const EdgeInsets.only(top: Constant.tripCardLocationPadding),
                                                  child: SizedBox(
                                                    width: width * 0.45,
                                                    child: CustomText(
                                                      title: notes,
                                                      fontSize: Constant.searchTileSubTitleSize,
                                                      color: AppTheme.tripCardLocationColor,
                                                      fontWight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                                // Padding(
                                                //   padding:
                                                //       const EdgeInsets.only(top: Constant.tripCardLocationPadding * 2),
                                                //   child: SizedBox(
                                                //     width: width * 0.45,
                                                //     child: CustomText(
                                                //       title: " $likesNumber لايك",
                                                //       fontSize: width * 0.03,
                                                //       color: AppTheme.tripCardLocationColor,
                                                //       fontWight: FontWeight.w400,
                                                //     ),
                                                //   ),
                                                // ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    right: width * 0.35,
                                                  ),
                                                  child: InkWell(
                                                    onTap: () async {
                                                      // عرض تفاصيل المزيد
                                                      homeController.index = Constant.INT_SIX;
                                                      homeController.update();
                                                      setState(() {
                                                        documentDetailId = documentDetailuid;
                                                      });
                                                    },
                                                    child: CustomText(
                                                      topPadding: Constant.moreTextTopPadding,
                                                      title: Strings.more,
                                                      fontSize: Constant.moreTextSize,
                                                      fontfamily: Strings.emptyString,
                                                      color: AppTheme.themeColor,
                                                      fontWight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // زر "المزيد"
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          return const SizedBox(); // التعامل مع حالة عدم وجود بيانات
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 200,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  allFavEvents(String cityName) {
    return Scaffold(
      backgroundColor: AppTheme.colorTransprant,
      appBar: NoAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(
          left: Constant.bookingTileLeftPadding,
          right: Constant.bookingTileRightPadding,
        ),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: Constant.constantPadding(Constant.SIZE100 / 2),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 300),
              child: Column(
                children: [
                  // شريط العنوان الخاص بالتطبيق
                  CustomAppBar(
                    title: " الفعاليات المفضلة",
                    space: Constant.SIZE15,
                    leftPadding: 15,
                    bottomPadding: 10,
                    onTap: () {
                      // تحديث حالة التطبيق عند النقر على شريط العنوان
                      homeController.index = Constant.INT_ONE;
                      homeController.update();
                    },
                  ),
                  SizedBox(
                    height: height * Constant.searchBodyHeight,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('usersFav')
                          .doc(userId)
                          .collection('favorites')
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                          // عرض قائمة الأماكن السياحية
                          return ListView.builder(
                            padding: EdgeInsets.only(
                              left: Constant.searchTileListLeftPadding,
                              bottom: height * Constant.searchTileListBottomPadding,
                              right: Constant.searchTileListRightPadding,
                              top: Constant.searchTileListTopPadding,
                            ),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot document = snapshot.data!.docs[index];
                              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                              String title = data['title'];
                              String picture = data['picture'];
                              String notes = data['notes'];
                              String favCitiesDocumentId = data['favCitiesDocumentId'];
                              String favDocumentId = data['favDocumentId'];

                              String documentDetailuid = document.id;

                              // بناء كل عنصر من عناصر قائمة الأماكن السياحية
                              return Stack(
                                children: [
                                  // تأثير زجاجي خلفي للعنصر
                                  BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: Constant.blurSigmaX, sigmaY: Constant.blurSigmaY),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      // إخفاء لوحة المفاتيح عند النقر على العنصر
                                      FocusScope.of(context).unfocus();
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(Constant.searchTileMargin),
                                      padding: const EdgeInsets.only(bottom: Constant.searchTileContentBottomPadding),
                                      decoration: Constant.boxDecoration,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // عرض صورة الأماكن السياحية
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: Constant.bookingTileImageRightPadding,
                                              top: Constant.bookingTileTopRightPadding,
                                            ),
                                            child: Container(
                                              height: height * Constant.searchTileImageHeight * 1.2,
                                              width: width / Constant.searchTileImageWidth,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(Constant.searchTileImageCircularRadius),
                                                image: DecorationImage(
                                                  image: NetworkImage(picture),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          // معلومات الأماكن السياحية
                                          Padding(
                                            padding: const EdgeInsets.only(right: 8.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                // عنوان الأماكن السياحية
                                                CustomText(
                                                  title: title,
                                                  fontSize: Constant.searchTileTitleSize,
                                                  color: AppTheme.colorblack,
                                                  fontWight: FontWeight.w900,
                                                ),
                                                // عنوان التفاصيل والموقع
                                                Padding(
                                                  padding: const EdgeInsets.only(top: Constant.tripCardLocationPadding),
                                                  child: SizedBox(
                                                    width: width * 0.45,
                                                    child: CustomText(
                                                      title: notes,
                                                      fontSize: Constant.searchTileSubTitleSize,
                                                      color: AppTheme.tripCardLocationColor,
                                                      fontWight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ),

                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    right: width * 0.34,
                                                  ),
                                                  child: InkWell(
                                                    onTap: () async {
                                                      print("documentDetailuid : $documentDetailuid");
                                                      Get.to(EventFavDetail(
                                                        documentId: favDocumentId,
                                                        citiesdocumentId: favCitiesDocumentId,
                                                        documentDetailId: favDocumentId,
                                                        userId: userId,
                                                        userName: userName,
                                                      ));
                                                      setState(() {
                                                        citiesdocumentId = favCitiesDocumentId;
                                                        documentDetailId = documentDetailuid;
                                                      });
                                                    },
                                                    child: CustomText(
                                                      topPadding: Constant.moreTextTopPadding,
                                                      title: Strings.more,
                                                      fontSize: Constant.moreTextSize,
                                                      fontfamily: Strings.emptyString,
                                                      color: AppTheme.themeColor,
                                                      fontWight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // زر "المزيد"
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          return const SizedBox(); // التعامل مع حالة عدم وجود بيانات
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 200,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  detailsPage() {
    return Scaffold(
      appBar: NoAppBar(), // لا يوجد شريط عنوان في هذه الصفحة
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('cities')
            .doc(documentId)
            .collection('events')
            .doc(documentDetailId)
            .snapshots(),
        builder: (context, snapshot) {
          var place = snapshot.data?.data() as Map<String, dynamic>?; // البيانات من Firestore
          String id = snapshot.data?.id ?? ''; // الـ ID الخاص بالمستند
          String title = place?['title'] ?? ''; // العنوان
          String notes = place?['notes'] ?? ''; // العنوان
          String address = place?['location'] ?? ''; // العنوان
          String description = place?['description'] ?? ''; // الوصف الثاني

          String ticketPrice = place?['ticketPrice'] ?? ''; //

          DateTime? startingDateTime = place?['startingDate']?.toDate();
          if (startingDateTime != null) {
            // قم بإنشاء كائن DateTime
            DateTime now = startingDateTime;
            // الآن يمكنك استخدام الـ now بأمان
          } else {
            // إذا كانت القيمة تساوي null، يجب التعامل مع هذا الحالة هنا
          }
          DateTime now = place?['startingDate']?.toDate() ?? DateTime.now();

          DateFormat formatter = DateFormat.yMd().add_jm();
          String startingDate = formatter.format(now);

          DateTime now2 = place?['endingDate']?.toDate() ?? DateTime.now();
          DateFormat formatter2 = DateFormat.yMd().add_jm();
          String endingDate = formatter2.format(now2);

          String totalTicketsAvailable = place?['totalTicketsAvailable'] ?? ''; // الوصف الثاني
          List<Map<String, String>> images = [
            {'picture': place?['picture'] ?? ''},
            // {'image': place?['subImage2'] ?? ''},
            // {'image': place?['subImage3'] ?? ''},
            // {'image': place?['subImage4'] ?? ''},
          ]; // قائمة بالصور المصغرة للمكان

          return ListView(
            children: <Widget>[
              const SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    CustomAppBar(
                      title: "تفاصيل الفعاليه",
                      space: Constant.SIZE15,
                      leftPadding: 15,
                      bottomPadding: 10,
                      onTap: () {
                        homeController.index = Constant.INT_FOUR;
                        homeController.update();
                      },
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        String imageUrl = place?['picture'] ?? '';

                        FirebaseFirestore.instance
                            .collection('usersFav')
                            .doc(userId)
                            .collection('favorites')
                            .doc(documentId)
                            .set({
                          // يمكنك إضافة المزيد من البيانات إذا كنت بحاجة إليها، مثل اسم الوثيقة أو أي بيانات أخرى.
                          'favCitiesDocumentId': documentId,
                          'favDocumentId': id,
                          'picture': imageUrl,
                          'title': title,
                          'address': address,
                          'description': description,
                          'notes': notes,
                          'ticketPrice': ticketPrice,
                          'startingDate': startingDate,
                          'endingDate': endingDate,
                          'timestamp': FieldValue.serverTimestamp(),
                        });
                      },
                      child: Icon(
                        Icons.favorite_border,
                        size: 20.sp,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    InkWell(
                      onTap: () {
                        Share.share(
                            "فعالية جديدة بعنوان $title  فى $address بسعر $ticketPrice ريال تبدأ فى $startingDate وتنتهى فى $endingDate"); // قائمة الشير التى تظهر اسفل ال الهاتف لتطبيقات السوشيال ميديا
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          'assets/Images/cardshare.svg',
                          color: Colors.black,
                          height: 3.0.h,
                          width: 3.0.w,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                padding: const EdgeInsets.only(left: 20),
                height: 250.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  primary: false,
                  itemCount: images.length,
                  itemBuilder: (BuildContext context, int index) {
                    String imageUrl = images[index]['picture'] ?? '';

                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          imageUrl,
                          height: 250.0,
                          width: MediaQuery.of(context).size.width - 30.0,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              // إذا كانت الصورة قد تم تحميلها بالكامل، نقوم بعرض الصورة
                              return child;
                            } else {
                              // إذا كانت الصورة لا تزال قيد التحميل، نعرض دائرة التحميل
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ?? 1)
                                      : loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ?? 1),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(bottom: 200),
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  primary: false,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                            maxLines: 2,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.blueGrey[300],
                        ),
                        const SizedBox(width: 3),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            address,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.blueGrey[300],
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Container(
                      alignment: Alignment.centerRight,
                      child: const Text(
                        "التفاصيل",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        textAlign: TextAlign.right,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "سعر التذكرة : $ticketPrice ريال",
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 15.0,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "بداية الفعاليه : $startingDate",
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 15.0,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "نهاية الفعاليه : $endingDate",
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 15.0,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "التذاكر المتاحة : $totalTicketsAvailable تذكرة",
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 15.0,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                        alignment: Alignment.centerRight,
                        child: const Text(
                          "الوصف",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          textAlign: TextAlign.right,
                        )),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        description,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 15.0,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Column(
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('cities')
                              .doc(documentId)
                              .collection('events')
                              .doc(documentDetailId)
                              .collection('Comments')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            }
                            return SizedBox(
                              height: 40.h, // ارتفاع ثابت
                              child: ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  DocumentSnapshot document = snapshot.data!.docs[index];
                                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                                  final text = data['text'];
                                  final time = DateFormat('yyyy-MM-dd – kk:mm').format(data['time'].toDate());
                                  final name = data['userName'];

                                  return Card(
                                    color: const Color.fromARGB(255, 238, 238, 238),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 2.w,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "الإسم : $name",
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: const Color.fromARGB(255, 0, 0, 0),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 2.w,
                                              ),
                                              Text(
                                                "بتاريخ $time",
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: const Color.fromARGB(255, 0, 0, 0),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 260.sp,
                                            child: Text(
                                              text,
                                              maxLines: 3,
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                decoration: const InputDecoration(
                                  hintText: 'اكتب تعليقك...',
                                  border: OutlineInputBorder(),
                                ),
                                maxLines: null,
                                onChanged: (value) {
                                  // تحديث محتوى الرسالة بما يتم كتابته
                                  commentContent = value;
                                },
                              ),
                              const SizedBox(width: 10.0),
                              CustomButton(
                                backgroundColor: AppTheme.themeColor,
                                borderColor: AppTheme.themeColor,
                                buttonTitle: "إرسال التعليق",
                                height: Constant.customButtonHeight,
                                textColor: AppTheme.colorWhite,
                                onTap: () {
                                  Future companyAppointmentschat() async {
                                    CollectionReference mainCollectionRef = FirebaseFirestore.instance
                                        .collection('cities')
                                        .doc(documentId)
                                        .collection('events')
                                        .doc(documentDetailId)
                                        .collection('Comments');
                                    DateTime now = DateTime.now();
                                    Timestamp currentTimestamp = Timestamp.fromDate(now);

                                    mainCollectionRef.add({
                                      'text': commentContent,
                                      'userName': userName,
                                      'time': currentTimestamp,
                                      'userUID': userId,
                                    });
                                  }

                                  companyAppointmentschat();
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  buildSlider() {
    // يُنشئ ويعين مظهر العنصر
    return Container(
      padding: const EdgeInsets.only(left: 20),
      height: 250.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // تحديد اتجاه التمرير (أفقي)
        primary: false,
        itemCount: places == null ? 0 : places.length, // عدد العناصر في القائمة
        itemBuilder: (BuildContext context, int index) {
          Map place = places[index]; // استخراج العنصر الحالي من القائمة

          // بناء عنصر قائمة الصور
          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(
                "${place["img"]}", // استخدام اسم الملف للصورة
                height: 250.0,
                width: MediaQuery.of(context).size.width - 40.0,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  bottomNavBar() {
    // يُنشئ ويعين مظهر شريط التنقل السفلي
    return Align(
      alignment: Alignment.bottomCenter, // تحديد موقع شريط التنقل في الجزء السفلي من الشاشة
      child: Padding(
        padding: const EdgeInsets.all(Constant.bottomNavigationBarPadding),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.colorWhite, // لون خلفية شريط التنقل
            boxShadow: [Constant.boxShadow(color: AppTheme.greyColor)], // إضافة ظل باستخدام boxShadow
            borderRadius: BorderRadius.circular(Constant.bottomNavigationBarRadius), // تحديد زوايا مستديرة للحاوية
          ),
          padding: const EdgeInsets.only(left: Constant.bottomBarLeftPadding, right: Constant.bottomBarRightPadding),
          width: width, // تعيين عرض شريط التنقل بناءً على عرض الشاشة
          height: height * Constant.bottomBarHeight / 1.2, // تحديد ارتفاع شريط التنقل
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              navBarItem(title: Strings.home, index: Constant.INT_ONE, icon: home, tappedIcon: tapHome),
              navBarItem(title: Strings.profile, index: Constant.INT_TWO, icon: tapPerson, tappedIcon: tapPerson),
              navBarItem(title: Strings.experiments, index: Constant.INT_THREE, icon: chat, tappedIcon: tapChat),
              navBarItem(title: Strings.favorite, index: Constant.INT_FAV, icon: favorite, tappedIcon: favorite),
            ],
          ),
        ),
      ),
    );
  }

  navBarItem({required int index, required String icon, required String tappedIcon, required String title}) {
    // InkWell: يُستخدم لإضافة تفاعل عند النقر على العنصر.
    return InkWell(
      onTap: () {
        homeController.index = index; // تحديد الفهرس عند النقر.
        homeController.update(); // تحديث حالة الواجهة بعد تغيير الفهرس.
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            // SvgPicture.asset: يُستخدم لعرض صور SVG من الملفات المحلية.
            homeController.index == index ? tappedIcon : icon, // اختيار أيقونة الزر بناءً على حالة الفهرس.
            height: Constant.bottomBarIconSize, // تحديد ارتفاع أيقونة الزر.
            width: Constant.bottomBarIconSize, // تحديد عرض أيقونة الزر.
            color: homeController.index == index ? AppTheme.themeColor : AppTheme.greyColor, // تحديد لون أيقونة الزر.
          ),
          CustomText(
            topPadding: Constant.bottomBarTitlePadding, // تحديد هامش أعلى لنص العنصر.
            title: title, // نص العنصر.
            fontSize: Constant.bottomBarTitleSize, // حجم الخط لنص العنصر.
            color: homeController.index == index ? AppTheme.themeColor : AppTheme.greyColor, // لون نص العنصر.
          )
        ],
      ),
    );
  }
}
