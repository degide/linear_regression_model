import 'package:flutter/material.dart';
import 'package:flutter_app/screens/main_screen.dart';

void main() {
  runApp(const TeacherPerformanceApp());
}

class TeacherPerformanceApp extends StatelessWidget {
  const TeacherPerformanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SET Teacher Performance Prediction',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
          headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        ),
        //primary: #002C68
        primaryColor: const Color.fromARGB(255, 0, 91, 218),
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
