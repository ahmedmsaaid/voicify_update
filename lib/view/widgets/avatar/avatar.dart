import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:voicify/model/data/cubits/home_cubit/home_cubit.dart';
import 'package:voicify/view/screens/home_screen/home_screen.dart';

import '../../../core/avatars/avatar_list.dart';

class ChangeAvatar {
  static Future<void> change(
    ScrollController scrollController,
    BuildContext context,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent.withOpacity(.6),
          contentPadding: EdgeInsets.zero,
          content: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              var cubit = HomeCubit.get(context);
              return SizedBox(
                height: 600,
                width: 400,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                  ),
                  itemCount:
                      avatars.length, // تأكد من تعريف 'avatars' في مكان ما
                  controller: scrollController,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          HomeCubit.get(context).changeAvatar(index.toString());
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            child: SizedBox(
                              child: cubit.avatarIndex != index
                                  ? CircleAvatar(
                                      radius: 15,
                                      backgroundImage: ImageIcon(
                                              AssetImage(avatars[index].icon))
                                          .image,
                                    )
                                  : CircleAvatar(
                                      backgroundColor:
                                          Colors.green.withOpacity(.6),
                                      radius: 55,
                                      child: CircleAvatar(
                                        radius: 45,
                                        backgroundImage: ImageIcon(
                                                AssetImage(avatars[index].icon))
                                            .image,
                                      ),
                                    ),
                            ),
                          ),
                        ));
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// تأكد من تعريف قائمة 'avatars' في مكان ما في الكود،
