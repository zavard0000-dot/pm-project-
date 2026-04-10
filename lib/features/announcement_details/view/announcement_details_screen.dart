import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';
import 'package:teamup/widgets/primary_button.dart';
import 'package:teamup/widgets/round_icon_btn.dart';
import '../widgets/widgets.dart';

class AnnouncementDetailsScreen extends StatelessWidget {
  const AnnouncementDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              // градиент
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryBlue, AppColors.primaryPurple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                //Убирает отступ снизу
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //btn back
                      roundIconBtn(
                        icon: Icons.arrow_back,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Ищу Frontend (React) для хакатона',
                        style: AppTextStyles.whiteHeadingLarge,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Хакатон "Digital Almaty" через 2 недели. Нужен человек, который быстро соберет MVP на готовом дизайне.',
                        style: AppTextStyles.whiteCaption,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          //details
          SliverToBoxAdapter(
            //Виджет смещает своего ребенка
            child: Transform.translate(
              offset: const Offset(0, -8),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                ),
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                child: Column(
                  children: [
                    AuthorCard(),
                    SizedBox(height: 14),
                    EventDetailsCard(),
                    SizedBox(height: 14),
                    DescriptionCard(),
                    SizedBox(height: 24),
                    PrimaryButton(
                      icon: Icons.telegram,
                      text: "Связаться с Telegram",
                      onPressed: () {},
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class _Dot extends StatelessWidget {
//   const _Dot({this.isFilled = false});

//   final bool isFilled;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 20,
//       height: 12,
//       decoration: BoxDecoration(
//         color: isFilled ? Colors.white : Colors.transparent,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.white, width: 2),
//       ),
//     );
//   }
// }
