import 'package:flutter/material.dart';
import 'package:jamanacanal/models/database.dart';

void safeTry(VoidCallback action) {
  try {
    action();
  } catch (e) {
    debugPrint("safeTry wins !!!");
  }
}

buildBouquetItemForDropwdown(List<Bouquet> bouquets) {
  return bouquets.map((bouquet) {
    return DropdownMenuItem<Bouquet>(
      value: bouquet,
      child: Text(bouquet.name),
    );
  }).toList();
}
