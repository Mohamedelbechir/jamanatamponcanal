import 'package:flutter/material.dart';

buildTag(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
    margin: const EdgeInsets.only(right: 5, bottom: 8),
    decoration: BoxDecoration(
      color: Colors.grey,
      borderRadius: BorderRadius.circular(5),
    ),
    child: Text(
      text,
      style: const TextStyle(color: Colors.white),
    ),
  );
}
