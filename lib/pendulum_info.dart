import 'dart:math';
import 'dart:ui';

class PendulumInfo {
  double length;
  double mass;
  double angle;

  ///Angular Velocity
  double angularVel;

  /// acceleration
  double acc;

  // Canvas related
  Color paintColor = Color(Random().nextInt(0xffffffff));
  Offset origin;
  List<Offset> trailPoints = [];

  PendulumInfo(
      {this.length,
      this.mass,
      this.angle,
      this.origin,
      this.angularVel = 1,
      this.acc = 1});

  Offset get endPoint =>
      Offset((length * sin(angle)), (length * cos(angle))) + origin;

  @override
  toString() => 'Pendulum has end point at $endPoint';
}
