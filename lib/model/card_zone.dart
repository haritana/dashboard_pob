import 'package:flutter/material.dart';

class CardZonaModel {
  final String value;
  final String title;
  final Color? color;

  const CardZonaModel({
    required this.value,
    required this.title,
    this.color,
  });
}
