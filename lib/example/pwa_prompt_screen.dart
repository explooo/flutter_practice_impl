import 'dart:js' as js;
import 'package:flutter/material.dart';

class PwaPromptScreen extends StatelessWidget {
  const PwaPromptScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PWA Prompt")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            js.context.callMethod('showInstallPrompt', []);
          },
          child: const Text('Install PWA'),
        ),
      ),
    );
  }
}
