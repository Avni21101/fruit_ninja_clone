import 'dart:ui';

import 'package:fruit_ninja_clone/models/gavitational_object.dart';

class FruitPart extends GravitationalObject {
  FruitPart({
    required this.width,
    required this.height,
    required this.isLeft,
    required super.position,
    super.gravitySpeed = 0.0,
    super.additionalForce = const Offset(0, 0),
    super.rotation = 0.0,
  });

  final double width;
  final double height;
  final bool isLeft;

  @override
  List<Object> get props => [width, height, isLeft];
}
