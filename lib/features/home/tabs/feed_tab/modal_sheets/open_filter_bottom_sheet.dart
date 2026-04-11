import 'package:flutter/material.dart';
import 'package:teamup/constances.dart';
import 'package:teamup/theme.dart';

void OpenFilterBottomSheet(BuildContext context) {
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
                  children: AVAILABLE_SKILLS.map((skill) {
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
