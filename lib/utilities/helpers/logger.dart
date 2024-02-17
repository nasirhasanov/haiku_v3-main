import 'dart:developer';

import 'package:flutter/foundation.dart';

void showLog(String message) {
  if (kDebugMode) log(message);
}
