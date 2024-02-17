import 'package:flutter/material.dart';

extension ScrollControllerExtensions on ScrollController {
  bool get isLastItem => position.pixels == position.maxScrollExtent;
}
