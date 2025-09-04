import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String message;
  const DetailScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Screen")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // go back to Home
              },
              child: const Text("Go Back"),
            ),
          ],
        ),
      ),
    );
  }
}
