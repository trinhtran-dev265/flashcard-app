import 'package:equatable/equatable.dart';

class KanjiEntry extends Equatable {
  final String id;
  final String kanji;
  final String? howToRead;
  final List<String> reading; // mặt sau (mỗi dòng)
  final String listLine; // hiển thị ở List mode

  const KanjiEntry({
    required this.id,
    required this.kanji,
    required this.howToRead,
    required this.reading,
    required this.listLine,
  });

  @override
  List<Object?> get props => [id, kanji, howToRead, reading, listLine];
}
