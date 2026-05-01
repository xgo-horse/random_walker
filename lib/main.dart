import 'dart:math';

import 'package:flutter/material.dart';

const stepSize = 4.0;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Walker',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final List<double> directions = [-stepSize, stepSize, 0];
  final List<Offset> steps = [];
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addListener(() {
      addStep();
    });
    _controller.repeat(period: Duration(seconds: 60));
  }

  void addStep() {
    final dx = directions[Random().nextInt(3)];
    final dy = directions[Random().nextInt(3)];
    final offset = Offset(dx, dy);
    setState(() {
      steps.add(offset);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomPaint(
          size: MediaQuery.sizeOf(context),
          painter: RandomWalkerPainter(steps: steps),
        ),
      ),
    );
  }
}

class RandomWalkerPainter extends CustomPainter {
  final List<Offset> steps;

  RandomWalkerPainter({super.repaint, required this.steps});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.purple;
    paint.strokeWidth = stepSize;
    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.round;
    paint.strokeJoin = StrokeJoin.round;
    final path = Path();
    path.moveTo(size.width / 2, size.height / 2);
    for (var step in steps) {
      path.relativeLineTo(step.dx, step.dy);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(RandomWalkerPainter oldDelegate) {
    return true;
  }
}
