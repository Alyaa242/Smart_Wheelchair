import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

void main() {
  runApp(const JoystickExampleApp());
}

class JoystickExampleApp extends StatelessWidget {
  const JoystickExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Joystick Example'),
        ),
        body: const JoystickExample(),
      ),
    );
  }
}

class JoystickExample extends StatefulWidget {
  const JoystickExample({Key? key}) : super(key: key);

  @override
  _JoystickExampleState createState() => _JoystickExampleState();
}

class _JoystickExampleState extends State<JoystickExample> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, 0.8),
      child: Joystick(
        mode: JoystickMode.horizontalAndVertical,
        listener: (details) {
          setState(() {
            // _x = _x + step * details.x;
            // _y = _y + step * details.y;
          });
        },
      ),
    );
  }
}
