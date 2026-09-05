import 'package:flutter/material.dart';

class DetailedHabitScreen extends StatelessWidget {
  const DetailedHabitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Привычка'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_rounded),
          ),
        ],
      ),
    );
  }
}
