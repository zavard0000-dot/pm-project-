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
  });

  final String? title;
  final String? error;
  final String? value;
  final ValueChanged<String?>? onChanged;
  final List<DropdownMenuEntry<String>> dropDownMenuEntries;

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //title
        if (widget.title != null)
          Container(
            child: Text(
              widget.title!,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            margin: EdgeInsets.only(bottom: 8),
          ),
        Container(
          //внешний отсут чье значение зависит от наличие ошибки у поле
          margin: EdgeInsets.only(bottom: widget.error != null ? 6 : 24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.inputBorder),
          ),
          child: DropdownMenu<String>(
            key: ValueKey(widget.value),
            width: double.infinity,
            dropdownMenuEntries: widget.dropDownMenuEntries,
            initialSelection: widget.value,
            hintText: "Select University",
            textStyle: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
            menuStyle: MenuStyle(
              backgroundColor: const WidgetStatePropertyAll(AppColors.surface),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              hintStyle: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            // onSelected: (value) {
            //   widget.onChanged?.call(value);
            // },
            onSelected: widget.onChanged,
          ),
        ),

        //текст с ошибкой если есть
        if (widget.error != null)
          Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 4),
            child: Text(
              widget.error!,
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
