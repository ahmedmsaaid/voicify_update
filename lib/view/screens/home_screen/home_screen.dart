import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voicify/core/serveses/services_locator.dart';
import 'package:voicify/core/translation/locate_keys.g.dart';
import 'package:voicify/model/data/cubits/home_cubit/home_cubit.dart';
import 'package:voicify/view/screens/home_screen/libiary/library.dart';
import 'package:voicify/view/screens/home_screen/record//Record.dart';
import 'package:voicify/view/screens/home_screen/upload/upload.dart';
import 'package:voicify/viewmodel/models/colors/app_colors.dart';

import 'home/home.dart';
import 'settings/settings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      Home(),
      Record(),
      Library(
          height: HomeCubit.get(context)
              .height(HomeCubit.get(context).savedItems.length)
              .h),
      const Upload(),
      const Settings(),
    ];

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return Scaffold(
          backgroundColor: AppColors.purple,
          body: screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            selectedItemColor: AppColors.blue,
            selectedFontSize: 14,
            unselectedFontSize: 12,
            showUnselectedLabels: true,
            onTap: (index) {
              cubit.navBar(index);
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: LocaleKeys.home.tr(),
                  backgroundColor: Colors.transparent),
              BottomNavigationBarItem(
                  icon: Icon(Icons.mic),
                  label: LocaleKeys.record.tr(),
                  backgroundColor: Colors.transparent),
              BottomNavigationBarItem(
                  icon: Icon(Icons.my_library_music),
                  label: LocaleKeys.library.tr(),
                  backgroundColor: Colors.transparent),
              BottomNavigationBarItem(
                  icon: Icon(Icons.upload),
                  label: LocaleKeys.uploadFile.tr(),
                  backgroundColor: Colors.transparent),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: LocaleKeys.settings.tr(),
                  backgroundColor: Colors.transparent),
            ],
          ),
        );
      },
    );
  }
}
