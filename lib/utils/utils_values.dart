import 'package:flutter/material.dart';

const modalTopBorderRadius = BorderRadius.only(
  topLeft: Radius.circular(10),
  topRight: Radius.circular(10),
);

class AppInputDecoration extends InputDecoration {
  AppInputDecoration({String? hintText, IconData? iconData, Widget? suffixIcon})
      : super(
          contentPadding: const EdgeInsets.all(15),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          hintText: hintText,
          prefixIcon: iconData == null ? null : Icon(iconData),
          suffixIcon: suffixIcon,
        );
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
