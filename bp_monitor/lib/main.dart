// main.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

/// The main application widget.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Blood Pressure Classifier',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false, // Remove debug banner
      home: InputScreen(),
    );
  }
}

/// Widget for inputting blood pressure data.
class InputScreen extends StatelessWidget {
  final TextEditingController systolicController = TextEditingController();
  final TextEditingController diastolicController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Pressure Classifier'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: systolicController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Systolic',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: diastolicController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Diastolic',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (isValidData(systolicController.text, diastolicController.text)) {
                  double systolic = double.tryParse(systolicController.text) ?? 0;
                  double diastolic = double.tryParse(diastolicController.text) ?? 0;
                  Get.to(() => InfoScreen(systolic, diastolic));
                } else {
                  Get.snackbar('Invalid Data', 'Please enter valid blood pressure values.');
                }
              },
              child: Text('Show Info'),
            ),
          ],
        ),
      ),
    );
  }

  /// Checks if the entered blood pressure data is valid.
  bool isValidData(String systolic, String diastolic) {
    return systolic.isNotEmpty &&
        diastolic.isNotEmpty &&
        double.tryParse(systolic) != null &&
        double.tryParse(diastolic) != null;
  }
}

/// Widget for displaying blood pressure category information.
class InfoScreen extends StatelessWidget {
  final double systolic;
  final double diastolic;

  InfoScreen(this.systolic, this.diastolic);

  @override
  Widget build(BuildContext context) {
    String category = determineCategory(systolic, diastolic);

    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Pressure Info'),
      ),
      body: Center(
        child: Text(
          'Category: $category',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  /// Determines the blood pressure category based on systolic and diastolic values.
  String determineCategory(double systolic, double diastolic) {
    if (systolic < 90 && diastolic < 60) {
      return 'Low Blood Pressure';
    } else if (systolic >= 90 && systolic <= 120 && diastolic >= 60 && diastolic <= 80) {
      return 'Normal';
    } else if (systolic > 120 && systolic <= 129 && diastolic >= 60 && diastolic <= 80) {
      return 'Elevated';
    } else if (systolic >= 130 && systolic <= 139 && diastolic >= 80 && diastolic <= 89) {
      return 'High Blood Pressure (Stage 1)';
    } else if (systolic >= 140 && diastolic >= 90) {
      return 'High Blood Pressure (Stage 2)';
    } else {
      return 'Unclassified';
    }
  }
}
