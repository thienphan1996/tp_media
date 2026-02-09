import 'package:flutter/material.dart';
import 'package:tp_media/external/lottie.dart';
import 'package:tp_media/theme/theme.dart';

class PremiumUser extends StatelessWidget {
  const PremiumUser({
    required this.text,
    required this.title,
    required this.isPremiumUser,
    this.borderRadius = largeBorderRadius,
    super.key,
  });

  final String title;
  final String text;
  final bool isPremiumUser;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    if (!isPremiumUser) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFE082), // Light Gold
            Color(0xFFFFD54F), // Gold
            Color(0xFFFFB300), // Amber
          ],
        ),
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFB300).withValues(alpha: .3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Icon(
                Icons.stars_rounded,
                size: 100,
                color: Colors.white.withValues(alpha: .15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Lottie.asset(
                      'assets/ani_premium.json',
                      package: 'tp_media',
                      fit: BoxFit.contain,
                      repeat: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            letterSpacing: -0.2,
                          ),
                        ),
                        if (text.trim().isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(
                              text,
                              style: TextStyle(
                                color: Colors.black.withValues(alpha: 0.6),
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
