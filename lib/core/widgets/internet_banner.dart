import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetBanner extends StatefulWidget {
  const InternetBanner({super.key});

  @override
  State<InternetBanner> createState() => _InternetBannerState();
}

class _InternetBannerState extends State<InternetBanner> {
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  bool _isConnected = false;

  @override
  void initState() {
    super.initState();

    _checkConnection();

    _subscription = Connectivity().onConnectivityChanged.listen(
          (results) {
        if (!mounted) return;

        setState(() {
          _isConnected = results.any(
                (result) => result != ConnectivityResult.none,
          );
        });
      },
    );
  }

  Future<void> _checkConnection() async {
    final results = await Connectivity().checkConnectivity();

    if (!mounted) return;

    setState(() {
      _isConnected = results.any(
            (result) => result != ConnectivityResult.none,
      );
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isConnected) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      height: 55,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6C63FF),
            Color(0xFF8B83FF),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.wifi_rounded,
            color: Colors.white,
            size: 23,
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Text(
              'You are connected to the internet!',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),

          const Icon(
            Icons.check_circle_rounded,
            color: Colors.white,
            size: 20,
          ),
        ],
      ),
    );
  }
}