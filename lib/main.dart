import 'package:flutter/material.dart';
import 'package:media_flutter_app/screens/widgets/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Media',
      theme: ThemeData(
        brightness: Brightness.dark
      ),
      home: const HomeScreen(),
      
    );
  }
}
