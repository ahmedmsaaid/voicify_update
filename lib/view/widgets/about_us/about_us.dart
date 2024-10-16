import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/link.dart';
import 'package:voicify/core/translation/locate_keys.g.dart';
import 'package:voicify/model/data/cubits/data_cubit/data_cubit.dart';


class AboutUs {
  static aboutUs(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // backgroundColor: Colors.transparent.withOpacity(.6),
          contentPadding: EdgeInsets.zero,
          content: BlocBuilder<DataCubit, DataState>(
            builder: (context, state) {
              return Container(
                padding: EdgeInsets.zero,
                // height: 450.h,
                // width: 250.w,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withOpacity(.5))),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          LocaleKeys.aboutData.tr(),
                          style:
                              TextStyle(color: Colors.black, fontSize: 12.sp),
                        ),
                      ),
                      Link(
                          target: LinkTarget.blank,
                          uri: Uri.parse("https://ahmedmsaaaid.netlify.app"),
                          builder: (context, followLink) => TextButton(
                              onPressed: followLink,
                              child: const Row(
                                children: [
                                  Text("About Developer "),
                                  Icon(Icons.open_in_new_outlined)
                                ],
                              )))
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
}
