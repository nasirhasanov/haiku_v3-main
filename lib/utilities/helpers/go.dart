import 'package:flutter/material.dart';

class Go {
  Go._();

  static MaterialPageRoute _pageRoute(Widget widget) =>
      MaterialPageRoute(builder: (_) => widget);

  static void to(BuildContext context, Widget widget) =>
      Navigator.push(context, _pageRoute(widget));

  static void replace(BuildContext context, Widget widget) =>
      Navigator.pushReplacement(context, _pageRoute(widget));

  static void back(BuildContext context) => Navigator.pop(context);

  static void closeAll(BuildContext context, Widget widget) =>
      Navigator.pushAndRemoveUntil(
          context, _pageRoute(widget), (route) => false);
}
