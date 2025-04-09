import 'package:flutter/material.dart';
import '../post/new_consultation_screen.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("新規相談"),
      ),
      body: NewConsultationScreen(), // ← const を外す
    );
  }
}
