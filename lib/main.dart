import 'package:flutter/material.dart';
import 'package:flutterapp/bottom_nav.dart';
import 'package:flutterapp/login.dart';
import 'package:flutterapp/account_information.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final List<AccountInformation> accounts = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Login());
  }
}
