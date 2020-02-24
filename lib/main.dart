import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DoublePendulum(
        animationDuration: Duration(seconds: 15),
      ),
    );
  }
}

class DoublePendulum extends StatefulWidget {
  final Duration animationDuration;
  DoublePendulum({this.animationDuration});

  @override
  _DoublePendulumState createState() => _DoublePendulumState();
}

class _DoublePendulumState extends State<DoublePendulum>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> offsetanimation;
  double value;
  PendulumManager pendulumManager;

  @override
  void initState() {
    super.initState();

    // Initializing the animation controller with a defined duraion.
    _animationController =
        AnimationController(vsync: this, duration: widget.animationDuration);
    offsetanimation =
        Tween<double>(begin: -100, end: 100).animate(_animationController);
    offsetanimation.addListener(() {
      setState(() {
        value = offsetanimation.value;
      });
    });
    pendulumManager = PendulumManager.withParams(
        origin: Offset(500, 500), noOfDoublePendulums: 1);
    print('init completed');
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    pendulumManager.reEstimatePostions();

    return CustomPaint(
      painter: DoublePendulumPainter(pendulumPaintInfos: pendulumManager),
    );
  }
}

final pendulum1Paint = Paint()
  ..color = Colors.amber
  ..strokeWidth = 1.0;
final pendulum1MassPaint = Paint()
  ..color = Colors.black
  ..strokeWidth = 1.0;
final pendulum2Paint = Paint()
  ..color = Colors.blueAccent
  ..style = PaintingStyle.fill;
final pendulum2MassPaint = Paint()
  ..color = Colors.red
  ..style = PaintingStyle.fill;

class DoublePendulumPainter extends CustomPainter {
  final PendulumManager pendulumPaintInfos;

  DoublePendulumPainter({this.pendulumPaintInfos});

  @override
  void paint(Canvas canvas, Size size) {
    print('length id ${pendulumPaintInfos.allDoublePendulums}');
    pendulumPaintInfos.allDoublePendulums
        .forEach((List<PendulumDrawInfo> pendulumPaintInfo) {
      print('inside for each ${pendulumPaintInfo[0]}');
      // Draws the line for pendulum 1
      canvas.drawLine(pendulumPaintInfo[0].origin, pendulumPaintInfo[0].end,
          pendulum1Paint);
      // draws the bob for the first pendulum
      canvas.drawCircle(pendulumPaintInfo[0].end, pendulumPaintInfo[0].radius,
          pendulum1MassPaint);
      print('inside for each ${pendulumPaintInfo[1]}');
      // Draws the line for pendulum 1
      canvas.drawLine(pendulumPaintInfo[1].origin, pendulumPaintInfo[1].end,
          pendulum2Paint);
      // draws the bob for the first pendulum
      canvas.drawCircle(pendulumPaintInfo[1].end, pendulumPaintInfo[1].radius,
          pendulum2MassPaint);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class PendulumManager {
  double noOfDoublePendulums;
  double pendulum1Length = 10;
  double pendulum2Length = 10;
  double pendulum1Mass = 5;
  double pendulum2Mass = 5;
  Offset origin;
  double temp = 0;

  List<List<PendulumDrawInfo>> allDoublePendulums = [];

  PendulumManager._(
      {this.allDoublePendulums,
      this.origin,
      this.noOfDoublePendulums,
      this.pendulum1Length,
      this.pendulum1Mass,
      this.pendulum2Length,
      this.pendulum2Mass});

  factory PendulumManager.withParams(
      {@required origin,
      @required noOfDoublePendulums,
      pendulum1Length,
      pendulum1Mass,
      pendulum2Length,
      pendulum2Mass}) {
    List<List<PendulumDrawInfo>> allDoublePendulums = [];
    for (int i = 0; i < noOfDoublePendulums; i++) {
      Offset p1End = origin + Offset(0, pendulum1Length ?? 100);
      Offset p2End = p1End + Offset(0, pendulum2Length ?? 100);
      final newList = <PendulumDrawInfo>[
        PendulumDrawInfo(origin, p1End, pendulum1Mass ?? 10),
        PendulumDrawInfo(p1End, p2End, pendulum2Mass ?? 10)
      ];
      print('newList Created $newList');
      allDoublePendulums.add(newList);
    }
    return PendulumManager._(
        allDoublePendulums: allDoublePendulums,
        origin: origin,
        pendulum1Length: pendulum1Length,
        pendulum1Mass: pendulum1Mass,
        pendulum2Length: pendulum2Length,
        pendulum2Mass: pendulum2Mass,
        noOfDoublePendulums: noOfDoublePendulums);
  }

  void reEstimatePostions() {
    temp += 0.01;
    this.allDoublePendulums.forEach((List<PendulumDrawInfo> element) {
      element[0].end += Offset(temp, temp);
      element[1].origin += Offset(temp, temp);
      element[1].end += Offset(temp, temp);
    });
  }

  List<List<PendulumDrawInfo>> get allPendudlums => allDoublePendulums;
}

class PendulumDrawInfo {
  Offset origin, end;
  double radius;
  PendulumDrawInfo(this.origin, this.end, this.radius);

  @override
  String toString() {
    return "Pendulum with origin: $origin and end: $end and radius as $radius";
  }
}
