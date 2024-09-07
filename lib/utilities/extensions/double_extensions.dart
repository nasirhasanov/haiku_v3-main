import 'package:flutter/material.dart';

extension DoubleExtensions on num {
  SizedBox get h => SizedBox(height: toDouble());
  SizedBox get w => SizedBox(height: toDouble());
}