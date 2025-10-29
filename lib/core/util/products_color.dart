

import 'package:flutter/material.dart';

class ProductsColor {

    List<AppColor> colors = [
    AppColor(name: "Red", color: Color(0xffFF0000)), 
    AppColor(name: "Blue", color: Color(0xff0000FF)),
    AppColor(name: "Green", color: Color(0xff00FF00)),
    AppColor(name: "Black", color: Color(0xff000000)),
    AppColor(name: "White", color: Color(0xffFFFFFF)),
    AppColor(name: "Silver", color: Color(0xffC0C0C0)),
    AppColor(name: "Gold", color: Color(0xffD4AF37)),
    AppColor(name: "Other", color: Color(0xff808080)),

  ];

 Color getColors(String color) {
try {
  return colors.firstWhere((element) => element.name.toLowerCase() == color.toLowerCase()).color;
} catch (e) {
  return  Color(0xff808080);
}
 }

List<String> listOfColors(List<String> colorsName) {
  List<AppColor> item = [];
 colors.map((element) => colorsName.contains(element.name) ? item.add(element) : null);
  return item.map((e) => e.name).toList();
}

}

class AppColor{
  final String name;
  final Color color;

  AppColor({required this.name, required this.color});

}