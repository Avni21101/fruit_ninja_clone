import 'dart:ui';

import 'package:fruit_ninja_clone/models/gavitational_object.dart';

class Fruit extends GravitationalObject {
  Fruit({
    required this.width,
    required this.height,
    required super.position,
    super.gravitySpeed = 0.0,
    super.additionalForce = const Offset(0, 0),
    super.rotation = 0.25,
  });

  final double width;
  final double height;

  bool isPointInside(Offset point) {
    if (point.dx < position.dx ||
        point.dx > position.dx + width ||
        point.dy < position.dy ||
        point.dy > position.dy + height) {
      return false;
    } else {
      return true;
    }
  }

  @override
  List<Object> get props => [
        width,
        height,
        super.position,
        super.additionalForce,
        super.gravitySpeed,
        super.rotation,
      ];
}
