import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class FingerprintUnlockScreen extends StatefulWidget {
  const FingerprintUnlockScreen({super.key});

  @override
  _FingerprintUnlockScreenState createState() =>
      _FingerprintUnlockScreenState();
}

class _FingerprintUnlockScreenState extends State<FingerprintUnlockScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _authenticated = false;

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: "Scan your fingerprint to proceed",
        options: const AuthenticationOptions(biometricOnly: true),
      );
      setState(() => _authenticated = authenticated);
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fingerprint Unlock")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_authenticated ? "Authenticated!" : "Not Authenticated"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _authenticate,
              child: Text("Authenticate"),
            ),
          ],
        ),
      ),
    );
  }
}
