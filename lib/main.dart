import 'package:flutter/material.dart';
import 'package:flutter_application_4/pages/search_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '검색 기능',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const SearchPage(),
    );
  }
}
