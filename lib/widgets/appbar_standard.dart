import 'package:flutter/material.dart';

class AppBarStandard {
  static AppBar stdAppBar() {
    return AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Instagram',
            style: TextStyle(
                color: Colors.black, fontFamily: 'Billabong', fontSize: 35.0),
          ),
        ));
  }
}
