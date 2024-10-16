import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voicify/core/api/dio_consumer.dart';

import 'package:voicify/model/data/cubits/api_cubit/api_cubit.dart';
import 'package:voicify/model/data/cubits/auth_cubit/auth_cubit.dart';
import 'package:voicify/model/data/cubits/data_cubit/data_cubit.dart';
import 'package:voicify/model/data/cubits/home_cubit/home_cubit.dart';
import 'package:voicify/view/screens/on_boarding/on_boarding.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_, child) {
        return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => HomeCubit(),
              ),
              BlocProvider(
                create: (context) => DataCubit(
                  DioConsumer(dio: Dio()),
                )..initSpeech(),
              ),
              BlocProvider(
                create: (context) => ApiCubit(
                  DioConsumer(dio: Dio()),
                ),
              ),
              BlocProvider(
                create: (context) => AuthCubit(),
              ),
            ],
            child: MaterialApp(
              // showSemanticsDebugger: true,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              title: 'Voicify',
              // You can use the library anywhere in the app even in theme
              theme: ThemeData(
                primarySwatch: Colors.blue,
                textTheme:
                    Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
              ),
              home: child,
            ));
      },
      child: const OnBoardingScreen(),
    );
  }
}
