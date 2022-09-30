import 'package:flutter/material.dart';
import 'package:image_filter_with_matrix/pages/editor_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: EditorPage());
  }
}
