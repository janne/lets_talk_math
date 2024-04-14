import 'dart:math';

List<int> generateNums({required int count, int size = 3}) => List.generate(count, (_) => Random().nextInt(pow(10, size) as int)).toList();
