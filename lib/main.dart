import 'package:flutter/material.dart';
import 'package:micato/views/home_screen.dart';

void main() {
  runApp(const Micato());
}

class Micato extends StatelessWidget {
  const Micato({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Micato',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
      ),
      home: const HomeScreen(),
    );
  }
}
