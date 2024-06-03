import 'dart:ui';

import 'package:flutter/material.dart';

class ScreenQuery{

   static Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

   static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

   static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}