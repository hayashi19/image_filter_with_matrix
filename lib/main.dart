import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_filter_with_matrix/pages/home_page.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Image Filter With Matrix',
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}