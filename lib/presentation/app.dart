import 'package:flutter/material.dart';

import '../utilities/constants/app_themes.dart';
import '../utilities/helpers/pager.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Haiku',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.appTheme,
      home: Pager.home,
    );
  }
}
