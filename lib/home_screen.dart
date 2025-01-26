import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_ninja_clone/cubit/home_cubit.dart';
import 'package:fruit_ninja_clone/slice_painter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Timer timer;

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().initializeRandomFruits();
    _tickTheTimer();
  }

  Future<void> _tickTheTimer() async {
    timer = Timer.periodic(
      const Duration(milliseconds: 30),
      (_) async {
        await context.read<HomeCubit>().tick();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final fruitList = state.fruitList;
        return Scaffold(
          body: Stack(
            children: [
              const Background(),
              if (state.pointsList.isNotEmpty)
                CustomPaint(
                  size: Size.infinite,
                  painter: SlicePainter(
                    pointsList: state.pointsList,
                  ),
                ),
              if (state.fruitPartList.isNotEmpty)
                for (final cutFruit in state.fruitPartList)
                  Positioned(
                    top: cutFruit.position.dy,
                    left: cutFruit.position.dx,
                    child: Transform.rotate(
                      angle: cutFruit.rotation * pi * 2,
                      child: Image.asset(
                        cutFruit.isLeft ? 'assets/melon_cut.png' : 'assets/melon_cut_right.png',
                        height: 80,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
              for (final fruit in fruitList)
                Positioned(
                  top: fruit.position.dy,
                  left: fruit.position.dx,
                  child: Image.asset(
                    'assets/melon_uncut.png',
                    height: 80,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              GestureDetector(
                onScaleStart: (details) {
                  context.read<HomeCubit>().setNewSlice(details);
                },
                onScaleUpdate: (details) {
                  context.read<HomeCubit>()
                    ..addPointToSlice(details)
                    ..checkCollision();
                },
                onScaleEnd: (_) {
                  context.read<HomeCubit>().resetSlice();
                },
              ),
              Positioned(
                right: 24,
                top: 16,
                child: Text(
                  'Score: ${state.score}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          stops: <double>[0.3, 1.0],
          colors: <Color>[Color(0xffFFB75E), Color(0xffED8F03)],
        ),
      ),
    );
  }
}
