import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gatheuprksa/pages/Dashboard/home.dart';
import 'package:gatheuprksa/routes/app_routes.dart';
import 'package:gatheuprksa/theme/app_theme.dart';
import 'package:gatheuprksa/util/_string.dart';
import 'package:gatheuprksa/util/constants.dart';
import 'package:gatheuprksa/widgets/Custombutton.dart';
import 'package:gatheuprksa/widgets/_appbar.dart';
import 'package:gatheuprksa/widgets/custom_text.dart';
import 'package:gatheuprksa/widgets/no_appbar.dart';
import '../../widgets/Custom_Textfield.dart';
import 'signup_controller.dart';

class SignUp extends StatefulWidget {
  String? userRole;

  SignUp({Key? key, required this.userRole}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  /*
  هذا الكود يعرف متغيرات التحكم والتحكم بنصوص وحقول إدخال تسجيل الدخول.
  يتم استخدام متغير singupController للتحكم في حالة إظهار/إخفاء كلمة المرور.
  تم إعداد حقول التحكم بالنص (_emailController، _nameController، _numberController، _numberofvisitsController، _passwordController، _confirmPasswordController).
  الدالة signUp تُستخدم لتنفيذ العملية الفعلية لتسجيل المستخدم.
  يتم استخدام دالة passwordConfirmed للتحقق من تطابق كلمة المرور وتأكيدها.

  - bool passwordConfirmed(): تُستخدم للتحقق من تطابق كلمة المرور وتأكيدها.
  - الدوال التحكمية (_emailController.text.trim()، _nameController.text.trim()، ...): يتم استخدامها للحصول على القيم المدخلة في حقول النص.
  - if (_passwordController.text.trim() == _confirmPasswordController.text.trim()): يتحقق من تطابق كلمة المرور وتأكيدها.

*/
  final singupController = Get.put(SignupController());
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> signUp() async {
    bool passwordConfirmed() {
      if (_passwordController.text.trim() == _confirmPasswordController.text.trim()) {
        return true;
      } else {
        return false;
      }
    }

    final FirebaseAuth auth = FirebaseAuth.instance;
    CollectionReference userRef = FirebaseFirestore.instance.collection('customUsers');

    // Check if the email already exists
    bool emailExists = false;
    QuerySnapshot snapshot = await userRef.where('email', isEqualTo: _emailController.text.trim()).get();
    if (snapshot.docs.isNotEmpty) {
      emailExists = true;
    }

    if (passwordConfirmed() && !emailExists) {
      try {
        UserCredential result = await auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        await userRef.add({
          "uid": result.user?.uid,
          'name': _nameController.text,
          'number': _numberController.text,
          'role': widget.userRole,
          'address': _addressController.text,
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      } catch (e) {
        String errorMessage = "";
        if (e is FirebaseAuthException) {
          errorMessage = e.message ?? "An error occurred during sign up.";
        } else {
          errorMessage = "An error occurred during sign up.";
        }

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                title: const Text("Error"),
                content: const Text("This email has been used before"),
                actions: [
                  TextButton(
                    child: const Text("Close"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          },
        );
      }
    } else {
      String errorMessage = !passwordConfirmed() ? "Passwords do not match." : "Email already exists.";

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: const Text("Error"),
              content: Text(errorMessage),
              actions: [
                TextButton(
                  child: const Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _numberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  double height = Constant.zero;
  double width = Constant.zero;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return GetBuilder(
        init: singupController,
        builder: (con) {
          return Scaffold(
            appBar: NoAppBar(),
            backgroundColor: AppTheme.signupBodyColor,
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Padding(
                padding: const EdgeInsets.only(top: Constant.signupBodyTopPadding),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomAppBar(
                          title: Strings.createAccount,
                          space: Constant.SIZE50,
                          onTap: () {
                            Get.back();
                          },
                          leftPadding: Constant.signUpeAppbarLeftPadding,
                          rightPadding: Constant.signUpeAppbarRightPadding,
                          bottomPadding: Constant.signUpeAppbarBottomPadding),
                      CustomTextFeild(
                        controller: _nameController,
                        hintText: Strings.username,
                        prefixIcon: const Icon(
                          Icons.person_4_outlined,
                          color: AppTheme.colorblack38,
                        ),
                      ),
                      CustomTextFeild(
                        controller: _emailController,
                        hintText: Strings.email,
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: AppTheme.colorblack38,
                        ),
                      ),
                      CustomTextFeild(
                        controller: _numberController,
                        hintText: Strings.phoneNumber,
                        prefixIcon: const Icon(
                          Icons.numbers,
                          color: AppTheme.colorblack38,
                        ),
                      ),
                      CustomTextFeild(
                        controller: _addressController,
                        hintText: Strings.address,
                        prefixIcon: const Icon(
                          Icons.numbers,
                          color: AppTheme.colorblack38,
                        ),
                      ),
                      /*
  هذا الكود يقوم بإنشاء حقل إدخال (TextField) مخصص لإدخال عدد زيارات المستخدم للمدينة في شاشة تسجيل الدخول (SignUp).
  يحتوي الحقل على أيقونة تمثل عدد الزيارات ونص توضيحي للمستخدم.
*/

                      CustomTextFeild(
                        controller: _passwordController,
                        hintText: Strings.password,
                        prefixIcon: const Icon(
                          Icons.password,
                          color: AppTheme.colorblack38,
                        ),
                        isObscureText: singupController.passwordObsecured,
                        suffixIcon: InkWell(
                            onTap: () {
                              singupController.passwordObsecured = !singupController.passwordObsecured;
                              singupController.update();
                            },
                            child: Icon(
                              singupController.passwordObsecured ? Icons.visibility_off : Icons.visibility,
                              color: Colors.black38,
                            )),
                      ),
                      /*
  هذا الكود يقوم بإنشاء حقل إدخال (TextField) مخصص لإعادة إدخال كلمة المرور في شاشة تسجيل الدخول (SignUp).
  يحتوي الحقل على أيقونة تمثل كلمة المرور وأيقونة تبديل لإظهار/إخفاء كلمة المرور، ونص توضيحي للمستخدم.

  - controller: يتم تحديد وحدة التحكم لهذا الحقل للوصول إلى القيمة المدخلة.
  - hintText: نص توضيحي يظهر داخل حقل الإدخال.
  - prefixIcon: أيقونة تمثل نوع البيانات المتوقع إدخالها (كلمة المرور في هذه الحالة).
  - suffixIcon: أيقونة تبديل لإظهار/إخفاء كلمة المرور.
  - isObscureText: يتم استخدام هذا الخيار لتحديد ما إذا كانت كلمة المرور مخفية أم لا.

*/

                      CustomTextFeild(
                        controller: _confirmPasswordController, // وحدة التحكم للوصول إلى قيمة المدخلة.
                        hintText: Strings.repeatPassword, // نص توضيحي يظهر داخل حقل الإدخال.
                        prefixIcon: const Icon(
                          Icons.password, // أيقونة تمثل نوع البيانات المتوقع إدخالها (كلمة المرور في هذه الحالة).
                          color: AppTheme.colorblack38,
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            // يتم تبديل حالة إخفاء/إظهار كلمة المرور.
                            singupController.repeatpasswordObsecured = !singupController.repeatpasswordObsecured;
                            singupController.update();
                          },
                          child: Icon(
                            singupController.repeatpasswordObsecured ? Icons.visibility_off : Icons.visibility,
                            color: AppTheme.colorblack38,
                          ),
                        ),
                        isObscureText:
                            singupController.repeatpasswordObsecured, // تحديد ما إذا كانت كلمة المرور مخفية أم لا.
                      ),
                      /*
  هذا الكود يقوم بإنشاء عنصر واجهة المستخدم لعرض نص توضيحي مُنسّق بشكل غني (Rich Text) في شاشة تسجيل الدخول (SignUp).
  يتضمن النص عبارة "By continuing you agree" مع روابط للشروط والخدمة وسياسة الخصوصية.

  - textAlign: يُستخدم لتحديد توجيه النص داخل العنصر (وسوف يكون مركزيًا هنا).
  - text: يُستخدم لتحديد نص العنصر مع تنسيقات مختلفة.
  - style: يُستخدم لتحديد تنسيقات النص الرئيسية مثل لون النص والوزن الخطي وحجم الخط.
  - children: تُستخدم لإضافة عناصر تنسيق إضافية مثل روابط الشروط والخدمة وسياسة الخصوصية.
*/

                      CustomButton(
                        backgroundColor: AppTheme.themeColor,
                        borderColor: AppTheme.themeColor,
                        buttonTitle: Strings.signUp,
                        height: Constant.customButtonHeight,
                        textColor: AppTheme.colorWhite,
                        onTap: () {
                          signUp();
                        },
                      ),
                      /*
  هذا الكود يُنشئ عنصر InkWell لتحويل المستخدم إلى صفحة تسجيل الدخول عند النقر عليه.
  يحتوي العنصر على عناصر أخرى مثل CustomText لعرض رسالة تحتوي على رابط "Already account" ونص "Login now".

  - highlightColor: يُستخدم لتحديد لون التمييز أثناء النقر.
  - splashColor: يُستخدم لتحديد لون الرذاذ أثناء النقر.
  - onTap: يحدد الدالة التي يتم تنفيذها عند النقر على العنصر (في هذه الحالة يتم تحويل المستخدم إلى صفحة تسجيل الدخول).
  - child: يحدد عناصر الواجهة داخل InkWell، في هذه الحالة يتم استخدام Row لتحديد عدة عناصر أفقية.

  - mainAxisAlignment: تُستخدم لتحديد توجيه العناصر الفرعية (في هذه الحالة في وسط الصفحة).
  - Padding: تُستخدم لتحديد حواف العنصر وتوفير المسافة بين النصوص والحواف الخارجية.
  - CustomText: تُستخدم لإظهار نص الرسالة مع تنسيقات مخصصة.

*/

                      InkWell(
                        highlightColor: AppTheme.colorTransprant,
                        splashColor: AppTheme.colorTransprant,
                        onTap: () {
                          Get.toNamed(AppRoute.LOGIN); // تحويل المستخدم إلى صفحة تسجيل الدخول.
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, // وسط النصوص في الصف.
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: Constant.alreadyMamberTextPadding),
                              child: CustomText(
                                title: Strings.alreadyAccount,
                                fontfamily: Strings.emptyString,
                                fontWight: FontWeight.bold,
                                color: AppTheme.colorblack38,
                                fontSize: Constant.alreadyMamberTextSize,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: Constant.alreadyMamberTextPadding),
                              child: CustomText(
                                title: Strings.loginNew,
                                fontfamily: Strings.emptyString,
                                fontSize: Constant.alreadyMamberTextSize,
                                fontWight: FontWeight.bold,
                                color: AppTheme.themeColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
