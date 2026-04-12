import 'package:flutter/material.dart';
import 'package:teamup/constances.dart';
import 'package:teamup/theme.dart';

void openFilterBottomSheet(
  BuildContext context, {
  required List<String> currentTypes,
  required List<String> currentSkills,
  required List<String> currentEventTypes,
  required Future<void> Function(
    List<String> types,
    List<String> skills,
    List<String> eventTypes,
  )
  onApplyFilters,
}) {
  // Временные переменные для хранения состояния внутри модалки
  List<String> selectedTypes = List.from(currentTypes);
  List<String> selectedSkills = List.from(currentSkills);
  List<String> selectedEventTypes = List.from(currentEventTypes);
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    backgroundColor: isDarkMode ? AppColors.darkSurface : Colors.white,
    barrierColor: Colors.black.withOpacity(0.5),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (context) {
      // StatefulBuilder позволяет обновлять UI внутри модалки без отдельного класса
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return DraggableScrollableSheet(
            expand: false,
            maxChildSize: 0.9,
            initialChildSize: 0.7,
            builder: (context, scrollController) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Column(
                  children: [
                    // Заголовок (не скроллится)
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

                    // Контент скроллится
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        children: [
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
                            children: ['person', 'project', 'team'].map((type) {
                              final bool isSel = selectedTypes.contains(type);
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() {
                                    if (isSel) {
                                      selectedTypes.remove(type);
                                    } else {
                                      selectedTypes.add(type);
                                    }
                                  }),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      right: type != 'project' ? 8 : 0,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
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
                                    child: Center(
                                      child: Text(
                                        type[0].toUpperCase() +
                                            type.substring(1),
                                        style: TextStyle(
                                          color: isSel
                                              ? Colors.blue
                                              : (isDarkMode
                                                    ? AppColors.darkTextPrimary
                                                    : Colors.black),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
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
                          ...EVENT_TYPES.map((item) {
                            final title = item['title'] as String;
                            final emoji = item['emoji'] as String;
                            return CheckboxListTile(
                              title: Text(
                                "$emoji ${title[0].toUpperCase()}${title.substring(1)}",
                                style: TextStyle(
                                  color: isDarkMode
                                      ? AppColors.darkTextPrimary
                                      : Colors.black,
                                ),
                              ),
                              value: selectedEventTypes.contains(title),
                              activeColor: Colors.blue,
                              contentPadding: EdgeInsets.zero,
                              onChanged: (val) => setState(() {
                                if (val == true) {
                                  selectedEventTypes.add(title);
                                } else {
                                  selectedEventTypes.remove(title);
                                }
                              }),
                            );
                          }),

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),

                    // Кнопки (не скроллятся)
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              selectedTypes = ['person', 'team', 'project'];
                              selectedSkills = [];
                              selectedEventTypes = [];
                              setState(() {});
                            },
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
                            onPressed: () async {
                              print(
                                "Types: $selectedTypes, Skills: $selectedSkills, Events: $selectedEventTypes",
                              );
                              await onApplyFilters(
                                selectedTypes,
                                selectedSkills,
                                selectedEventTypes,
                              );
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
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
    },
  );
}
