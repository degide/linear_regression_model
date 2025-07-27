import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  // Controllers for text fields
  final _ageController = TextEditingController();
  final _yearsTeachingController = TextEditingController();
  final _periodsPerWeekController = TextEditingController();

  // Dropdown values
  String? _gender;
  String? _highestEducation;
  String? _studentCount;
  String? _subjectLeader;

  // Result or error message
  String _result = '';

  // Loading state
  bool _isLoading = false;

  // API endpoint
  final String _apiUrl = 'https://linear-regression-model-lw2t.onrender.com/api/predict';

  // Dropdown options
  final List<String> _genderOptions = ['Male', 'Female'];
  final List<String> _educationOptions = ['A0', 'A1', 'A2'];
  final List<String> _studentCountOptions = [
    '0-10',
    '10-20',
    '20-30',
    '30-40',
    '40-50',
    '50+'
  ];
  final List<String> _subjectLeaderOptions = ['Yes', 'No'];

  // Function to make API call
  Future<void> _predict() async {
    setState(() {
      _isLoading = true;
      _result = '';
    });

    try {
      // Validate inputs
      if (_ageController.text.isEmpty ||
          _yearsTeachingController.text.isEmpty ||
          _periodsPerWeekController.text.isEmpty ||
          _gender == null ||
          _highestEducation == null ||
          _studentCount == null ||
          _subjectLeader == null) {
        throw Exception('All fields are required');
      }

      // Prepare data
      final data = {
        'age': int.parse(_ageController.text),
        'gender': _gender,
        'highest_education': _highestEducation,
        'years_teaching': int.parse(_yearsTeachingController.text),
        'student_count': _studentCount,
        'periods_per_week': int.parse(_periodsPerWeekController.text),
        'subject_leader': _subjectLeader,
      };

      // Make HTTP POST request
      final response = await http
          .post(
            Uri.parse(_apiUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        setState(() {
          _result = 'Predicted Score: ${result['predicted_score']}%';
        });
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Unknown error');
      }
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _ageController.dispose();
    _yearsTeachingController.dispose();
    _periodsPerWeekController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Predict Teacher Performance'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Enter Teacher Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _ageController,
                  decoration: InputDecoration(
                    labelText: 'Age (18-100)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  value: _gender,
                  items: _genderOptions
                      .map((option) => DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _gender = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Highest Education',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  value: _highestEducation,
                  items: _educationOptions
                      .map((option) => DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _highestEducation = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _yearsTeachingController,
                  decoration: InputDecoration(
                    labelText: 'Years of Teaching Experience',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Number of Students in Classes',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  value: _studentCount,
                  items: _studentCountOptions
                      .map((option) => DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _studentCount = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _periodsPerWeekController,
                  decoration: InputDecoration(
                    labelText: 'Periods per Week (0-168)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Subject Leader',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  value: _subjectLeader,
                  items: _subjectLeaderOptions
                      .map((option) => DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _subjectLeader = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _predict,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Predict'),
                ),
                const SizedBox(height: 20),
                Text(
                  _result,
                  style: TextStyle(
                    fontSize: 16,
                    color: _result.startsWith('Error') ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
