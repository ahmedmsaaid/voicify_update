import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voicify/core/translation/locate_keys.g.dart';
import 'package:voicify/model/data/cache/cache_helper.dart';
import 'package:voicify/model/data/cubits/api_cubit/api_cubit.dart';
import 'package:voicify/view/widgets/upload/upload_widgets.dart';
import 'package:voicify/viewmodel/firebase/firebase.dart';

import '../../../widgets/save_record/save_record.dart';

class Upload extends StatelessWidget {
  const Upload({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApiCubit, ApiState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black, // أسود رمادي
                Color(0xFF6a1b9a), // لون أرجواني داكن
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: InkWell(
                  onTap: () {
                    print(SharedHelper.getData(FirebaseKeys.userId));
                  },
                  child: Container(
                    width: 320.w,
                    height: 200.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blueGrey, // أسود رمادي
                          Color(0xFF6a1b9a), // لون أرجواني داكن
                        ],
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30.h,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0.r),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0.r),
                                child: InkWell(
                                  onTap: () {
                                    ApiCubit.get(context).pickAudioFile();
                                    SaveRecord.loading(context);
                                    Future.delayed(const Duration(seconds: 5))
                                        .then((_) async {
                                      Navigator.pop(context);

                                      UploadWidgets.pickFile(
                                        context,
                                      );

                                      ApiCubit.get(context).content = "";
                                    });
                                    // UploadWidgets.upload(context, state);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8.r),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.black, // أسود رمادي
                                          Color(0xFF6a1b9a), // لون أرجواني داكن
                                        ],
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Colors.blueGrey, width: 2),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(3.0.r),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ImageIcon(
                                            AssetImage(
                                                "assets/icons/music.png"),
                                            size: 40.r,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 20.w,
                                          ),
                                          Text(
                                            LocaleKeys.audio.tr(),
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0.r),
                                child: InkWell(
                                  onTap: () {
                                    ApiCubit.get(context).pickVideoFile();
                                    SaveRecord.loading(context);
                                    Future.delayed(const Duration(seconds: 5))
                                        .then((_) async {
                                      Navigator.pop(context);

                                      if (ApiCubit.get(context)
                                          .titleController
                                          .text
                                          .isNotEmpty) {
                                        UploadWidgets.pickFile(
                                          context,
                                        );
                                      }

                                      ApiCubit.get(context).content = "";
                                    });
                                    // UploadWidgets.upload(context, state);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.black, // أسود رمادي
                                          Color(0xFF6a1b9a), // لون أرجواني داكن
                                        ],
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                      border: Border.all(
                                          color: Colors.blueGrey, width: 2),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(3.0.r),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ImageIcon(
                                            AssetImage(
                                                "assets/icons/video.png"),
                                            size: 40.r,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 20.w,
                                          ),
                                          Text(
                                            LocaleKeys.video.tr(),
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        SizedBox(height: 10.h),
                        Text(
                          LocaleKeys.uploadDescriptionAudio.tr(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // Center(
              //   child: InkWell(
              //     onTap: () {
              //       UploadWidgets.processing(context);
              //     },
              //     child: Container(
              //       width: 200,
              //       height: 100,
              //       decoration: BoxDecoration(
              //         gradient: LinearGradient(
              //           colors: [Colors.blue, Colors.purple],
              //           begin: Alignment.topLeft,
              //           end: Alignment.bottomRight,
              //         ),
              //         borderRadius: BorderRadius.circular(20),
              //         boxShadow: [
              //           BoxShadow(
              //             color: Colors.black26,
              //             blurRadius: 10,
              //             offset: Offset(0, 5),
              //           ),
              //         ],
              //       ),
              //       child: Column(
              //         children: [
              //           Icon(
              //             Icons.text_fields_outlined,
              //             size: 50,
              //             color: Colors.white,
              //           ),
              //           SizedBox(height: 10),
              //           Text(
              //             'Next',
              //             style: TextStyle(
              //               fontSize: 24,
              //               fontWeight: FontWeight.bold,
              //               color: Colors.white,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }
}
