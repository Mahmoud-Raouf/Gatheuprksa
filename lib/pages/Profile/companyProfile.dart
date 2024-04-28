import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gatheuprksa/util/hexcode.dart';
import 'package:get/get.dart';
import 'package:gatheuprksa/pages/Dashboard/home_controller.dart';
import 'package:gatheuprksa/theme/app_theme.dart';
import 'package:gatheuprksa/util/constants.dart';
import 'package:gatheuprksa/webservices/firebase_data.dart';
import 'profile_controller.dart';

class CompanyProfile extends StatefulWidget {
  HomeController homeController;
  CompanyProfile({super.key, required this.homeController});

  @override
  State<CompanyProfile> createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  static String useruid = "COFFsG8MIUdqb2EMk3X1tXoJePY2";
  int eventsCount = 0;

  double? height;
  double? width;
  String _name = "";

  String _location = "";
  String _numberContent = "";
  String _emailContent = "";

// الاستعلام للحصول على عدد ال events التي قام بها المستخدم المسجل دخول
  Future<int> getEventsCount(String userUid) async {
    // جمع العدد الإجمالي للفعاليات
    int totalEventsCount = 0;

    // جلب قائمة الشركات
    QuerySnapshot<Map<String, dynamic>> companiesSnapshot =
        await FirebaseFirestore.instance.collection('Companies').get();

    // لكل شركة، جلب عدد الفعاليات وإضافته إلى العدد الإجمالي
    await Future.forEach(companiesSnapshot.docs, (companyDoc) async {
      QuerySnapshot<Map<String, dynamic>> eventsSnapshot = await FirebaseFirestore.instance
          .collection('cities')
          .doc('7zqgM4jdO8e182TllvRl')
          .collection('events')
          .where('uid', isEqualTo: userUid)
          .get();
      totalEventsCount += eventsSnapshot.size;
    });

    print("Total Events Count: $totalEventsCount");
    return totalEventsCount;
  }

  static Future<void> initialize() async {
    getCurrentUseData();
    getCurrentUserNumberPhone();
    getCurrentEmail();
  }

  Future<void> _getEventsCount() async {
    // قم بتنفيذ الدالة التي تسترجع عدد الفعاليات
    int count = await getEventsCount(useruid);
    // حدث حالة الحاوية لإعادة بناء الواجهة مع القيمة الجديدة
    setState(() {
      eventsCount = count;
    });
  }

  @override
  void initState() {
    super.initState();
    homeController = widget.homeController;

    // استدعاء دوال الحصول على البيانات عند بداية تحميل الصفحة
    getCurrentUseData().then(
      (name) {
        setState(() {
          _name = name;
        });
      },
    );
    // استخدام Future للحصول على رقم الهاتف للمستخدم الحالي

    getCurrentUserNumberPhone().then((number) {
      setState(() {
        // قم بإرجاع الرقم

        _numberContent = number;
      });
    });

    getCurrentEmail().then((uemail) {
      setState(() {
        _emailContent = uemail;
      });
    });
    getCurrentUserAddress().then((address) {
      setState(() {
        _location = address;
      });
    });
    _getEventsCount();

    // تحديث الـ state بمعلومات المستخدم
    setState(() {
      useruid = currentUser.uid;
    });
  }

  HomeController homeController = HomeController();

  final profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return GetBuilder(
      init: profileController,
      builder: (_) {
        return Scaffold(
          backgroundColor:
              profileController.index_ == Constant.INT_THREE ? AppTheme.editProfileBodyColor : AppTheme.colorWhite,
          body: Container(
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [HexColor('#b24eff'), HexColor('#c37afc').withOpacity(0.6)],
                          begin: Alignment.topCenter,
                          end: Alignment.center)),
                ),
                Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Container(
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.only(top: height / 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: height / 30,
                                ),
                                const Text(
                                  'مرحباً بك ',
                                  style: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  ' $_name',
                                  style:
                                      const TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: height / 2.2),
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: height / 2.6, left: width / 20, right: width / 20),
                          child: Column(
                            children: <Widget>[
                              Container(
                                decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                                  BoxShadow(color: Colors.black45, blurRadius: 2.0, offset: Offset(0.0, 2.0))
                                ]),
                                child: Padding(
                                  padding: EdgeInsets.all(width / 20),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                                    // headerChild('عدد الفعاليات', "$eventsCount"),
                                    headerChild('العنوان', _location),
                                    headerChild('رقم الهاتف', _numberContent),
                                  ]),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: height / 20),
                                child: Column(
                                  children: <Widget>[
                                    infoChild(width, Icons.email, _emailContent),
                                    infoChild(width, Icons.location_city, _location),
                                    Padding(
                                      padding: EdgeInsets.only(top: height / 30),
                                      child: Container(
                                        width: width / 3,
                                        height: height / 20,
                                        decoration: BoxDecoration(
                                            color: HexColor('#b24eff'),
                                            borderRadius: BorderRadius.all(Radius.circular(height / 40)),
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.black87, blurRadius: 2.0, offset: Offset(0.0, 1.0))
                                            ]),
                                        child: const Center(
                                          child: Text('تسجيل الخروج',
                                              style: TextStyle(
                                                  fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget headerChild(String header, String value) => Expanded(
          child: Column(
        children: <Widget>[
          Text(header),
          const SizedBox(
            height: 8.0,
          ),
          Text(
            value,
            style: TextStyle(fontSize: 14.0, color: HexColor('#b24eff'), fontWeight: FontWeight.bold),
          )
        ],
      ));

  Widget infoChild(double width, IconData icon, data) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: InkWell(
          child: Row(
            children: <Widget>[
              SizedBox(
                width: width / 20,
              ),
              Icon(
                icon,
                color: HexColor('#b24eff'),
                size: 36.0,
              ),
              SizedBox(
                width: width / 10,
              ),
              Text(data),
            ],
          ),
          onTap: () {
            print('Info Object selected');
          },
        ),
      );
}
