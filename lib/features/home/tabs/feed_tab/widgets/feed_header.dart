import 'package:flutter/material.dart';
import 'package:teamup/features/home/tabs/feed_tab/modal_sheets/modal_sheets.dart';
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
                              OpenFilterBottomSheet(context);
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
