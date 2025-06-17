import 'package:flutter/material.dart';
import 'screens/predict_screen.dart';

void main() {
  runApp(const DescribeVisionApp());
}

class DescribeVisionApp extends StatelessWidget {
  const DescribeVisionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DescribeVision',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PredictScreen(),
    );
  }
}
