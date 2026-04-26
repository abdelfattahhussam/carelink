import 'package:flutter/material.dart';

/// Minimal loading shell for the /home route.
/// The actual redirection to role-specific homes (Dashboard, DonorHome, etc.)
/// is now handled centrally by the AppRouter's redirect logic.
class HomeRouterScreen extends StatelessWidget {
  const HomeRouterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
