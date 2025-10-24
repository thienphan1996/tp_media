import 'package:flutter/material.dart';
import 'package:tp_media/external/lottie.dart';

class PremiumUser extends StatelessWidget {
  const PremiumUser({required this.text, required this.title, required this.isPremiumUser, super.key});

  final String title;
  final String text;
  final bool isPremiumUser;

  @override
  Widget build(BuildContext context) {
    if (!isPremiumUser) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 46,
            child: Lottie.asset('assets/ani_premium.json', package: 'tp_media', fit: BoxFit.cover, repeat: false),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
              Visibility(
                visible: text.trim().isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(text, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
