import 'package:animations/animations.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voicify/core/api/dio_consumer.dart';
import 'package:voicify/core/serveses/services_locator.dart';
import 'package:voicify/core/translation/locate_keys.g.dart';
import 'package:voicify/model/data/cubits/data_cubit/data_cubit.dart';
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
      BlocProvider.value(
        value: HomeCubit()..getList(),
        child: Home(),
      ),
      Library(
          height: HomeCubit.get(context)
              .height(HomeCubit.get(context).savedItems.length)
              .h),
      Record(),
      Upload(),
      Settings(),
    ];

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return Scaffold(
          extendBodyBehindAppBar: true,
          extendBody: true,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF6a1b9a),
                  Colors.black87,
                  Color(0xFF6a1b9a),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: PageTransitionSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (
                Widget child,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return SharedAxisTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  fillColor: Colors.transparent,
                  transitionType: SharedAxisTransitionType.vertical,
                  child: child,
                );
              },
              child: screens[cubit.currentIndex],
            ),
          ),
          bottomNavigationBar: CurvedNavigationBar(
            backgroundColor: Colors.transparent,
            color: Color(0xFF6a1b9a),
            buttonBackgroundColor: AppColors.blue,
            animationDuration: Duration(milliseconds: 300),
            index: cubit.currentIndex,
            height: 60,
            onTap: (index) {
              cubit.navBar(index);
            },
            items: [
              _buildNavItem(Icons.home, "Home", cubit.currentIndex == 0),
              _buildNavItem(
                  Icons.my_library_music, "Library", cubit.currentIndex == 1),
              _buildNavItem(Icons.mic, "Record", cubit.currentIndex == 2),
              _buildNavItem(Icons.upload, "Upload", cubit.currentIndex == 3),
              _buildNavItem(
                  Icons.settings, "Settings", cubit.currentIndex == 4),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isSelected ? Colors.white : Colors.grey[400],
          size: 24,
        ),
        SizedBox(height: 4),
        !isSelected
            ? Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[400],
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
