import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haiku/utilities/constants/app_themes.dart';
import 'package:haiku/utilities/enums/notification_type_enum.dart';
import 'package:hive/hive.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:path_provider/path_provider.dart';

import 'data/data_sources/remote/firebase/notifications/notification_helper.dart';
import 'locator.dart';
import 'presentation/app.dart';
import 'utilities/constants/app_keys.dart';
import 'utilities/helpers/app_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setupLocator();
  Bloc.observer = AppBlocObserver();

  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  await Hive.openBox(AppKeys.locationBox);
  await Hive.openBox(AppKeys.userDataBox);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  AppThemes.setSystemUIOverlayStyle();
  // Initialize notifications
  final notificationHelper = NotificationHelper();
  await notificationHelper.initialize();
  runApp(const MyApp());
}
