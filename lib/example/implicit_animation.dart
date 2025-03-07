import 'package:flutter/material.dart';

class ImplicitAnimationScreen extends StatefulWidget {
  @override
  _ImplicitAnimationScreenState createState() =>
      _ImplicitAnimationScreenState();
}

class _ImplicitAnimationScreenState extends State<ImplicitAnimationScreen> {
  double _size = 100.0;
  double _opacity = 1.0;

  void _animate() {
    setState(() {
      _size = _size == 100 ? 200 : 100;
      _opacity = _opacity == 1.0 ? 0.5 : 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Implicit Animation")),
      body: Center(
        child: GestureDetector(
          onTap: _animate,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: Duration(seconds: 1),
                width: _size,
                height: _size,
                color: Colors.blue,
              ),
              SizedBox(height: 20),
              AnimatedOpacity(
                duration: Duration(seconds: 1),
                opacity: _opacity,
                child: Container(width: 100, height: 100, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
