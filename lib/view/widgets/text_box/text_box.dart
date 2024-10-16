import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voicify/core/translation/locate_keys.g.dart';
import 'package:voicify/model/data/cubits/data_cubit/data_cubit.dart';
import 'package:voicify/model/data/cubits/home_cubit/home_cubit.dart';
import 'package:voicify/view/widgets/save_record/save_record.dart';

import '../alert/alerts.dart';
import '../snack_bar/snack_bar.dart';

class DialogBox {
  static scribe(BuildContext context) {
    var cubit2 = DataCubit.get(context);
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SingleChildScrollView(
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              var cubit = HomeCubit.get(context);
              var data = DataCubit.get(context);

              return data.content.isNotEmpty
                  ? SizedBox(
                      height: 400.h,
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              child: Column(children: [
                                Container(
                                  child: cubit.edit
                                      ? TextField(
                                          maxLength: 10,
                                          controller: DataCubit.get(context)
                                              .titleController,
                                          onTap: () {
                                            DataCubit.get(context).showScribe();
                                          },
                                          maxLines: null,
                                          decoration: InputDecoration(
                                              hintStyle: const TextStyle(
                                                  // fontSize: 15,
                                                  // height: 300,
                                                  color: Colors.black),
                                              // hintText: '',
                                              labelText: DataCubit.get(context)
                                                  .titleController
                                                  .text,
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12))),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              // height: 30,
                                              fontSize: 14),
                                        )
                                      : Text(
                                          DataCubit.get(context)
                                              .titleController
                                              .text,
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                SizedBox(
                                  height: 300,
                                  child: cubit.edit
                                      ? TextField(
                                          controller:
                                              DataCubit.get(context).scribe,
                                          onTap: () {
                                            DataCubit.get(context).showScribe();
                                          },
                                          maxLines: null,
                                          decoration: InputDecoration(
                                              hintStyle: const TextStyle(
                                                  // fontSize: 15,
                                                  // height: 300,
                                                  color: Colors.black),
                                              // hintText: '',
                                              // labelText: data.content,
                                              helperText: LocaleKeys
                                                  .editScribeHere
                                                  .tr(),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12))),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              // height: 30,
                                              fontSize: 14),
                                        )
                                      : Text(
                                          DataCubit.get(context).scribe.text,
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                ),
                              ]),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                // border: Border.all(color: AppColors.blue),
                                // borderRadius: BorderRadius.circular(12)
                                ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.indigo,
                                        borderRadius: BorderRadius.circular(12),
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: IconButton(
                                          onPressed: () {
                                            SaveRecord.saving(context);

                                            Future.delayed(
                                              const Duration(seconds: 3),
                                              () => Navigator.pop(context),
                                            ).then((_) {
                                              Navigator.pop(context);
                                              HomeCubit.get(context).save(
                                                  DataCubit.get(context)
                                                      .titleController,
                                                  DataCubit.get(context)
                                                      .scribe);
                                              DataCubit.get(context)
                                                  .titleController
                                                  .clear();

                                              SaveRecord.done(context);
                                            });
                                          },
                                          icon: const Icon(Icons.save,
                                              color: Colors.white)),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      LocaleKeys.save.tr(),
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.deepPurpleAccent,
                                        borderRadius: BorderRadius.circular(12),
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: IconButton(
                                          onPressed: () {
                                            cubit.editButton();
                                          },
                                          icon: const Icon(Icons.edit,
                                              color: Colors.white)),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      LocaleKeys.edit.tr(),
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Text(LocaleKeys.recordVoiceFirst.tr()),
                    );
            },
          ),
        ),
      ),
    );
  }

  static showScribe(BuildContext context, int index) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SingleChildScrollView(
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              var cubit2 = DataCubit.get(context);
              var cubit = HomeCubit.get(context);

              return SizedBox(
                height: 450.h,
                child: Column(
                  children: [
                    Column(children: [
                      Container(
                        child: Text(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          cubit.savedItems[index].title
                              .toString()
                              .split('.')
                              .first,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        width: 300.w,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        height: 300.h,
                        child: SingleChildScrollView(
                          child: Text(
                            cubit.savedItems[index].content ?? '',
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ]),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                shape: BoxShape.rectangle,
                                color: const Color(0xFF6a1b9a),
                              ),
                              child: IconButton(
                                  onPressed: () {
                                    cubit2.share(
                                        cubit.savedItems[index].content ?? '');
                                  },
                                  icon: const Icon(Icons.share,
                                      color: Colors.white)),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              LocaleKeys.share.tr(),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF03A9F4),
                                borderRadius: BorderRadius.circular(12),
                                shape: BoxShape.rectangle,
                              ),
                              child: IconButton(
                                  onPressed: () async {
                                    await cubit2.download(
                                        cubit.savedItems[index].content ?? '',
                                        cubit.savedItems[index].title ?? '');
                                    Alerts.showMassage(
                                        context, cubit2.downloadPath);

                                    ;
                                    Future.delayed(
                                      const Duration(seconds: 3),
                                      () => Navigator.pop(context),
                                    ).then((_) {
                                      SaveRecord.done(context);
                                    });
                                  },
                                  icon: const Icon(Icons.download_outlined,
                                      color: Colors.white)),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              LocaleKeys.download.tr(),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50),
                                borderRadius: BorderRadius.circular(12),
                                shape: BoxShape.rectangle,
                              ),
                              child: IconButton(
                                  onPressed: () async {
                                    await Clipboard.setData(ClipboardData(
                                      text:
                                          cubit.savedItems[index].content ?? '',
                                    )).then((_) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              CostemSnackBar.snackBar(context),
                                          clipBehavior: Clip.antiAlias,
                                          backgroundColor: Colors.transparent,
                                        ),
                                      );
                                    });
                                  },
                                  icon: const Icon(Icons.copy,
                                      color: Colors.white)),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              LocaleKeys.copy,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
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
    );
  }
}
// IconButton(
//     onPressed: () {
//       // print(cubit2.savedItems[index].content);
//       cubit2
//           .download(
//               cubit.savedItems[index].content ?? '',
//               cubit.savedItems[index].title ?? '')
//           .then((_) {
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//                 content: Text(cubit2.downloadPath)));
//       });
//       // Future.delayed(
//       //   Duration(seconds: 3),
//       //   () => Navigator.pop(context),
//       // ).then((_) {
//       //   Navigator.pop(context);
//       //   SaveRecord.done(context);
//       // });
//     },
//     icon: Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(3),
//           decoration: BoxDecoration(
//               // color:
//               //     AppColors.purple.withOpacity(0.2),
//               // border:
//               // Border.all(color: AppColors.purple)
//
//               borderRadius: BorderRadius.circular(5)),
//           child: ImageIcon(
//             color: AppColors.blue, size: 25,
//             const AssetImage(
//               'assets/icons/download.png',
//             ),
//             // color: Colors.white,
//           ),
//         ),
//         SizedBox(
//           height: 5.h,
//         ),
//         Container(
//           child: Text(
//             softWrap: true,
//             LocaleKeys.download.tr(),
//             style: TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold),
//           ),
//         ),
//       ],
//     )),
// IconButton(
//     onPressed: () {
//       cubit2.share(
//           cubit.savedItems[index].content ?? '');
//     },
//     icon: Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(3),
//           decoration: BoxDecoration(
//               /* border:*/
//               // Border.all(color: AppColors.blue),
//               borderRadius: BorderRadius.circular(5)),
//           child: ImageIcon(
//             const AssetImage(
//                 'assets/icons/share.png'),
//             color: AppColors.purple,
//           ),
//         ),
//         SizedBox(
//           height: 5.h,
//         ),
//         Text(
//           LocaleKeys.share.tr(),
//           style: TextStyle(
//               color: Colors.black,
//               fontWeight: FontWeight.bold),
//         ),
//       ],
//     )),
// IconButton(
//     onPressed: () async {
//       await Clipboard.setData(ClipboardData(
//         text: cubit.savedItems[index].content ?? '',
//       )).then((_) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: CostemSnackBar.snackBar(context),
//             clipBehavior: Clip.antiAlias,
//             backgroundColor: Colors.transparent,
//           ),
//         );
//       });
//     },
//     icon: Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(3),
//           decoration: BoxDecoration(
//               /* border:*/
//               // Border.all(color: AppColors.blue),
//               borderRadius: BorderRadius.circular(5)),
//           child: const Icon(Icons.copy),
//         ),
//         SizedBox(
//           height: 5.h,
//         ),
//         Text(
//           LocaleKeys.copy.tr(),
//           style: TextStyle(
//               color: Colors.black,
//               fontWeight: FontWeight.bold),
//         ),
//       ],
//     )),
// // IconButton(
// //     onPressed: () async {
// //       ApiCubit.get(context).convertAudioWithOpenApi(
// //           cubit.savedItems[index].content ?? '',
// //           cubit.savedItems[index].title ?? '');
// //     },
// //     icon: Column(
// //       children: [
// //         Container(
// //           padding: const EdgeInsets.all(3),
// //           decoration: BoxDecoration(
// //               /* border:*/
// //               // Border.all(color: AppColors.blue),
// //               borderRadius: BorderRadius.circular(5)),
// //           child: ImageIcon(
// //               AssetImage('assets/icons/ai.png')),
// //         ),
// //         SizedBox(
// //           height: 5.h,
// //         ),
// //         Container(
// //           width: 50,
// //           child: Text(
// //             softWrap: true,
// //             LocaleKeys.ai.tr(),
// //             style: TextStyle(
// //                 color: Colors.black,
// //                 overflow: TextOverflow.visible,
// //                 fontSize: 8.sp,
// //                 fontWeight: FontWeight.bold),
// //           ),
// //         ),
// //       ],
// //     )),
// class TranslatorScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.yellow[200],
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               Text(
//                 'Translator',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 20),
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: TextField(
//                   decoration: InputDecoration(
//                     hintText: 'Enter text to translate',
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.all(16),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Container(
//                 height: 120,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               Spacer(),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   _buildButton(Icons.edit, 'Write', Colors.black),
//                   _buildButton(Icons.mic, 'Record', Colors.yellow[700]!),
//                   _buildButton(
//                       Icons.document_scanner, 'Scan', Colors.yellow[700]!),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
