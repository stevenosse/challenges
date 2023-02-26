import 'package:flutter/material.dart';
import 'package:simple_rating_app/src/ui/home_screen.dart';

class SimpleRatingApp extends StatelessWidget {
  const SimpleRatingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Rating App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
