import 'package:flutter/material.dart';
import 'package:my_first_project/screen/about_screen.dart';
import 'package:my_first_project/screen/add_screen.dart';
import 'package:my_first_project/screen/contact_screen.dart';
import 'package:my_first_project/screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/about': (context) => AboutScreen(),
        '/contact': (context) => ContactScreen(),
        '/add_screen': (context) => AddScreen()
      },
    );
  }
}
