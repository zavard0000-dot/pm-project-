import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamup/features/home/tabs/feed_tab/modal_sheets/modal_sheets.dart';
import 'package:teamup/providers/my_auth_provider.dart';
import 'package:teamup/theme.dart';
import 'my_filter_chip.dart';

class FeedHeader extends StatefulWidget {
  const FeedHeader({super.key});

  @override
  State<FeedHeader> createState() => _FeedHeaderState();
}

class _FeedHeaderState extends State<FeedHeader> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchPressed() {
    final query = _searchController.text.trim();
    context.read<MyAuthProvider>().applySearchFilter(query);
    print('[FeedHeader] Search button pressed - query: "$query"');
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Consumer<MyAuthProvider>(
      builder: (context, authProvider, _) {
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
            preferredSize: const Size.fromHeight(100),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Поисковое поле
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: isDarkMode
                              ? AppTextStyles.darkBodyMedium
                              : AppTextStyles.bodyMedium,
                          decoration: InputDecoration(
                            hintText: 'Найти объявление...',
                            hintStyle: TextStyle(
                              color: isDarkMode
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                            ),
                            // prefixIcon: Icon(
                            //   Icons.search_outlined,
                            //   color: isDarkMode
                            //       ? AppColors.darkTextSecondary
                            //       : AppColors.textSecondary,
                            //   size: 20,
                            // ),
                            filled: true,
                            fillColor: isDarkMode
                                ? AppColors.darkInputBorder
                                : Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: isDarkMode
                                    ? AppColors.darkInputBorder
                                    : AppColors.inputBorder,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: isDarkMode
                                    ? AppColors.darkInputBorder
                                    : AppColors.inputBorder,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: isDarkMode
                                    ? AppColors.primaryBlue
                                    : AppColors.primaryBlue,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Кнопка поиска
                      GestureDetector(
                        onTap: _onSearchPressed,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? AppColors.primaryBlue
                                : AppColors.primaryBlue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
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
                            // Типы фильтров
                            ...['person', 'project', 'team'].map((type) {
                              final bool isSelected = authProvider.selectedTypes
                                  .contains(type);
                              return MyFilterChip(
                                isSelected: isSelected,
                                title: type,
                                onTap: () {
                                  List<String> newTypes = List.from(
                                    authProvider.selectedTypes,
                                  );
                                  if (isSelected) {
                                    newTypes.remove(type);
                                  } else {
                                    newTypes.add(type);
                                  }
                                  authProvider.applyFilters(
                                    types: newTypes,
                                    skills: authProvider.selectedSkills,
                                    eventTypes: authProvider.selectedEventTypes,
                                  );
                                },
                              );
                            }).toList(),
                            const Spacer(),
                            // Кнопка для модального окна фильтров
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
                                  openFilterBottomSheet(
                                    context,
                                    currentTypes: authProvider.selectedTypes,
                                    currentSkills: authProvider.selectedSkills,
                                    currentEventTypes:
                                        authProvider.selectedEventTypes,
                                    onApplyFilters:
                                        (types, skills, eventTypes) =>
                                            authProvider.applyFilters(
                                              types: types,
                                              skills: skills,
                                              eventTypes: eventTypes,
                                            ),
                                  );
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
      },
    );
  }
}
