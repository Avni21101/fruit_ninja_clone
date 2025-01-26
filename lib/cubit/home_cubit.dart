import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_ninja_clone/models/fruit.dart';
import 'package:fruit_ninja_clone/models/fruit_part.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  final randomInt = Random().nextInt(10);

  void setNewSlice(ScaleStartDetails details) {
    emit(state.copyWith(pointsList: <Offset>[details.localFocalPoint]));
  }

  void addPointToSlice(ScaleUpdateDetails details) {
    if (state.pointsList.isNotEmpty) {
      /// we should not mutate state directly. Instead use List.of()
      final list = List.of([...state.pointsList, details.localFocalPoint]);
      if (state.pointsList.length > 16) {
        list.removeAt(0);
      }
      emit(state.copyWith(pointsList: list));
    }
  }

  void resetSlice() {
    emit(state.copyWith(pointsList: []));
  }

  void initializeRandomFruits() {
    final list = List.of(
      [
        ...state.fruitList,
        Fruit(
          position: const Offset(0, 200),
          width: 80,
          height: 80,
          additionalForce: Offset(
            5 + Random().nextDouble() * 5,
            Random().nextDouble() * 10, // Positive to move downward
          ),
          rotation: Random().nextDouble() / 3 - 0.16,
        ),
      ],
    );

    emit(
      state.copyWith(
        fruitList: list,
        tickCount: state.tickCount + randomInt,
      ),
    );
  }

  Future<void> tick() async {
    final fruitList = List.of(state.fruitList);
    final fruitPartList = List.of(state.fruitPartList);

    for (final fruit in fruitList) {
      fruit.applyGravity();
    }
    for (final part in fruitPartList) {
      part.applyGravity();
    }
    fruitList.removeWhere((fruit) => fruit.position.dy > 800);

    /// Here we are applying gravity on the already generated instances of Fruit.
    /// Therefor state will stay same even though values of variable for Fruit are different.
    /// That's why we will emit [state.tickCount + randomInt] so that state will differ and
    /// builder will get called.
    emit(
      state.copyWith(
        fruitPartList: fruitPartList,
        fruitList: fruitList,
        tickCount: state.tickCount + randomInt,
      ),
    );
    if (Random().nextDouble() > 0.97) {
      initializeRandomFruits();
    }
  }

  void checkCollision() {
    if (state.pointsList.isNotEmpty) {
      final fruitList = List.of(state.fruitList);
      for (final fruit in List<Fruit>.from(fruitList)) {
        bool firstPointOutside = false;
        bool secondPointInside = false;

        for (final point in state.pointsList) {
          if (!firstPointOutside && !fruit.isPointInside(point)) {
            firstPointOutside = true;
            continue;
          }

          if (firstPointOutside && fruit.isPointInside(point)) {
            secondPointInside = true;
            continue;
          }

          if (secondPointInside && !fruit.isPointInside(point)) {
            fruitList.remove(fruit);
            _turnFruitIntoParts(fruit);
            emit(state.copyWith(score: state.score + 10));
            break;
          }
        }
      }
      emit(state.copyWith(fruitList: fruitList));
    }
  }

  void _turnFruitIntoParts(Fruit wholeFruit) {
    FruitPart leftFruitPart = FruitPart(
      position: Offset(
        wholeFruit.position.dx - wholeFruit.width / 8,
        wholeFruit.position.dy,
      ),
      width: wholeFruit.width / 2,
      height: wholeFruit.height,
      isLeft: true,
      gravitySpeed: wholeFruit.gravitySpeed,
      rotation: wholeFruit.rotation,
      additionalForce: Offset(
        wholeFruit.additionalForce.dx - 1,
        wholeFruit.additionalForce.dy - 5,
      ),
    );

    FruitPart rightFruitPart = FruitPart(
      position: Offset(
        wholeFruit.position.dx + wholeFruit.width / 4 + wholeFruit.width / 8,
        wholeFruit.position.dy,
      ),
      width: wholeFruit.width / 2,
      height: wholeFruit.height,
      isLeft: false,
      gravitySpeed: wholeFruit.gravitySpeed,
      rotation: wholeFruit.rotation,
      additionalForce: Offset(
        wholeFruit.additionalForce.dx + 1,
        wholeFruit.additionalForce.dy - 5,
      ),
    );

    final List<FruitPart> fruitPartList = List.of(
      [
        ...state.fruitPartList,
        leftFruitPart,
        rightFruitPart,
      ],
    );
    emit(state.copyWith(fruitPartList: fruitPartList));
  }
}
