import 'package:dart_openai/dart_openai.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:voicify/core/serveses/services_locator.dart';
import 'package:voicify/model/data/cache/cache_helper.dart';
import 'package:voicify/my_app.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

void main() async {
  OpenAI.apiKey =
      "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";
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  ServicesLocator().init();
  await SharedHelper.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        // <-- change the path of the translation files
        fallbackLocale: const Locale('en'),
        child: const MyApp()),
  );
}
//  SHA1 :./gradlew signingReport
/// To Generate Local Translation Keys File
///
///
/// flutter pub run easy_localization:generate -S assets/translations -O lib/translation -o locate_keys.g.dart -f keys
