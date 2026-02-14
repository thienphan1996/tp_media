import 'package:flutter/material.dart';
import 'package:tp_media/external/lottie.dart';
import 'package:tp_media/theme/theme.dart';

const defaultBackground = [
  Color(0xFFFFE082), // Light Gold
  Color(0xFFFFD54F), // Gold
  Color(0xFFFFB300), // Amber
];

class PremiumUser extends StatelessWidget {
  const PremiumUser({
    required this.text,
    required this.title,
    required this.isPremiumUser,
    this.borderRadius = largeBorderRadius,
    this.backgroundGradient = defaultBackground,
    super.key,
  });

  final String title;
  final String text;
  final bool isPremiumUser;
  final BorderRadius borderRadius;
  final List<Color> backgroundGradient;

  @override
  Widget build(BuildContext context) {
    if (!isPremiumUser) {
      return const SizedBox.shrink();
    }

    final lastBackgroundColor = backgroundGradient.lastOrNull?.withValues(
      alpha: .3,
    );
    final shadowColor =
        lastBackgroundColor ?? const Color(0xFFFFB300).withValues(alpha: .3);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: backgroundGradient,
        ),
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
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
                    width: 56,
                    height: 56,
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
                  const SizedBox(width: 16),
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
                            padding: const EdgeInsets.only(top: 4),
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
