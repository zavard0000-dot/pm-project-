import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';
import 'package:teamup/widgets/widgets.dart';

class AvailabilityCard extends StatefulWidget {
  const AvailabilityCard({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });
  final int selectedIndex;
  final Function onTap;

  @override
  State<AvailabilityCard> createState() => _AvailabilityCardState();
}

class _AvailabilityCardState extends State<AvailabilityCard> {
  final List<Map<String, String>> options = [
    {
      "title": "Доступна для проектов",
      "subtitle": "Готова к новым возможностям",
    },
    {"title": "Частично доступна", "subtitle": "Могу взять небольшой проект"},
    {"title": "Недоступна", "subtitle": "Сейчас занята другими проектами"},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final selectedColor = AppColors.primaryBlue;
    final unselectedBorderColor = isDarkMode
        ? AppColors.darkInputBorder
        : const Color.fromARGB(255, 235, 236, 236);
    final selectedBgColor = isDarkMode
        ? AppColors.primaryBlue.withOpacity(0.2)
        : Colors.blue[50];

    return BaseCard(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "🎯 доступность",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isDarkMode
                  ? AppColors.darkTextPrimary
                  : AppColors.textPrimary,
            ),
          ),

          SizedBox(height: 24),
          ...options.asMap().entries.map((option) {
            final index = option.key;
            final value = option.value;

            return GestureDetector(
              onTap: () {
                widget.onTap(index);
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                margin: EdgeInsets.only(bottom: 12),
                decoration: (index == widget.selectedIndex
                    ? BoxDecoration(
                        border: Border.all(width: 2, color: selectedColor),
                        color: selectedBgColor,
                        borderRadius: BorderRadius.circular(16),
                      )
                    : BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: unselectedBorderColor,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value["title"]!,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      value["subtitle"]!,
                      style: TextStyle(
                        color: isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:teamup/widgets/widgets.dart';

// class AvailabilityCard extends StatefulWidget {
//   const AvailabilityCard({
//     super.key,
//     required this.selectedIndex,
//     required this.onTap,
//   });
//   final int selectedIndex;
//   final Function onTap;

//   @override
//   State<AvailabilityCard> createState() => _AvailabilityCardState();
// }

// class _AvailabilityCardState extends State<AvailabilityCard> {
//   int? _pressedIndex;

//   final List<Map<String, String>> options = [
//     {
//       "title": "Доступна для проектов",
//       "subtitle": "Готова к новым возможностям",
//     },
//     {"title": "Частично доступна", "subtitle": "Могу взять небольшой проект"},
//     {"title": "Недоступна", "subtitle": "Сейчас занята другими проектами"},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return BaseCard(
//       padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "🎯 доступность",
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//           ),

//           SizedBox(height: 24),
//           ...options.asMap().entries.map((option) {
//             final index = option.key;
//             final value = option.value;

//             return GestureDetector(
//               onTapDown: (_) {
//                 setState(() {
//                   _pressedIndex = index;
//                 });
//               },
//               onTapUp: (_) {
//                 setState(() {
//                   _pressedIndex = null;
//                 });
//               },
//               onTapCancel: () {
//                 setState(() {
//                   _pressedIndex = null;
//                 });
//               },
//               onTap: () {
//                 widget.onTap(index);
//               },
//               child: AnimatedScale(
//                 scale: _pressedIndex == index ? 0.90 : 1,
//                 duration: const Duration(milliseconds: 120),
//                 curve: Curves.easeOut,
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 180),
//                   curve: Curves.easeOut,
//                   width: double.infinity,
//                   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   margin: EdgeInsets.only(bottom: 12),
//                   decoration: (index == widget.selectedIndex
//                       ? BoxDecoration(
//                           border: BoxBorder.all(width: 2, color: Colors.green),
//                           color: Colors.green[50],
//                           borderRadius: BorderRadius.circular(16),
//                         )
//                       : BoxDecoration(
//                           border: BoxBorder.all(
//                             width: 2,
//                             color: theme.hintColor.withOpacity(0.5),
//                           ),
//                           borderRadius: BorderRadius.circular(16),
//                         )),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         value["title"]!,
//                         style: TextStyle(
//                           fontSize: 17,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       Text(value["subtitle"]!),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           }).toList(),
//         ],
//       ),
//     );
//   }
// }
