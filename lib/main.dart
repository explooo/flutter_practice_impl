import 'dart:js' as js; // Import JavaScript interop
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tasks_pro/example/graphql.dart';
import 'package:flutter_tasks_pro/example/graphql_screen.dart';
import 'package:flutter_tasks_pro/example/profile_screen.dart';
import 'package:flutter_tasks_pro/firebase_options.dart';
import 'package:flutter_tasks_pro/home_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (_, __) => HomeScreen()),
      GoRoute(path: '/profile', builder: (_, __) => ProfileScreen()),
      GoRoute(path: '/graphql', builder: (_, __) => GraphqlScreen()),
    ],
  );

  runApp(
    ProviderScope(
      child: GraphQLProvider(client: client, child: MainApp(router: _router)),
    ),
  );
}

class MainApp extends StatelessWidget {
  final GoRouter router;

  const MainApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}

class PwaInstallScreen extends StatelessWidget {
  const PwaInstallScreen({super.key});

  void showInstallPrompt() {
    js.context.callMethod('showInstallPrompt'); // Call JavaScript method
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Install PWA")),
      body: Center(
        child: ElevatedButton(
          onPressed: showInstallPrompt,
          child: Text("Install App"),
        ),
      ),
    );
  }
}
