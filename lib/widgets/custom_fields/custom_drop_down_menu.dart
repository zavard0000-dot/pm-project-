import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';

class CustomDropDownMenu extends StatefulWidget {
  const CustomDropDownMenu({
    super.key,
    this.title = null,
    this.error = null,
    this.value,
    this.onChanged,
    required this.dropDownMenuEntries,
    this.isRequired = false,
  });

  final String? title;
  final String? error;
  final String? value;
  final ValueChanged<String?>? onChanged;
  final List<DropdownMenuEntry<String>> dropDownMenuEntries;
  final bool isRequired;

  @override
  State<CustomDropDownMenu> createState() => _CustomDropDownMenuState();
}

class _CustomDropDownMenuState extends State<CustomDropDownMenu> {
  // final _dropDownEntries = [
  //   DropdownMenuEntry(value: 'narxoz', label: 'Narxoz University'),
  //   DropdownMenuEntry(value: 'sdu', label: 'SDU University'),
  //   DropdownMenuEntry(value: 'kbtu', label: 'KBTU'),
  //   DropdownMenuEntry(value: "kaznu", label: "Al-Farabi KazNU"),
  // ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //title
        if (widget.title != null)
          Container(
            child: Row(
              children: [
                Text(
                  widget.title!,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
                if (widget.isRequired)
                  Text(
                    ' *',
                    style: AppTextStyles.labelLarge.copyWith(color: Colors.red),
                  ),
              ],
            ),
            margin: EdgeInsets.only(bottom: 8),
          ),
        Container(
          //внешний отсут чье значение зависит от наличие ошибки у поле
          margin: EdgeInsets.only(bottom: widget.error != null ? 6 : 24),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.darkSurface : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDarkMode
                  ? AppColors.darkInputBorder
                  : AppColors.inputBorder,
            ),
          ),
          child: DropdownMenu<String>(
            key: ValueKey(widget.value),
            width: double.infinity,
            dropdownMenuEntries: widget.dropDownMenuEntries,
            initialSelection: widget.value,
            hintText: "Select University",
            textStyle: AppTextStyles.bodyMedium.copyWith(
              color: isDarkMode
                  ? AppColors.darkTextPrimary
                  : AppColors.textPrimary,
            ),
            menuStyle: MenuStyle(
              backgroundColor: WidgetStatePropertyAll(
                isDarkMode ? AppColors.darkSurface : AppColors.surface,
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              hintStyle: AppTextStyles.hint.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
            ),
            onSelected: widget.onChanged,
          ),
        ),

        //текст с ошибкой если есть
        if (widget.error != null)
          Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 4),
            child: Text(widget.error!, style: AppTextStyles.errorText),
          ),
      ],
    );
  }
}
