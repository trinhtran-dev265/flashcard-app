import 'package:equatable/equatable.dart';

class KanjiEntry extends Equatable {
  final String kanji;
  final List<String> readings; // mặt sau (mỗi dòng)
  final String listLine; // hiển thị ở List mode

  const KanjiEntry({
    required this.kanji,
    required this.readings,
    required this.listLine,
  });

  @override
  List<Object?> get props => [kanji, readings, listLine];
}
