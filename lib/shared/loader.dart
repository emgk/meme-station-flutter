// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

Widget screenLoader(BuildContext context) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.8,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.orangeAccent),
          strokeWidth: 5.0,
        ),
      ),
    ),
  );
}
