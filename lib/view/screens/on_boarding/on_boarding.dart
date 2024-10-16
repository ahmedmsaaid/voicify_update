import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voicify/core/translation/locate_keys.g.dart';
import 'package:voicify/model/data/cache/cache_helper.dart';
import 'package:voicify/model/data/cubits/auth_cubit/auth_cubit.dart';

import 'package:voicify/model/data/cubits/home_cubit/home_cubit.dart';
import 'package:voicify/view/screens/home_screen/home_screen.dart';
import 'package:voicify/view/screens/signIn_screen/signIn_screen.dart';
import 'package:voicify/viewmodel/firebase/firebase.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.locale.toString() == "en") {
      HomeCubit.get(context).lang = false;
      HomeCubit.get(context).dropdownValue = "en";
    } else {
      HomeCubit.get(context).lang = true;
      HomeCubit.get(context).dropdownValue = "ar";
    }
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: Image.asset(
                'assets/images/mic2.png',
                fit: BoxFit.cover, // لضمان ملء الصورة
              ),
            ),
            Expanded(
              flex: 7,
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.zero,
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      // borderRadius: BorderRadius.only(
                      //     topLeft: Radius.circular(100.r),
                      //     topRight: Radius.circular(100.r)),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black, // أسود رمادي
                          Color(0xFF6a1b9a), // لون أرجواني داكن
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                    ),
                    child: texts(context), // تأكد من أن هذه الدالة موجودة
                  ),
                  Positioned(
                    top: -3.h,
                    child: ClipPath(
                      clipper: ContanerWithCircle(),
                      // تأكد من أن هذا الكلاسر موجود
                      child: Container(
                        padding: EdgeInsets.zero,
                        height: 80, // استخدم قيمة ثابتة بدلاً من 80.h
                        width: MediaQuery.of(context)
                            .size
                            .width, // استخدم عرض الشاشة
                        color: Theme.of(context).cardColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget texts(BuildContext context) {
  return BlocProvider(
    create: (context) => AuthCubit(),
    child: BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 25.h,
            ),
            Text(
              LocaleKeys.appName.tr(),
              style: GoogleFonts.abel(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 40.sp,
                ),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Text(
              LocaleKeys.onBoardingTitle.tr(),
              style: GoogleFonts.abel(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Center(
                child: Text(
                  LocaleKeys.onBoardingDescription.tr(),
                  overflow: TextOverflow.clip,
                  // maxLines: 4,
                  style: GoogleFonts.abel(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 35.h,
            ),
            SizedBox(
              width: 220.w,
              height: 30.h,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r)),
                      backgroundColor: Colors.deepPurpleAccent),
                  onPressed: () async {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SharedHelper.getData(FirebaseKeys.email) == null
                                  ? const SignInScreen()
                                  : const HomeScreen(),
                        ));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        LocaleKeys.getStart.tr(),
                        style: GoogleFonts.abel(
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 20.sp),
                        ),
                      ),
                      const Icon(Icons.arrow_forward_rounded,
                          color: Colors.white)
                    ],
                  )),
            )
          ],
        );
      },
    ),
  );
}

class ContanerWithCircle extends CustomClipper<Path> {
  var path = Path();

  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;
    path.lineTo(0, size.height);
    path.quadraticBezierTo(w * 0.5, h - 150, w, h);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
