// ==========================================
// 📂 screens/main_screen.dart (Навигация)
// ==========================================
import 'package:flutter/material.dart';
import 'package:teamup/features/home/tabs/create_tab/tab_view/creat_tab_screen.dart';
import 'package:teamup/theme.dart';
import 'package:teamup/features/home/tabs/tabs.dart';

class MainScreen extends StatefulWidget {
  final int initialTab;

  const MainScreen({Key? key, this.initialTab = 0}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  final List<Widget> _screens = [
    const FeedTabScreen(),
    const Center(child: Text('Search Screen (WIP)')),
    const CreateTabScreen(),
    const Center(child: Text('Notifications Screen (WIP)')),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final mainColor = (isDarkMode ? AppColors.darkBlue : AppColors.primaryBlue);

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index != 2) setState(() => _currentIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: mainColor,
        unselectedItemColor: AppColors.textSecondary,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Главная',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Поиск'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add, color: Colors.transparent),
            label: '',
          ), // Пустое место для FAB
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Уведомления',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Профиль',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _currentIndex = 2),
        backgroundColor: mainColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
