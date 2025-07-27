import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SET Teacher Performance Predictor'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to the Teacher Performance Predictor',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Use this app to predict teacher performance based on various parameters.\nNavigate to the Predict tab to start.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Image.network(
                'https://via.placeholder.com/150',
                width: 150,
                height: 150,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, size: 150),
              ),
            ],
          ),
        ),
      ),
    );
  }
}