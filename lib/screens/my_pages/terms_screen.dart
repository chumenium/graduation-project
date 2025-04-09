import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  String _termsText = "読み込み中...";

  @override
  void initState() {
    super.initState();
    _loadTerms();
  }

  Future<void> _loadTerms() async {
    try {
      final text = await rootBundle.loadString('assets/利用規約.txt');
      setState(() {
        _termsText = text;
      });
    } catch (e) {
      setState(() {
        _termsText = "利用規約の読み込みに失敗しました。";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("利用規約")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            _termsText,
            style: const TextStyle(fontSize: 14, height: 1.6),
          ),
        ),
      ),
    );
  }
}
