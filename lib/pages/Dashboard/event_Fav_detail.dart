import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gatheuprksa/util/constants.dart';
import 'package:gatheuprksa/widgets/_appbar.dart';
import 'package:gatheuprksa/widgets/no_appbar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

class EventFavDetail extends StatefulWidget {
  String documentId;
  String citiesdocumentId;
  String documentDetailId;
  String userId;
  String userName;
  EventFavDetail({
    Key? key,
    required this.documentId,
    required this.citiesdocumentId,
    required this.documentDetailId,
    required this.userId,
    required this.userName,
  }) : super(key: key);

  @override
  State<EventFavDetail> createState() => _EventFavDetailState();
}

class _EventFavDetailState extends State<EventFavDetail> {
  double height = Constant.zero;
  double width = Constant.zero;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // استخدام MediaQuery للحصول على أبعاد الشاشة
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    // Scaffold: الهيكل الرئيسي للصفحة
    return Scaffold(
      appBar: NoAppBar(), // لا يوجد شريط عنوان في هذه الصفحة
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('cities')
            .doc(widget.citiesdocumentId) // استخدام قيمة citiesdocumentId هنا
            .collection('events')
            .doc(widget.documentDetailId)
            .snapshots(),
        builder: (context, snapshot) {
          var place = snapshot.data?.data() as Map<String, dynamic>?; // البيانات من Firestore
          String title = place?['title'] ?? ''; // العنوان
          String address = place?['address'] ?? ''; // العنوان
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

          int totalTicketsAvailable = place?['totalTicketsAvailable'] ?? ''; // الوصف الثاني
          List<Map<String, String>> images = [
            {'picture': place?['imageUrl'] ?? 'https://www.gothamindustries.com/images/image-not-available.png'},
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
                        Get.back();
                      },
                    ),
                    const Spacer(),
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
                          fontSize: 15,
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
                          fontSize: 14.0,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
