import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class EmptyPage extends StatelessWidget {
  EmptyPage({super.key});
  final logic = Get.put(EmptyPageLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          // Wrap with SingleChildScrollView
          child: Column(
            mainAxisSize: MainAxisSize.min, // Limit the size of the Column
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/empty.jpg',
                height: 200,
                width: 200,
              ),
              SizedBox(height: 20),
              Text(
                'No Items Found',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Try adding some items to get started!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Action to add items or navigate
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),
                child: Text('Add Items'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
