import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';
import 'package:teamup/widgets/widgets.dart';

class DescriptionCard extends StatelessWidget {
  const DescriptionCard();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Полное описание',
            style: AppTextStyles.displayLarge.copyWith(
              color: isDarkMode
                  ? AppColors.darkTextPrimary
                  : AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Привет! Наша команда участвует в хакатоне Digital Almaty, который пройдет 5-7 апреля. Мы разрабатываем платформу для помощи студентам в поиске жилья. У нас уже есть бизнес-модель, дизайн и backend разработчик. Нам нужен опытный frontend разработчик, который сможет быстро собрать интерфейс на React. Важно уметь работать в команде и быстро принимать решения. Что мы предлагаем: дружную команду из 3 человек, готовый дизайн в Figma, опыт участия в хакатоне и возможность выиграть призовой фонд 500К тенге.',
            style: AppTextStyles.captionLarge.copyWith(
              color: isDarkMode
                  ? AppColors.darkTextPrimary.withOpacity(0.7)
                  : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
