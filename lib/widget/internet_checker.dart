import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:tp_media/network/internet_manager.dart';

class InternetChecker extends StatefulWidget {
  const InternetChecker({
    super.key,
    required this.message,
    required this.child,
  });

  final String message;
  final Widget child;

  @override
  State<InternetChecker> createState() => _InternetCheckerState();
}

class _InternetCheckerState extends State<InternetChecker> {
  late StreamSubscription<InternetStatus> _subscription;

  var _internetStatus = InternetStatus.connected;

  @override
  void initState() {
    _subscription = InternetManager.instance.onStatusChange.listen((status) {
      setState(() {
        _internetStatus = status;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_internetStatus == InternetStatus.connected) {
      return widget.child;
    }

    return Container(
      margin: const EdgeInsets.all(24),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 120,
              height: 100,
              child: Lottie.asset(
                'assets/ani_no_internet.json',
                package: 'tp_media',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.message,
              style: TextStyle(
                fontSize: 14.0,
                color: Theme.of(context).hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
