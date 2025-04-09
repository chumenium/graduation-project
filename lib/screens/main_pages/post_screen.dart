import 'package:flutter/material.dart';
import '../new_post/new_consultation_screen.dart';

<<<<<<< HEAD
class PostScreen extends StatelessWidget {
  const PostScreen({Key? key}) : super(key: key);
=======
class PostScreen extends StatefulWidget {
  const PostScreen({super.key});
>>>>>>> 624ad1f (test)

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
