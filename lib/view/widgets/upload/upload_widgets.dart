import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:voicify/core/translation/locate_keys.g.dart';
import 'package:voicify/model/data/cubits/api_cubit/api_cubit.dart';
import 'package:voicify/model/data/cubits/home_cubit/home_cubit.dart';
import 'package:voicify/viewmodel/models/colors/app_colors.dart';

import '../../../model/data/cubits/data_cubit/data_cubit.dart';
import '../save_record/save_record.dart';
import '../snack_bar/snack_bar.dart';

class UploadWidgets {
  static loading(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: BlocBuilder<ApiCubit, ApiState>(
            builder: (context, state) {
              return Container(
                decoration: const BoxDecoration(color: Colors.transparent),
                child: const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              );
            },
          ),
        );
      },
    );
  }

  static pickFile(BuildContext context) {
    ApiCubit cubit = ApiCubit.get(context);

    // تعيين قيمة titleController مباشرة قبل فتح الحوار
    cubit.titleController.text = cubit.fileName;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: BlocBuilder<ApiCubit, ApiState>(
            builder: (context, state) {
              return state is LoadingConvertToMp3
                  ? Container(
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(12)),
                      height: 50.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            LocaleKeys.convertingToMb3.tr(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.sp,
                            ),
                          ),
                          ClipRRect(
                            clipBehavior: Clip.none,
                            child: Lottie.asset(
                              'assets/lotte_files/saving.json',
                              height: 100.h,
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(
                      child: SizedBox(
                        height: 100.h,
                        child: Column(
                          children: [
                            const Text(
                              'File Title',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: cubit.titleController,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                                // يمكنك إضافة بعض الخصائص هنا إذا كنت ترغب
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Container(
                              width: 230.w,
                              height: 50,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 30.w),
                              decoration: BoxDecoration(
                                color: AppColors.purple,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: MaterialButton(
                                onPressed: () {
                                  cubit.UploadToApi(cubit.data);
                                  Navigator.pop(context);
                                  upload(context, state);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Next',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
            },
          ),
        );
      },
    );
  }

  static upload(BuildContext context, state) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: BlocBuilder<ApiCubit, ApiState>(
            builder: (context, state) {
              var cubit = ApiCubit.get(context);

              return state is LoadingUpload
                  ? Container(
                      width: 350.w,
                      decoration: BoxDecoration(
                        color: AppColors.transparent,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              'assets/lotte_files/uploading.json.json',
                            ),
                            Text(LocaleKeys.fileBeingProcessed.tr()),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      width: 200.w,
                      height: 230.h,
                      padding: const EdgeInsets.all(15),
                      color: AppColors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset('assets/lotte_files/done.json',
                              repeat: false),
                          Container(
                            padding: EdgeInsets.zero,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.blue),
                              color: AppColors.purple,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);

                                cubit.convert();
                                processing(
                                  context,
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    LocaleKeys.convert.tr(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  const Icon(
                                    Icons.wysiwyg_rounded,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
            },
          ),
        );
      },
    );
  }

  static processing(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => BlocBuilder<ApiCubit, ApiState>(
        builder: (context, state) {
          var cubit = ApiCubit.get(context);
          var home = HomeCubit.get(context);

          return AlertDialog(
            backgroundColor:
                state is LoadingConvert ? Colors.transparent : Colors.white,
            contentPadding: EdgeInsets.zero,
            content: SingleChildScrollView(
              child: state is LoadingConvert
                  ? Container(
                      width: 350.w,
                      decoration: BoxDecoration(
                        color: AppColors.transparent,
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Lottie.asset(
                              'assets/lotte_files/processing.json',
                            ),
                            Text(LocaleKeys.almostFinished.tr()),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      height: 450.h,
                      width: 350.w,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: cubit.edit
                                      ? TextField(
                                          maxLength: 50,
                                          controller: cubit.titleController,
                                          // onTap: () => cubit.showScribe(),
                                          maxLines: null,
                                          decoration: InputDecoration(
                                            hintStyle: const TextStyle(
                                                color: Colors.black),
                                            labelText: LocaleKeys.title.tr(),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
                                        )
                                      : Text(cubit.titleController.text,
                                          style: const TextStyle(
                                              color: Colors.black)),
                                ),
                                !cubit.edit
                                    ? SizedBox(height: 10.h)
                                    : SizedBox(),
                                !cubit.edit
                                    ? Divider(
                                        color: Colors.grey,
                                        thickness: 1,
                                        endIndent: 40,
                                        indent: 40,
                                      )
                                    : SizedBox(),
                                Expanded(
                                  child: cubit.edit
                                      ? Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: TextField(
                                            controller: cubit.scribe,
                                            // onTap: () => cubit.showScribe(),
                                            maxLines: null,
                                            decoration: InputDecoration(
                                              hintStyle: const TextStyle(
                                                  color: Colors.black),
                                              labelText: LocaleKeys.go.tr(),
                                              helperText: LocaleKeys
                                                  .editScribeHere
                                                  .tr(),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14),
                                          ),
                                        )
                                      : ListView(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: BlocBuilder<ApiCubit,
                                                  ApiState>(
                                                builder: (context, state) {
                                                  return Text(cubit.scribe.text,
                                                      style: const TextStyle(
                                                          color: Colors.black));
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Container(
                            padding: EdgeInsets.zero,
                            decoration: const BoxDecoration(
                                // border: Border.all(color: AppColors.blue),
                                // borderRadius: BorderRadius.circular(12)
                                ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.indigo,
                                        borderRadius: BorderRadius.circular(12),
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: IconButton(
                                          onPressed: () {
                                            SaveRecord.saving(context);
                                            Future.delayed(
                                                const Duration(seconds: 3), () {
                                              Navigator.pop(context);
                                              home.save(cubit.titleController,
                                                  cubit.scribe);
                                              cubit.titleController.clear();
                                              cubit.edit = false;
                                              Navigator.pop(context);
                                              SaveRecord.done(context);
                                            });
                                          },
                                          icon: Icon(Icons.save,
                                              color: Colors.white)),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      LocaleKeys.save.tr(),
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.deepPurpleAccent,
                                        borderRadius: BorderRadius.circular(12),
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: IconButton(
                                          onPressed: () {
                                            cubit.editButton();
                                          },
                                          icon: Icon(Icons.edit,
                                              color: Colors.white)),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      LocaleKeys.edit.tr(),
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey,
                                        borderRadius: BorderRadius.circular(12),
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: IconButton(
                                          onPressed: () async {
                                            await Clipboard.setData(
                                                ClipboardData(
                                              text: cubit.scribe.text,
                                            )).then((_) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content:
                                                      CostemSnackBar.snackBar(
                                                          context),
                                                  clipBehavior: Clip.antiAlias,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                ),
                                              );
                                            });
                                          },
                                          icon: Icon(Icons.copy,
                                              color: Colors.white)),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      LocaleKeys.copy.tr(),
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
