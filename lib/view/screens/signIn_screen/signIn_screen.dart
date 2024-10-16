import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voicify/core/translation/locate_keys.g.dart';
import 'package:voicify/view/screens/home_screen/home_screen.dart';
import 'package:voicify/view/widgets/reset_password/reset_password.dart';
import 'package:voicify/viewmodel/models/colors/app_colors.dart';

import '../../../model/data/cubits/auth_cubit/auth_cubit.dart';
import '../signUp_screen/signUp_screen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> form = GlobalKey<FormState>();
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: Container(
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
                listener: (context, state) async {
                  if (state is SuccessSignIn ||
                      state is SuccessSignUpWithGoogle) {
                    await Navigator.pushReplacement(
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
                  }
                },
                builder: (context, state) {
                  var cubit = AuthCubit.get(context);
                  return Form(
                    key: form,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Image(
                            image: Image.asset("assets/images/mic2.png").image),
                        Center(
                          child: Text(
                            LocaleKeys.signIn.tr(),
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        TextField(
                          controller: cubit.email,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.transparent,
                            hintText: LocaleKeys.email.tr(),
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white), // للحد الصريح
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
                              borderSide: BorderSide(
                                  color: Colors.white), // للحد الصريح
                            ),
                            prefixIcon: const Icon(Icons.lock),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Column(
                          children: [
                            TextButton(
                              onPressed: () {
                                ResetPassword.reset(context);
                              },
                              child: Text(
                                textAlign: TextAlign.start,
                                LocaleKeys.forgottenPassword.tr(),
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 12.sp),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              await cubit.signIn();

                              // cubit.signUp();
                              // Handle login action
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side:
                                    BorderSide(color: Colors.grey, width: 1.w),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 15),
                              backgroundColor: AppColors.purple
                                  .withOpacity(.3), // Button color
                            ),
                            child: state is LoadingSignIn
                                ? const Center(
                                    child: CircularProgressIndicator.adaptive(),
                                  )
                                : Text(
                                    LocaleKeys.signIn.tr(),
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.grey),
                                  ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        const Center(child: Text("OR")),
                        SizedBox(height: 10.h),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              await cubit.signInWithGoogle();
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side:
                                    BorderSide(color: Colors.grey, width: 1.w),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 15),
                              backgroundColor: AppColors.purple
                                  .withOpacity(.3), // Button color
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 20.h,
                                  width: 20.w,
                                  child: Image.asset(
                                    "assets/images/gmail.png",
                                  ),
                                ),
                                state is LoadingSignUpWithGoogle
                                    ? const Center(
                                        child: CircularProgressIndicator
                                            .adaptive(),
                                      )
                                    : Text(
                                        LocaleKeys.signInGoogle.tr(),
                                        style: const TextStyle(
                                            fontSize: 18, color: Colors.grey),
                                      ),
                                const SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(LocaleKeys.dontHaveAccount.tr()),
                            SizedBox(
                              width: 20.w,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SignupScreen(),
                                    ));
                                // Handle register
                              },
                              child: Text(
                                LocaleKeys.signUp.tr(),
                                style:
                                    const TextStyle(color: Colors.blueAccent),
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
      ),
    );
  }
}
