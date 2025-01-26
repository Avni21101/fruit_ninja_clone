part of 'home_cubit.dart';

class HomeState extends Equatable {
  const HomeState({
    this.pointsList = const [],
    this.fruitList = const [],
    this.fruitPartList = const [],
    this.tickCount = 0,
    this.score = 0,
  });

  final List<Offset> pointsList;
  final List<Fruit> fruitList;
  final List<FruitPart> fruitPartList;
  final int tickCount;
  final int score;

  @override
  List<Object?> get props => [
        pointsList,
        fruitList,
        fruitPartList,
        tickCount,
        score,
      ];

  HomeState copyWith({
    List<Offset>? pointsList,
    List<Fruit>? fruitList,
    List<FruitPart>? fruitPartList,
    int? tickCount,
    int? score,
  }) {
    return HomeState(
      pointsList: pointsList ?? this.pointsList,
      fruitList: fruitList ?? this.fruitList,
      fruitPartList: fruitPartList ?? this.fruitPartList,
      tickCount: tickCount ?? this.tickCount,
      score: score ?? this.score,
    );
  }
}
