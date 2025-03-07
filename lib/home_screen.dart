import 'package:flutter/material.dart';
import 'package:flutter_tasks_pro/example/graphql_screen.dart';
import 'package:flutter_tasks_pro/example/pwa_prompt_screen.dart';
import './example/fingerprint_unlock.dart';
import './example/implicit_animation.dart';
import './example/lottie_animation.dart';
import './example/riverpod_example.dart';
import './example/deep_linking.dart';
import './example/video_call_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> examples = [
    {'title': 'Fingerprint & Face Unlock', 'screen': FingerprintUnlockScreen()},
    {'title': 'Lottie Animations', 'screen': LottieAnimationScreen()},
    {'title': 'Implicit Animations', 'screen': ImplicitAnimationScreen()},
    {'title': 'Riverpod Example', 'screen': RiverpodExampleScreen()},
    {'title': 'Dynamic Deep Linking', 'screen': DeepLinkingScreen()},
    {'title': 'Video Chat', 'screen': VideoCallScreen()},
    {'title': 'GraphQL API', 'screen': GraphqlScreen()},
    {'title': 'PWA Install', 'screen': PwaPromptScreen()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter Examples")),
      body: ListView.builder(
        itemCount: examples.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(examples[index]['title']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => examples[index]['screen'],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
