import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import './pwa_prompt.dart';

class PwaPromptScreen extends StatelessWidget {
  const PwaPromptScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PWA Prompt")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            if (kIsWeb) {
              showInstallPrompt();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("PWA install is only available on Web")),
              );
            }
          },
          child: const Text('Install PWA'),
        ),
      ),
    );
  }
}
