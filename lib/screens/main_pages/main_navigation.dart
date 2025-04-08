import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'solved_screen.dart';
import 'post_screen.dart';
import 'payment_screen.dart';
import 'mypage_screen.dart';


class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const SolvedScreen(),
    const PostScreen(),
    const PaymentScreen(),
    const MypageScreen(), // ← 忘れてないかチェック
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: '解決したい'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: '相談'),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: '支払い'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'マイページ'),
        ],
      ),
    );
  }
}