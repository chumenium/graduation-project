import 'package:flutter/material.dart';
import '../../features/home/pages/home_screen.dart';
import '../../features/home/pages/solved_screen.dart';
import '../../features/home/pages/post_screen.dart';
import '../../features/home/pages/payment_screen.dart';
import '../../features/home/pages/mypage_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeScreen(),
      const SolvedScreen(),
      const PostScreen(),
      const PaymentScreen(),
      const MypageScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          debugPrint("Tapped index: $index");
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