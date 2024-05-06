import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gatheuprksa/theme/app_theme.dart';
import 'package:gatheuprksa/util/constants.dart';
import 'package:gatheuprksa/webservices/firebase_data.dart';
import 'package:gatheuprksa/widgets/_appbar.dart';
import 'package:gatheuprksa/widgets/custom_text.dart';
import 'package:gatheuprksa/widgets/no_appbar.dart';
import 'package:get/get.dart';

class Statistics extends StatefulWidget {
  final String citiesDocumentId;
  final String citiesName;

  const Statistics({
    Key? key,
    required this.citiesDocumentId,
    required this.citiesName,
  }) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  late String userId;
  double height = 0.0;
  double width = 0.0;

  @override
  void initState() {
    super.initState();
    getCurrentUserUid().then((uid) {
      setState(() {
        userId = uid;
        print("userId :::::::::::: $userId");
      });
    });
    ("citiesDocumentId :::::::::::: ${widget.citiesDocumentId}");
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
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
                    title: "إحصائيات فعالياتك لمدينة ${widget.citiesName}",
                    space: 13,
                    leftPadding: 15,
                    bottomPadding: 10,
                    onTap: () {
                      Get.back();
                    },
                  ),
                  SizedBox(
                    height: height * Constant.searchBodyHeight,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('cities')
                          .doc(widget.citiesDocumentId)
                          .collection('events')
                          .where('uid', isEqualTo: userId)
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
                              int like = data['like'];
                              int userFav = data['userFav'];
                              int sharedCount = data['sharedCount'];
                              int NumberOfVisits = data['NumberOfVisits'];
                              String documentDetailuid = document.id;

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
                                              height: height * 0.13,
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

                                                Padding(
                                                  padding: const EdgeInsets.only(top: Constant.tripCardLocationPadding),
                                                  child: SizedBox(
                                                    width: width * 0.45,
                                                    child: CustomText(
                                                      title: 'عدد مرات الإعجاب : $like',
                                                      fontSize: Constant.searchTileSubTitleSize,
                                                      color: Colors.black87,
                                                      fontWight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: Constant.tripCardLocationPadding),
                                                  child: SizedBox(
                                                    width: width * 0.45,
                                                    child: CustomText(
                                                      title: 'عدد مرات التفضيل : $userFav',
                                                      fontSize: Constant.searchTileSubTitleSize,
                                                      color: Colors.black87,
                                                      fontWight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: Constant.tripCardLocationPadding),
                                                  child: SizedBox(
                                                    width: width * 0.45,
                                                    child: CustomText(
                                                      title: 'عدد مرات المشاركة : $sharedCount',
                                                      fontSize: Constant.searchTileSubTitleSize,
                                                      color: Colors.black87,
                                                      fontWight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: Constant.tripCardLocationPadding),
                                                  child: SizedBox(
                                                    width: width * 0.45,
                                                    child: CustomText(
                                                      title: 'عدد الزيارات للفعالية : $NumberOfVisits',
                                                      fontSize: Constant.searchTileSubTitleSize,
                                                      color: Colors.black87,
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
}
