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
  final _ageController = TextEditingController();
  final _yearsTeachingController = TextEditingController();
  final _periodsPerWeekController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _gender;
  String? _highestEducation;
  String? _studentCount;
  String? _subjectLeader;
  String _result = '';
  bool _isLoading = false;

  final List<String> _genderOptions = ['Male', 'Female'];
  final List<String> _educationOptions = ['A0', 'A1', 'A2'];
  final List<String> _studentCountOptions = [
    '0-10',
    '10-20',
    '20-30',
    '30-40',
    '40-50',
    '50+',
  ];
  final List<String> _subjectLeaderOptions = ['Yes', 'No'];

  Future<void> _predict() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }
    setState(() {
      _isLoading = true;
      _result = '';
    });

    try {
      final data = {
        'age': int.parse(_ageController.text),
        'gender': _gender,
        'highest_education': _highestEducation,
        'years_teaching': int.parse(_yearsTeachingController.text),
        'student_count': _studentCount,
        'periods_per_week': int.parse(_periodsPerWeekController.text),
        'subject_leader': _subjectLeader,
      };

      final response = await http
          .post(
            Uri.parse(
              'https://linear-regression-model-lw2t.onrender.com/api/predict',
            ),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if(context.mounted) {
          setState(() {
            _result = 'Predicted Score: ${result['predicted_score']}%';
          });
        }
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Something went wrong');
      }
    } catch (e) {
      if(context.mounted) {
        setState(() {
          _result = 'Error: $e';
        });
      }
    } finally {
      if(context.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _ageController.dispose();
    _yearsTeachingController.dispose();
    _periodsPerWeekController.dispose();
    _formKey.currentState?.dispose();
    _result = '';
    _isLoading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prediction'),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Enter Teacher Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _ageController,
                    decoration: InputDecoration(
                      labelText: 'Age (18-100)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter age';
                      }
                      final age = int.tryParse(value);
                      if (age == null || age < 18 || age > 100) {
                        return 'Age must be between 18 and 100';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    value: _gender,
                    items:
                        _genderOptions
                            .map(
                              (option) => DropdownMenuItem(
                                value: option,
                                child: Text(option),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select gender';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Highest Education',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    value: _highestEducation,
                    items:
                        _educationOptions
                            .map(
                              (option) => DropdownMenuItem(
                                value: option,
                                child: Text(option),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        _highestEducation = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select highest education';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _yearsTeachingController,
                    decoration: InputDecoration(
                      labelText: 'Years of Teaching Experience',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter years of teaching experience';
                      }
                      final years = int.tryParse(value);
                      if (years == null || years < 0) {
                        return 'Years of teaching must be a positive number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Number of Students in Classes',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    value: _studentCount,
                    items:
                        _studentCountOptions
                            .map(
                              (option) => DropdownMenuItem(
                                value: option,
                                child: Text(option),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        _studentCount = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select number of students';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _periodsPerWeekController,
                    decoration: InputDecoration(
                      labelText: 'Periods per Week (0-168)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter periods per week';
                      }
                      final periods = int.tryParse(value);
                      if (periods == null || periods < 0 || periods > 168) {
                        return 'Periods must be between 0 and 168';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Subject Leader',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    value: _subjectLeader,
                    items:
                        _subjectLeaderOptions
                            .map(
                              (option) => DropdownMenuItem(
                                value: option,
                                child: Text(option),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        _subjectLeader = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select subject leader status';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _predict,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child:
                        _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Predict'),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Result",
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _result,
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            _result.startsWith('Error')
                                ? Colors.red
                                : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
