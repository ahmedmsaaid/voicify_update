import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:voicify/model/data/cubits/api_cubit/api_cubit.dart';
import 'package:voicify/model/data/cubits/auth_cubit/auth_cubit.dart';
import 'package:voicify/model/data/cubits/data_cubit/data_cubit.dart';
import 'package:voicify/model/data/cubits/home_cubit/home_cubit.dart';

import '../api/dio_consumer.dart';

final sl = GetIt.instance;

class ServicesLocator {
  void init() {
    ///Cubits
    sl.registerFactory(() => ApiCubit(sl()));
    sl.registerFactory(() => HomeCubit());
    sl.registerFactory(() => AuthCubit());
    sl.registerFactory(() => DataCubit(sl()));

    ///api
    sl.registerLazySingleton(() => DioConsumer(dio: Dio()));
  }
}
