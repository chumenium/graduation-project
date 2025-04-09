import 'package:flutter/material.dart';
import '../new_post/new_consultation_screen.dart';
import '../new_post/ongoing_consultations_screen.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("相談"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "新規相談"),
            Tab(text: "相談中"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          NewConsultationScreen(),
          OngoingConsultationsScreen(),
        ],
      ),
    );
  }
}
