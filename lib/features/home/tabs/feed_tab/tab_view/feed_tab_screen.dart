// ==========================================
// 📂 screens/home/home_screen.dart
// ==========================================
import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';
import '../widgets/widgets.dart';

class FeedTabScreen extends StatelessWidget {
  const FeedTabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          FeedHeader(),

          SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Feed Cards
          SliverList.builder(
            itemCount: 5,
            itemBuilder: (context, id) {
              return const PostCard(
                name: 'Айгерім К.',
                university: 'KBTU, 3 year',
                title: 'Looking for Frontend (React) for a hackathon',
                description:
                    'The "Digital Almaty" hackathon is in two weeks. We need someone to quickly build an MVP based on a pre-existing design.',
                tags: ['ReactJS', 'TypeScript', 'Fast-paced'],
              );
            },
          ),
        ],
      ),
    );
  }
}



                  // const PostCard(
                  //   name: 'Айгерім К.',
                  //   university: 'KBTU, 3 year',
                  //   title: 'Looking for Frontend (React) for a hackathon',
                  //   description:
                  //       'The "Digital Almaty" hackathon is in two weeks. We need someone to quickly build an MVP based on a pre-existing design.',
                  //   tags: ['ReactJS', 'TypeScript', 'Fast-paced'],
                  // ),
                  // const SizedBox(height: 16),
                  // const PostCard(
                  //   name: 'Нұрлан Б.',
                  //   university: 'L.N. Gumilyov ENU, 4th year student',
                  //   title: 'Looking for a UI/UX designer for a startup',
                  //   description:
                  //       "We're developing a mobile app for students. We need a creative designer to create the interface.",
                  //   tags: ['Figma', 'UI/UX', 'Startup'],
                  //   isAvatarText: true,
                  // ),
