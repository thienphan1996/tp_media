import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tp_media/widget/premium_user.dart';

class UpgradePremium extends StatefulWidget {
  const UpgradePremium({
    super.key,
    required this.onTap,
    required this.title,
    required this.descriptions,
    required this.positiveButton,
    this.textColor = Colors.black,
    this.isPremiumUser = false,
    this.backgroundGradient = defaultBackground,
    this.enableNegativeButton = false,
    this.negativeButton,
    this.onNegativeButtonTap,
    this.onPositiveButtonTap,
  });

  final VoidCallback onTap;
  final bool isPremiumUser;
  final String title;
  final List<String> descriptions;
  final List<Color> backgroundGradient;
  final Color textColor;
  final bool enableNegativeButton;
  final Widget? negativeButton;
  final Widget positiveButton;
  final VoidCallback? onNegativeButtonTap;
  final VoidCallback? onPositiveButtonTap;

  @override
  State<UpgradePremium> createState() => _UpgradePremiumState();
}

class _UpgradePremiumState extends State<UpgradePremium> {
  @override
  Widget build(BuildContext context) {
    if (widget.isPremiumUser) {
      return SizedBox.shrink();
    }

    final lastBackgroundColor = widget.backgroundGradient.lastOrNull
        ?.withValues(alpha: .3);
    final shadowColor =
        lastBackgroundColor ?? const Color(0xFFFFB300).withValues(alpha: .3);

    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.backgroundGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
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
                        repeat: false,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              color: widget.textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ...widget.descriptions.map((text) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                text,
                                style: TextStyle(
                                  color: widget.textColor.withValues(alpha: .9),
                                  fontSize: 13,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (widget.enableNegativeButton) ...[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            widget.onNegativeButtonTap?.call();
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: BorderSide(color: Colors.white),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: widget.negativeButton,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onTap();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: widget.positiveButton,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              Icons.stars_rounded,
              size: 100,
              color: Colors.white.withValues(alpha: .15),
            ),
          ),
        ],
      ),
    );
  }
}
