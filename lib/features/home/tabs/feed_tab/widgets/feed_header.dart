import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';
import 'my_filter_chip.dart';

class FeedHeader extends StatefulWidget {
  const FeedHeader({super.key});

  @override
  State<FeedHeader> createState() => _FeedHeaderState();
}

class _FeedHeaderState extends State<FeedHeader> {
  final filterChips = [
    {"title": "project", "isSelected": true},
    {"title": "person", "isSelected": true},
    {"title": "team", "isSelected": true},
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SliverAppBar(
      expandedHeight: 250.0,
      floating: false,
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: isDarkMode
          ? AppColors.darkSurface
          : AppColors.primaryBlue,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: isDarkMode ? AppColors.darkSurface : AppColors.primaryBlue,
          child: Padding(
            padding: EdgeInsets.all(16).copyWith(top: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TeamUp Almaty',
                      style: AppTextStyles.whiteHeadingLarge,
                    ),
                    Text(
                      'Find your dream team',
                      style: AppTextStyles.whiteSubtle,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: CircleAvatar(
                    backgroundColor: isDarkMode
                        ? AppColors.darkInputBorder
                        : Colors.white24,
                    child: Icon(Icons.favorite_border, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.darkInputBorder : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text("SADASDSDADASD"),
            ),
            Container(
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.darkSurface : Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: isDarkMode
                        ? AppColors.darkInputBorder
                        : AppColors.inputBorder,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Filters
                    Row(
                      children: [
                        ...filterChips.asMap().entries.map((chip) {
                          final index = chip.key;
                          final value = chip.value;
                          final String title = value["title"] as String;
                          final bool isSelected = value["isSelected"] as bool;
                          return MyFilterChip(
                            isSelected: isSelected,
                            title: title,
                            onTap: () {
                              setState(() {
                                filterChips[index]["isSelected"] =
                                    !(filterChips[index]["isSelected"] as bool);
                              });
                            },
                          );
                        }).toList(),
                        const Spacer(),
                        //кнопка для показала модал боттом шит
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isDarkMode
                                  ? AppColors.darkInputBorder
                                  : AppColors.inputBorder,
                            ),
                            borderRadius: BorderRadius.circular(90),
                          ),
                          child: IconButton(
                            iconSize: 20,
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              Icons.filter_alt_outlined,
                              color: isDarkMode
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                            ),
                            onPressed: () {
                              _openFilters(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _openFilters(BuildContext context) {
  // Временные переменные для хранения состояния внутри модалки
  String selectedType = 'Individuals';
  List<String> selectedSkills = [];
  String? selectedEvent;
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: isDarkMode ? AppColors.darkSurface : Colors.white,
    barrierColor: Colors.black.withOpacity(0.5),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (context) {
      // StatefulBuilder позволяет обновлять UI внутри модалки без отдельного класса
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Заголовок
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Filters",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode
                            ? AppColors.darkTextPrimary
                            : Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close,
                        color: isDarkMode
                            ? AppColors.darkTextPrimary
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Секция Type
                Text(
                  "Type",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode
                        ? AppColors.darkTextPrimary
                        : Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: ['Individuals', 'Teams'].map((type) {
                    final bool isSel = selectedType == type;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => selectedType = type),
                        child: Container(
                          margin: EdgeInsets.only(
                            right: type == 'Individuals' ? 8 : 0,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSel
                                  ? Colors.blue
                                  : (isDarkMode
                                        ? AppColors.darkInputBorder
                                        : Colors.grey.shade300),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                type == 'Individuals'
                                    ? Icons.person
                                    : Icons.groups,
                                color: isSel
                                    ? Colors.blue
                                    : (isDarkMode
                                          ? AppColors.darkTextSecondary
                                          : Colors.grey),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                type,
                                style: TextStyle(
                                  color: isSel
                                      ? Colors.blue
                                      : (isDarkMode
                                            ? AppColors.darkTextPrimary
                                            : Colors.black),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                // Секция Skills
                Text(
                  "Skills",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode
                        ? AppColors.darkTextPrimary
                        : Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      [
                        'React',
                        'Python',
                        'UI/UX',
                        'TypeScript',
                        'Figma',
                        'Data Science',
                      ].map((skill) {
                        final bool isSel = selectedSkills.contains(skill);
                        return ChoiceChip(
                          label: Text(skill),
                          selected: isSel,
                          onSelected: (bool selected) {
                            setState(() {
                              selected
                                  ? selectedSkills.add(skill)
                                  : selectedSkills.remove(skill);
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          selectedColor: Colors.blue.withOpacity(0.1),
                          backgroundColor: isDarkMode
                              ? AppColors.darkSurfaceVariant
                              : Colors.white,
                          side: BorderSide(
                            color: isSel
                                ? Colors.blue
                                : (isDarkMode
                                      ? AppColors.darkInputBorder
                                      : Colors.grey.shade300),
                          ),
                        );
                      }).toList(),
                ),

                const SizedBox(height: 24),

                // Секция Event
                Text(
                  "Event",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode
                        ? AppColors.darkTextPrimary
                        : Colors.black,
                  ),
                ),
                ...[
                  {'title': 'Hackathon', 'emoji': '🏆'},
                  {'title': 'Practice', 'emoji': '📚'},
                  {'title': 'Startup', 'emoji': '🚀'},
                ].map((item) {
                  final title = "${item['emoji']} ${item['title']}";
                  return RadioListTile<String>(
                    title: Text(
                      title,
                      style: TextStyle(
                        color: isDarkMode
                            ? AppColors.darkTextPrimary
                            : Colors.black,
                      ),
                    ),
                    value: title,
                    groupValue: selectedEvent,
                    activeColor: Colors.blue,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) => setState(() => selectedEvent = val),
                  );
                }),

                const SizedBox(height: 32),

                // Кнопки Reset и Ready
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          side: BorderSide(
                            color: isDarkMode
                                ? AppColors.darkInputBorder
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          "Reset",
                          style: TextStyle(
                            color: isDarkMode
                                ? AppColors.darkTextSecondary
                                : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          print(
                            "Type: $selectedType, Skills: $selectedSkills, Event: $selectedEvent",
                          );
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A56F0),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Ready",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
