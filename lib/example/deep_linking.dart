import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DeepLinkingScreen extends StatelessWidget {
  const DeepLinkingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Deep Linking Example")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => GoRouter.of(context).push('/profile'),
          child: Text("Go to Profile"),
        ),
      ),
    );
  }
}
