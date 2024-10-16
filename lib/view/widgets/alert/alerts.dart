import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../model/data/cubits/data_cubit/data_cubit.dart';

class Alerts {
  static showMassage(BuildContext context, String msg) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent.withOpacity(.6),
          contentPadding: EdgeInsets.zero,
          content: BlocListener<DataCubit, DataState>(
            listener: (context, state) {
              Future.delayed(
                Duration(seconds: 3),
                () {},
              );
            },
            child: Container(
              padding: EdgeInsets.zero,
              height: 200.h,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withOpacity(.5))),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      msg,
                      style: TextStyle(color: Colors.white, fontSize: 18.sp),
                    ),
                  ),
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.blueAccent,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
