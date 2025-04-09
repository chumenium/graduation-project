import 'package:flutter/material.dart';

class ListEmptyMessage extends StatelessWidget {
  final String message;

  const ListEmptyMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Text(
          message,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}