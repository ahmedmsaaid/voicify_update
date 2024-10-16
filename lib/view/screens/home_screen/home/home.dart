import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// ignore: unused_import
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voicify/core/translation/locate_keys.g.dart';
import 'package:voicify/model/data/cache/cache_helper.dart';

import 'package:voicify/model/data/cubits/auth_cubit/auth_cubit.dart';
import 'package:voicify/model/data/cubits/home_cubit/home_cubit.dart';
import 'package:voicify/viewmodel/firebase/firebase.dart';
import 'package:voicify/viewmodel/models/colors/app_colors.dart';

import '../../../widgets/about_us/about_us.dart';
import '../../on_boarding/on_boarding.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black, // أسود رمادي
            Color(0xFF6a1b9a), // لون أرجواني داكن
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is SuccessSignOut) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OnBoardingScreen(),
                    ));
              }
            },
            listenWhen: (previous, current) {
              return current != previous;
            },
            child: ListView(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
                  child: ListTile(
                    trailing: _popUoButton(),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          ImageIcon(AssetImage(HomeCubit.get(context).avatar))
                              .image,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${LocaleKeys.hi.tr()} ${SharedHelper.getData(FirebaseKeys.name)}",
                          style: const TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(LocaleKeys.welcome.tr(),
                            style:
                                TextStyle(color: Colors.grey, fontSize: 14.sp)),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    LocaleKeys.homeTitle.tr(),
                    style: TextStyle(fontSize: 22.sp),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(8.0.w, 0.h, 8.w, 8.h),
                  child: Text(LocaleKeys.homeHed.tr(),
                      style: TextStyle(fontSize: 22.sp)),
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(8.0.w, 0.h, 8.w, 8.h),
                      child: Text(LocaleKeys.appName.tr(),
                          style: TextStyle(fontSize: 21.sp)),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.w, 8.h, 8.w, 0.h),
                      child: Text(LocaleKeys.homeDescription1.tr(),
                          style: TextStyle(fontSize: 16.sp)),
                    ),
                  ],
                ),
                descriptions(context),
                SizedBox(
                  height: 20.h,
                ),
                Center(child: _circle()),
                _button(h, w, context),
                _container(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget enDescriptions(String test) {
  return Padding(
    padding: EdgeInsets.fromLTRB(8.0.w, 0, 8.w, 4.h),
    child: Text(test),
  );
}

Widget descriptions(context) {
  return HomeCubit.get(context).lang
      ? Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            "${LocaleKeys.homeDescription2.tr()}${LocaleKeys.homeDescription3.tr()}${LocaleKeys.homeDescription4.tr()}${LocaleKeys.homeDescription5.tr()} ",
            style: TextStyle(fontSize: 14.sp),
          ),
        )
      : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            enDescriptions(LocaleKeys.homeDescription2.tr()),
            enDescriptions(LocaleKeys.homeDescription3.tr()),
            enDescriptions(LocaleKeys.homeDescription4.tr()),
            enDescriptions(LocaleKeys.homeDescription5.tr()),
          ],
        );
}

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xFF542FB8) // لون الدائرة
      ..style = PaintingStyle.stroke // نوع الرسم (ملء)
      ..strokeWidth = 4;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2), // مركز الدائرة
      size.width / 2, // نصف القطر
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

Widget _circle() {
  return SizedBox(
    width: 180.w,
    height: 180.h,
    child: Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          painter: CirclePainter(),
          child: Align(
            alignment: Alignment.center,
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.multitrack_audio_sharp,
                      size: 25.r, color: const Color(0xFF542FB8)),
                  Icon(Icons.multitrack_audio_sharp,
                      size: 25.r, color: const Color(0xFF542FB8)),
                  Icon(
                    Icons.multitrack_audio_sharp,
                    size: 30.r,
                    color: const Color(0xFF542FB8),
                  ),
                  Icon(
                    Icons.multitrack_audio_sharp,
                    size: 25.r,
                    color: const Color(0xFF542FB8),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _button(h, w, context) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: w * .20.w, vertical: 20.h),
    child: MaterialButton(
        height: 40.h,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        color: const Color(0xFF542FB8),
        onPressed: () {
          HomeCubit.get(context).navBar(1);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              LocaleKeys.startRecording.tr(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold),
            ),
            Icon(
              Icons.mic,
              color: Colors.white,
              size: 15.r,
            ),
          ],
        )),
  );
}

Widget _container(context) {
  return Padding(
    padding: EdgeInsets.all(8.0.r),
    child: InkWell(
      onTap: () {
        HomeCubit.get(context).navBar(2);
      },
      child: Container(
        height: 50.h,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              width: 3.w,
              color: const Color(0xFF542FB8),
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              LocaleKeys.seeHowVoiceScribeWorks.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            HomeCubit.get(context).lang
                ? const Icon(
                    Icons.arrow_circle_left,
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.arrow_circle_right,
                    color: Colors.white,
                  )
          ],
        ),
      ),
    ),
  );
}

Widget _popUoButton() {
  return PopupMenuButton<String>(
      color: Colors.transparent.withOpacity(.9),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: AppColors.white,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      icon: const Icon(
        Icons.more_vert_outlined,
        color: Colors.white,
      ),
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<String>>[
          PopupMenuItem(
            value: 'Settinsg',
            child: MaterialButton(
              onPressed: () {
                Navigator.pop(context);
                HomeCubit.get(context).navBar(4);
              },
              child: Text(
                LocaleKeys.settings.tr(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          PopupMenuItem(
            value: 'About Us',
            child: MaterialButton(
              onPressed: () {
                AboutUs.aboutUs(context);
              },
              child: Text(
                LocaleKeys.aboutUs.tr(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          PopupMenuItem(
            value: 'Log Out',
            child: MaterialButton(
              onPressed: () {
                AuthCubit.get(context).signOut();
              },
              child: Text(
                LocaleKeys.signOut.tr(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ];
      });
}
