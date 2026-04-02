import 'package:flutter/material.dart';

class EditProfileHeader extends StatelessWidget {
  const EditProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          // Динамическая высота за счет padding
          padding: const EdgeInsets.only(
            top: 40, // Отступ для SafeArea (статус-бара)
            bottom:
                24, // ВАЖНО: Освобождаем место снизу для наезжающих карточек
            left: 16,
            right: 16,
          ),

          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF2563EB),
                Color(0xFF7C3AED),
                Color(0xFFDB2777),
              ], // AppColors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            // borderRadius: BorderRadius.vertical(
            //   bottom: Radius.circular(32),
            // ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back),
                    color: Colors.white,
                  ),
                  SizedBox(width: 48),
                  Icon(Icons.star_outline_sharp, color: Colors.white),
                  Text(
                    " Edit Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24),

              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 55,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?img=5',
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                "нажми для редактирование профеля",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
