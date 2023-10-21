import 'package:flutter/material.dart';

void safeTry(VoidCallback action) {
  try {
    action();
  } catch (e) {
    debugPrint("safeTry wins !!!");
  }
}
