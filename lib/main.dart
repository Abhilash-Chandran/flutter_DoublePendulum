import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'slider_with_label.dart';
import 'pendulum_info.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: DoublePendulum(
          animationDuration: Duration(seconds: 1),
        ),
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

  PendulumSimulationManager pendulumManager;
  double noOfPendulums = 5;
  double gravity = 9.8;
  double pendulum1Length = 100;
  double pendulum2Length = 100;
  double pendulum1Mass = 7;
  double pendulum2Mass = 3;
  double pendulum1Angle = 90;
  double pendulum2Angle = 90;
  bool showMenu = true;
  @override
  void initState() {
    super.initState();

    // Initializing the animation controller with a defined duraion.
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    print('main build is called.');
    final avlblSize = MediaQuery.of(context).size;

    pendulumManager = PendulumSimulationManager(
      noOfDoublePendulums: noOfPendulums,
      gravity: gravity / 60,
      pendulum1Length: pendulum1Length,
      pendulum1Mass: pendulum1Mass,
      pendulum2Length: pendulum2Length,
      pendulum2Mass: pendulum2Mass,
      pendulum1Angle: pendulum1Angle * 0.0174533,
      pendulum2Angle: pendulum2Angle * 0.0174533,
    );
    pendulumManager.initializePendulums();

    return Stack(
      children: <Widget>[
        Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, _) {
              pendulumManager.reEstimateAngles();
              return CustomPaint(
                painter:
                    DoublePendulumPainter(pendulumPaintInfos: pendulumManager),
              );
            },
          ),
        ),
        Container(
          width: avlblSize.width >= 600 ? avlblSize.width / 4 : avlblSize.width,
          alignment: Alignment.topLeft,
          child: Card(
            child: ExpansionTile(
              title: Text('Settings'),
              initiallyExpanded: true,
              children: <Widget>[
                ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    SliderWithLabel(
                      widgetLabel: 'Pendulums : ',
                      min: 1,
                      max: 50,
                      showNDecimal: 0,
                      callBack: (double value) {
                        setState(() {
                          noOfPendulums = value;
                        });
                      },
                      division: 50,
                      initialValue: noOfPendulums,
                    ),
                    SliderWithLabel(
                      widgetLabel: 'Gravity : ',
                      min: 1,
                      max: 20,
                      callBack: (double value) {
                        setState(() {
                          gravity = value;
                        });
                      },
                      initialValue: gravity,
                    ),
                    SliderWithLabel(
                      widgetLabel: 'Pendulum-1 Length : ',
                      min: 1,
                      max: 200,
                      callBack: (double value) {
                        setState(() {
                          pendulum1Length = value;
                        });
                      },
                      initialValue: pendulum1Length,
                    ),
                    SliderWithLabel(
                      widgetLabel: 'Pendulum-2 Length : ',
                      min: 1,
                      max: 200,
                      callBack: (double value) {
                        setState(() {
                          pendulum2Length = value;
                        });
                      },
                      initialValue: pendulum2Length,
                    ),
                    SliderWithLabel(
                      widgetLabel: 'Pendulum-1 Mass : ',
                      min: 0.01,
                      max: 10,
                      callBack: (double value) {
                        setState(() {
                          pendulum1Mass = value;
                        });
                      },
                      initialValue: pendulum1Mass,
                    ),
                    SliderWithLabel(
                      widgetLabel: 'Pendulum-2 Mass : ',
                      min: 0.01,
                      max: 10,
                      callBack: (double value) {
                        setState(() {
                          pendulum2Mass = value;
                        });
                      },
                      initialValue: pendulum2Mass,
                    ),
                    SliderWithLabel(
                      widgetLabel: 'Pendulum-1 Angle : ',
                      min: 0,
                      max: 360,
                      callBack: (double value) {
                        setState(() {
                          pendulum1Angle = value;
                        });
                      },
                      initialValue: pendulum1Angle,
                    ),
                    SliderWithLabel(
                      widgetLabel: 'Pendulum-2 Angle : ',
                      min: 0,
                      max: 360,
                      callBack: (double value) {
                        setState(() {
                          pendulum2Angle = value;
                        });
                      },
                      initialValue: pendulum2Angle,
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

final pendulumPaint = Paint()..strokeWidth = 4.0;
final pendulum2MassPaint = Paint()
  ..color = Colors.red
  ..style = PaintingStyle.fill;
Paint _trailPaint = Paint()
  ..strokeWidth = 0.5
  ..color = Colors.white;

class DoublePendulumPainter extends CustomPainter {
  final PendulumSimulationManager pendulumPaintInfos;

  DoublePendulumPainter({this.pendulumPaintInfos});

  @override
  void paint(Canvas canvas, Size size) {
    // Trasnslate to the middle of the screen.
    canvas.translate(
        pendulumPaintInfos.origin.dx, pendulumPaintInfos.origin.dy);
    pendulumPaintInfos.allDoublePendulums
        .forEach((List<PendulumInfo> pendulumPaintInfo) {
      // Draws the line for pendulum 1
      canvas.drawLine(
          pendulumPaintInfo[0].origin,
          pendulumPaintInfo[0].endPoint,
          pendulumPaint..color = pendulumPaintInfo[0].paintColor);
      // draws the bob for the first pendulum
      canvas.drawCircle(pendulumPaintInfo[0].endPoint,
          pendulumPaintInfo[0].mass, pendulumPaint);
      // Draws the line for pendulum 2
      canvas.drawLine(
          pendulumPaintInfo[1].origin,
          pendulumPaintInfo[1].endPoint,
          pendulumPaint..color = pendulumPaintInfo[1].paintColor);
      // draws the bob for the second pendulum
      canvas.drawCircle(pendulumPaintInfo[1].endPoint,
          pendulumPaintInfo[1].mass, pendulumPaint..color = Colors.red);
      canvas.drawPoints(
          PointMode.lines, pendulumPaintInfo[1].trailPoints, _trailPaint);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class PendulumSimulationManager {
  double noOfDoublePendulums;
  double pendulum1Length;
  double pendulum2Length;
  double pendulum1Mass;
  double pendulum2Mass;
  double pendulum1Angle;
  double pendulum2Angle;
  Offset origin;
  double gravity;

  List<List<PendulumInfo>> allDoublePendulums = [];

  PendulumSimulationManager({
    this.origin = Offset.zero,
    @required this.noOfDoublePendulums,
    @required this.gravity,
    this.pendulum1Length = 200,
    this.pendulum1Mass = 6,
    this.pendulum2Length = 200,
    this.pendulum2Mass = 3,
    this.pendulum1Angle = pi / 2,
    this.pendulum2Angle = pi / 4,
  });

  void initializePendulums() {
    for (int i = 0; i < noOfDoublePendulums; i++) {
      PendulumInfo pendulum1 = PendulumInfo(
        angle: pendulum1Angle + (i * 0.0174533),
        length: pendulum1Length,
        mass: pendulum1Mass,
        origin: Offset.zero,
        vel: 0,
        acc: 0,
      );
      PendulumInfo pendulum2 = PendulumInfo(
        angle: pendulum2Angle,
        length: pendulum2Length,
        mass: pendulum2Mass,
        origin: pendulum1.endPoint,
        vel: 0,
        acc: 0,
      );
      allDoublePendulums.add([pendulum1, pendulum2]);
    }
  }

  void reEstimateAngles() {
    allDoublePendulums.forEach((List<PendulumInfo> pendulums) {
      pendulums[0].vel += _simulatedAnglePendulum1(pendulums);
      pendulums[1].vel += _simulatedAnglePendulum2(pendulums);
      pendulums[0].angle += pendulums[0].vel;
      pendulums[1].angle += pendulums[1].vel;
      pendulums[1].origin = pendulums[0].endPoint;
      pendulums[1].trailPoints.add(pendulums[1].endPoint);
      if (pendulums[1].trailPoints.length > 50)
        pendulums[1].trailPoints.removeAt(0);
    });
  }

  double _simulatedAnglePendulum1(List<PendulumInfo> pendulums) {
    PendulumInfo p1 = pendulums[0];
    PendulumInfo p2 = pendulums[1];

    double part1 = -gravity * (2 * p1.mass + p2.mass) * sin(p1.angle) -
        p2.mass * gravity * sin(p1.angle - 2 * p2.angle);

    double part2 = 2 *
        sin(p1.angle - p2.angle) *
        p2.mass *
        (pow(p2.vel, 2) * p2.length +
            pow(p1.vel, 2) * p1.length * cos(p1.angle - p2.angle));

    double denominator = p1.length *
        (2 * p1.mass + p2.mass - p2.mass * cos(2 * p1.angle - 2 * p2.angle));

    return (part1 - part2) / denominator;
  }

  double _simulatedAnglePendulum2(List<PendulumInfo> pendulums) {
    PendulumInfo p1 = pendulums[0];
    PendulumInfo p2 = pendulums[1];
    double part1 = 2 *
        sin(p1.angle - p2.angle) *
        (p1.vel * p1.vel * p1.length * (p1.mass + p2.mass) +
            gravity * (p1.mass + p2.mass) * cos(p1.angle) +
            p2.vel * p2.vel * p2.length * p2.mass * cos(p1.angle - p2.angle));
    double denominator = p2.length *
        (2 * p1.mass + p2.mass - p2.mass * cos(2 * p1.angle - 2 * p2.angle));

    return part1 / denominator;
  }

  List<List<PendulumInfo>> get allPendudlums => allDoublePendulums;
}
