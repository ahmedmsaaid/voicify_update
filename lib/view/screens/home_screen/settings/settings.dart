import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voicify/core/translation/locate_keys.g.dart';
import 'package:voicify/model/data/cubits/auth_cubit/auth_cubit.dart';
import 'package:voicify/model/data/cubits/home_cubit/home_cubit.dart';
import 'package:voicify/view/widgets/avatar/avatar.dart';
import 'package:voicify/viewmodel/models/colors/app_colors.dart';

import '../../../../core/avatars/avatar_list.dart';
import '../../../../model/data/cache/cache_helper.dart';
import '../../../../viewmodel/firebase/firebase.dart';
import '../../on_boarding/on_boarding.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black, // أسود رمادي
            Color(0xFF6a1b9a), // لون أرجواني داكن
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
        ),
        body: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is SuccessSignOut) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OnBoardingScreen(),
                  ));
            }
          },
          listenWhen: (previous, current) {
            return current != previous;
          },
          child: ListView(
            children: [
              CircleAvatar(
                radius: 65,
                backgroundColor: AppColors.blue,
                child: InkWell(
                  borderRadius: BorderRadius.circular(60),
                  onTap: () {
                    ChangeAvatar.change(
                        HomeCubit.get(context).scrollController, context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SizedBox(
                      child: CircleAvatar(
                        radius: 65,
                        backgroundImage:
                            ImageIcon(AssetImage(HomeCubit.get(context).avatar))
                                .image,
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      SharedHelper.getData(
                        FirebaseKeys.name,
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50.h,
              ),
              Container(
                child: Column(
                  children: [
                    item(
                      Icon(Icons.arrow_forward_ios_outlined),
                      SharedHelper.getData(FirebaseKeys.name),
                      LocaleKeys.name.tr(),
                    ),
                    item(
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 15,
                      ),
                      SharedHelper.getData(FirebaseKeys.email),
                      LocaleKeys.email.tr(),
                    ),
                    item(
                      DropdownButton<String>(
                        dropdownColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(12),

                        onChanged: (value) {
                          if (value != null) {
                            HomeCubit.get(context).changeLang(value);
                            if (value == 'ar') {
                              HomeCubit.get(context).lang = true;
                              context.setLocale(const Locale('ar'));
                            } else {
                              context.setLocale(const Locale('en'));
                              HomeCubit.get(context).lang = false;
                            }
                          }
                        },
                        value: HomeCubit.get(context).dropdownValue,
                        // تحديد القيمة الحالية هنا

                        style: TextStyle(
                          color: Colors.white,
                        ),
                        items: [
                          DropdownMenuItem<String>(
                            value: "ar",
                            child: Text(
                              LocaleKeys.arabic.tr(),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: "en",
                            child: Text(
                              LocaleKeys.english.tr(),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ), // تصحيح اسم اللغة
                          ),
                        ],
                      ),
                      HomeCubit.get(context).dropdownValue,
                      LocaleKeys.lang.tr(),
                    ),
                    item(BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        return Switch(
                            value: HomeCubit.get(context).sync,
                            onChanged: (value) {
                              HomeCubit.get(context).syncFireBase();
                              if (HomeCubit.get(context).sync == true) {
                                HomeCubit.get(context).synceDataFireStore();
                              }
                            });
                      },
                    ), LocaleKeys.syncTitle.tr(), LocaleKeys.sync.tr()),
                  ],
                ),
              ),
              SizedBox(
                height: 50.h,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await AuthCubit.get(context).signOut();

                    // cubit.signUp();
                    // Handle login action
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(color: Colors.grey, width: 1.w),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    backgroundColor:
                        AppColors.purple.withOpacity(.3), // Button color
                  ),
                  child: Container(
                    width: 150.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          LocaleKeys.signOut.tr(),
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        Icon(
                          size: 25,
                          Icons.logout,
                          color: Colors.red,
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
}

Widget item(Widget icon, String title, String name) {
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Container(
      padding: EdgeInsets.zero,
      height: 50.h,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey, width: 1.w),
          borderRadius: BorderRadius.circular(12),
          color: Colors.transparent),
      child: ListTile(
        trailing: icon,
        title: Center(
          child: Text(
            title,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
        leading: Text(
          name,
          style: TextStyle(
              color: Colors.white.withOpacity(.8),
              fontSize: 15.sp,
              fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}
