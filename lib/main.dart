import 'package:flutter/material.dart';
import 'package:flutterapp/bottom_nav.dart';
import 'package:flutterapp/select_note.dart';
import 'login.dart';
import 'account_information.dart';

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
