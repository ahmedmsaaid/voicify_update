import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voicify/core/translation/locate_keys.g.dart';
import 'package:voicify/model/data/cubits/auth_cubit/auth_cubit.dart';
import 'package:voicify/view/screens/home_screen/home_screen.dart';
import 'package:voicify/view/screens/signIn_screen/signIn_screen.dart';

import 'package:voicify/viewmodel/models/colors/app_colors.dart';

import '../../../model/data/cubits/home_cubit/home_cubit.dart';
import '../../widgets/delete/delete.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> form = GlobalKey<FormState>();
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
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is SuccessSignUpWithGoogle) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ));
                } else if (state is FailedSignIn) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.err),
                    ),
                  );
                } else if (state is FailedSignUpWithGoogle) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.err),
                    ),
                  );
                } else if (state is SuccessSignUp) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignInScreen(),
                      ));
                  AuthCubit.get(context).clear();
                  Alert.done(context, LocaleKeys.done.tr());
                }
              },
              builder: (context, state) {
                var cubit = AuthCubit.get(context);
                return Form(
                  key: form,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(image: Image.asset("assets/images/mic2.png").image),
                      Text(
                        LocaleKeys.signUp.tr(),
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 40),
                      TextField(
                        controller: cubit.name,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.transparent,
                          hintText: LocaleKeys.name.tr(),
                          border: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white), // للحد الصريح
                          ),
                          prefixIcon: const Icon(Icons.email),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: cubit.email,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.transparent,
                          hintText: LocaleKeys.email.tr(),
                          border: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white), // للحد الصريح
                          ),
                          prefixIcon: const Icon(Icons.email),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: cubit.password,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.transparent,
                          hintText: LocaleKeys.password.tr(),
                          border: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white), // للحد الصريح
                          ),
                          prefixIcon: const Icon(Icons.lock),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(LocaleKeys.lang.tr()),
                          const SizedBox(
                            width: 20,
                          ),
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

                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            items: [
                              DropdownMenuItem<String>(
                                value: "ar",
                                child: Text(
                                  LocaleKeys.arabic.tr(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: "en",
                                child: Text(
                                  LocaleKeys.english.tr(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ), // تصحيح اسم اللغة
                              ),
                            ],
                          ),
                          const Expanded(child: SizedBox()),
                        ],
                      ),
                      SizedBox(height: 40.h),
                      ElevatedButton(
                        onPressed: () async {
                          await cubit.signUp();

                          // cubit.signUp();
                          // Handle login action
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side:
                                const BorderSide(color: Colors.grey, width: 2),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          backgroundColor:
                              AppColors.purple.withOpacity(.3), // Button color
                        ),
                        child: state is LoadingSignUp
                            ? const Center(
                                child: CircularProgressIndicator.adaptive(),
                              )
                            : Text(
                                LocaleKeys.signUp.tr(),
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.grey),
                              ),
                      ),
                      SizedBox(height: 10.h),
                      Text(LocaleKeys.or.tr()),
                      SizedBox(height: 10.h),
                      ElevatedButton(
                        onPressed: () {
                          cubit.signInWithGoogle();
                          // Handle login action
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(color: Colors.grey, width: 2.w),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          backgroundColor:
                              AppColors.purple.withOpacity(.3), // Button color
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 30,
                              width: 30,
                              child: Image.asset(
                                "assets/images/gmail.png",
                              ),
                            ),
                            Text(
                              LocaleKeys.sigUpnGoogle.tr(),
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            LocaleKeys.alreadyHaveAccount.tr(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignInScreen(),
                                  ));
                            },
                            child: Text(
                              LocaleKeys.signIn.tr(),
                              style: const TextStyle(color: Colors.blueAccent),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
