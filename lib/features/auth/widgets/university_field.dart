import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';

class UniversityField extends StatelessWidget {
  const UniversityField({super.key, this.value, this.onChanged, this.error});

  final String? value;
  final ValueChanged<String?>? onChanged;
  final String? error;

  static const List<String> _almatyUniversities = [
    'Narxoz University',
    'SDU University',
    'KBTU',
    'Al-Farabi KazNU',
    'Satbayev University',
    'AlmaU',
    'KIMEP University',
    'AUPET',
    'Turan University',
    'Caspian University',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'University',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          margin: EdgeInsets.only(bottom: error != null ? 6 : 24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.inputBorder),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              prefixIcon: Icon(
                Icons.school_outlined,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ),
            hint: const Text(
              'Select university',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            icon: const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.textSecondary,
                size: 32,
              ),
            ),
            isExpanded: true,
            items: _almatyUniversities
                .map(
                  (university) => DropdownMenuItem<String>(
                    value: university,
                    child: Text(university),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 4),
            child: Text(
              error!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
                height: 1.2,
              ),
            ),
          ),
      ],
    );
  }
}
