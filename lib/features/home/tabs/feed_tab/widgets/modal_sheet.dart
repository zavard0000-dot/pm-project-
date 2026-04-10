import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';

class FilterSheetWidget extends StatefulWidget {
  const FilterSheetWidget({super.key});

  @override
  State<FilterSheetWidget> createState() => _FilterSheetWidgetState();
}

class _FilterSheetWidgetState extends State<FilterSheetWidget> {
  String selectedType = 'Individuals';
  List<String> selectedSkills = [];
  String? selectedEvent;

  final List<String> skills = [
    'React',
    'Python',
    'UI/UX',
    'TypeScript',
    'Figma',
    'Data Science',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Filters", style: AppTextStyles.headingLarge),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Секция Type
          const Text("Type", style: AppTextStyles.headingSmall),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildTypeButton(
                "Individuals",
                Icons.person,
                selectedType == "Individuals",
              ),
              const SizedBox(width: 12),
              _buildTypeButton("Teams", Icons.group, selectedType == "Teams"),
            ],
          ),
          const SizedBox(height: 24),

          // Секция Skills
          const Text("Skills", style: AppTextStyles.headingSmall),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills.map((skill) => _buildFilterChip(skill)).toList(),
          ),
          const SizedBox(height: 24),

          // Секция Event
          const Text("Event", style: AppTextStyles.headingSmall),
          _buildRadioItem("🏆 Hackathon"),
          _buildRadioItem("📚 Practice"),
          _buildRadioItem("🚀 Startup"),
          const SizedBox(height: 32),

          // Кнопки управления
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child:  Text(
                    "Reset",
                    style: AppTextStyles.button.copyWith(color: Colors.black54),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text("Ready", style: AppTextStyles.button),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Вспомогательный виджет для кнопок Type
  Widget _buildTypeButton(String label, IconData icon, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedType = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.grey.shade300,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.blue : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Вспомогательный виджет для тегов Skills
  Widget _buildFilterChip(String label) {
    final bool isSelected = selectedSkills.contains(label);
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          selected ? selectedSkills.add(label) : selectedSkills.remove(label);
        });
      },
      backgroundColor: Colors.white,
      selectedColor: Colors.blue.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }

  // Вспомогательный виджет для Radio-списка
  Widget _buildRadioItem(String title) {
    return RadioListTile<String>(
      title: Text(title),
      value: title,
      groupValue: selectedEvent,
      contentPadding: EdgeInsets.zero,
      onChanged: (val) => setState(() => selectedEvent = val),
    );
  }
}
