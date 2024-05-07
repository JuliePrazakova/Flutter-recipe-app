import 'package:flutter/material.dart';
import 'pages/main_page.dart';
import 'pages/app_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        appBar:  MyAppBar(),
        body:  MainPage(),
      ),
    );
  }
}
