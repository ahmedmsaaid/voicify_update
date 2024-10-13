import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:voicify/viewmodel/firebase/firebase.dart';
import 'package:voicify/viewmodel/models/item_model/item_model.dart';

import '../../cache/cache_helper.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  static HomeCubit get(context) => BlocProvider.of<HomeCubit>(context);
  // final Uri url = Uri.parse('https://t.co/R05ycJpBTj');

  int currentIndex = 0;
  List<ItemModel> savedItems = [];
  bool edit = false;
  bool lang = false;
  String dropdownValue = SharedHelper.getData("lang") == null
      ? 'en'
      : SharedHelper.getData("lang");
  bool sync = SharedHelper.getData("sync") == null
      ? false
      : SharedHelper.getData("sync");
  List<ItemModel> items = [];

  // int listItems = 1;
  List<int> l = [1, 2];
  double h = 50;
  String title = 'Title';

  Future<void> navBar(index) async {
    currentIndex = index;

    emit(PageChanged());
  }

  void editButton() {
    edit = !edit;
    emit(EditButton());
  }

  void syncFireBase() async {
    sync = !sync;

    await synceDataFireStore();

    emit(Refrish());
  }

  Future<void> launchURL(String urlString, LaunchMode mode) async {
    final Uri url = Uri.parse(urlString);
    try {
      print('Attempting to launch URL: $url');
      final canLaunch = await canLaunchUrl(url);
      print('Can launch URL: $canLaunch');

      if (canLaunch) {
        final result = await launchUrl(
          url,
          mode: mode,
        );
        print('Launch result: $result');
      } else {
        print('Cannot launch URL: $url');
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  double height(int listItems) {
    double height = 0;
    emit(Refrish());
    switch (listItems) {
      case 1:
        h = 110.0;
      case 2:
        h = 170.0;
      case 3:
        h = 150.0;
    }
    height = h;
    emit(ExpandSliverBar());
    return height;
  }

  String displayTime(DateTime time) {
    DateTime now = DateTime.now();

    if (time.year == now.year &&
        time.month == now.month &&
        time.day == now.day) {
      return DateFormat.jm().format(time);
    } else {
      return DateFormat('MM/dd/yyyy - hh:mm a').format(time);
    }
  }

  void refactorList() {
    int count = 0;
    for (ItemModel item in savedItems) {
      item.index = count;
      count += 1;
    }
  }

  void save(
    titleController,
    scribeController,
  ) {
    DateTime now = DateTime.now();
    ItemModel model = ItemModel(
        recordedTime: now,
        title: titleController.text,
        index: savedItems.length,
        content: scribeController.text);
    savedItems.add(model);
    refactorList();

    saveToCache();

    titleController.clear();

    emit(Saved());
  }

  void saveToCache() async {
    String key = await SharedHelper.getData(FirebaseKeys.email);
    try {
      List<String> itemsList = savedItems
          .map((itemModel) => jsonEncode(itemModel.toJson()))
          .toList();
      SharedHelper.saveData(key, itemsList);
      if (sync) {
        synceDataFireStore();
      }
      print(itemsList.toString());
    } on Exception catch (e) {
      debugPrint('error $e');
    }
    emit(SavedToCache());
  }

  Future<void> synceDataFireStore() async {
    String key = await SharedHelper.getData(FirebaseKeys.userId);
    for (ItemModel item in savedItems) {
      try {
        await FirebaseFirestore.instance
            .collection(FirebaseKeys.users)
            .doc(key)
            .collection("Data")
            .doc(item.title)
            .set(item.toJson());
      } on Exception catch (e) {
        print(e.toString());
      }
    }
    deleteOldDataFromFirestore();
  }

  Future<void> deleteOldDataFromFirestore() async {
    String key = await SharedHelper.getData(FirebaseKeys.userId);
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(FirebaseKeys.users)
        .doc(key)
        .collection("data")
        .get();

    List<String?> savedItemTitles =
        savedItems.map((item) => item.title).toList();

    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      if (!savedItemTitles.contains(document.id)) {
        await document.reference.delete();
      }
    }
  }

  Future<List<ItemModel>> fetchDataFromFirestore() async {
    List<ItemModel> items = [];
    String key = await SharedHelper.getData(FirebaseKeys.userId);
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(FirebaseKeys.users)
        .doc(key)
        .collection("data")
        .get();

    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      // تحويل بيانات الوثيقة إلى ItemModel
      ItemModel item =
          ItemModel.fromJson(document.data() as Map<String, dynamic>);
      items.add(item);
    }

    return items;
  }

  // Future<void> getDataFireStore() async {
  //   String key = await SharedHelper.getData(FirebaseKeys.userId);
  //   for (ItemModel item in savedItems)
  //     try {
  //       await FirebaseFirestore.instance
  //           .collection(FirebaseKeys.users)
  //           .doc(key)
  //           .collection("Data")
  //           .doc(item.title)
  //           .set(item.toJson());
  //     } on Exception catch (e) {
  //       print(e.toString());
  //     }
  // }

  Future<void> getList() async {
    print("getList");
    String key = await SharedHelper.getData(FirebaseKeys.email);
    var data = await SharedHelper.getData(key); // احصل على البيانات

    if (data == null || data.toString().isEmpty) {
      return;
    } else {
      try {
        List<String> itemsList =
            (data is List<String>) ? data : List<String>.from(data);

        if (itemsList.isNotEmpty) {
          savedItems = itemsList
              .map((item) => ItemModel.fromJson(json.decode(item)))
              .toList();
        }
        if (sync) {
          synceDataFireStore();
        }
        emit(GetData());
      } catch (e) {
        debugPrint('*******************error $e');
      }
    }
    if (sync) {
      savedItems = await fetchDataFromFirestore();
    }
  }

  void addModel(ItemModel model) {
    items.add(model);
    emit(Refrish());
  }

  void remove(int index) {
    emit(Remove());
    savedItems.removeAt(index);
    for (int i = 0; i < savedItems.length; i++) {
      savedItems[i].index != i;
    }
    saveToCache();
    emit(Removed());
  }

  void changeLang(String selectedValue) {
    {
      dropdownValue = selectedValue;
      emit(DrobDown());
    }
  }

// void refresh(int index) {
//   listItems = index;
//   emit(Refrish());
// }
}
