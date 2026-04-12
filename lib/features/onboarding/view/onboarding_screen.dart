import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teamup/router.dart';

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  final List<OnboardingPage> pages = [
    OnboardingPage(
      title: 'Найди свою команду',
      description:
          'Подбирай участников для квалатонов, учебных практик и стартапов',
      icon: Icons.group,
      color: Colors.blue,
    ),
    OnboardingPage(
      title: 'Фильтруй по навыкам',
      description:
          'Ищи специалистов с нужными технологиями и опытом для своего проекта',
      icon: Icons.search,
      color: Colors.pink,
    ),
    OnboardingPage(
      title: 'Выбирай формат',
      description:
          'Краткосрочные проекты для квалатонов или долгосрочное сотрудничество',
      icon: Icons.flash_on,
      color: Colors.orange,
    ),
    OnboardingPage(
      title: 'Начни сейчас',
      description:
          'Создай профиль и публикуй объявления в поиске участников команды',
      icon: Icons.play_arrow,
      color: Colors.teal,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: pages.map((page) => _buildPage(page)).toList(),
          ),
          // Skip button
          Positioned(
            top: 16,
            right: 16,
            child: SafeArea(
              child: TextButton(
                onPressed: () {
                  context.go('/login');
                },
                child: const Text('Пропустить'),
              ),
            ),
          ),
          // Indicator dots and next button
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Dots indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      pages.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == index
                              ? pages[index].color
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Next button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: pages[_currentIndex].color,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (_currentIndex == pages.length - 1) {
                          context.go(AppRoutes.login);
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Text(
                        _currentIndex == pages.length - 1 ? 'Начать' : 'Далее',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with glow effect
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: page.color.withOpacity(0.1),
              ),
              child: Center(
                child: Icon(page.icon, size: 80, color: page.color),
              ),
            ),
            const SizedBox(height: 48),
            // Title
            Text(
              page.title,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                page.description,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
