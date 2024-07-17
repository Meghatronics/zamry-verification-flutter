import 'package:flutter/material.dart';

Widget buildShimmerContainer(double height) {
  return Container(
    height: height,
    decoration: const BoxDecoration(
      color: Color(0xFFFBFCFB),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  );
}