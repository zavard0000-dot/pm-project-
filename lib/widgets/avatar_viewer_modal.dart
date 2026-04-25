import 'package:flutter/material.dart';
import 'dart:ui';

class AvatarViewerModal extends StatelessWidget {
  final String avatarUrl;
  final String userName;

  const AvatarViewerModal({
    Key? key,
    required this.avatarUrl,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            color: Colors.black.withValues(alpha: 0.5),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Main image
                GestureDetector(
                  onTap: () {}, // Prevent closing when tapping on the image
                  child: Center(
                    child: Hero(
                      tag: 'avatar_hero_${avatarUrl.hashCode}',
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.5),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 150,
                          backgroundImage: NetworkImage(avatarUrl),
                          onBackgroundImageError: (exception, stackTrace) {
                            print('Error loading avatar: $exception');
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                // Close button
                Positioned(
                  top: 40,
                  right: 20,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ),
                ),
                // User name at bottom
                Positioned(
                  bottom: 40,
                  child: Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
