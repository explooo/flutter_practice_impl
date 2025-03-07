import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider = StateProvider<int>((ref) => 0);

class RiverpodExampleScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int count = ref.watch(counterProvider);
    return Scaffold(
      appBar: AppBar(title: Text("Riverpod Example")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Count: $count", style: TextStyle(fontSize: 24)),
            ElevatedButton(
              onPressed: () => ref.read(counterProvider.notifier).state++,
              child: Text("Increment"),
            ),
          ],
        ),
      ),
    );
  }
}
