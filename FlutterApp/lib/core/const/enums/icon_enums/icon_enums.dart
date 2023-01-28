import 'package:flutter/material.dart';

enum IconEnums { ic_kcal }

extension IconEnumsExtension on IconEnums {
  String get toPath => "assets/icon/$name.png";
  Image get toImage => Image.asset(
        toPath,
        height: 40,
      );
}
