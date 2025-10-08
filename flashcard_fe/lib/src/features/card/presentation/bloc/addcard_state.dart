import 'package:equatable/equatable.dart';
import 'package:flashcard_fe/src/features/home/domain/model/kanji_entry.dart';

class ReadingRow extends Equatable {
  final String hira;
  final String eng;
  const ReadingRow({this.hira = '', this.eng = ''});

  ReadingRow copyWith({String? hira, String? eng}) =>
      ReadingRow(hira: hira ?? this.hira, eng: eng ?? this.eng);

  @override
  List<Object?> get props => [hira, eng];
}

class AddCardState extends Equatable {
  final String kanji;
  final String howToRead;
  final List<ReadingRow> rows;
  final bool loading;
  final String? error;
  final bool success;
  final KanjiEntry? created; // entry tạo xong để pop về

  const AddCardState({
    this.kanji = '',
    this.howToRead = '',
    this.rows = const [ReadingRow()],
    this.loading = false,
    this.error,
    this.success = false,
    this.created,
  });

  bool get canAddMore => rows.length < 10;
  bool get hasAnyRow => rows.any((r) => r.hira.trim().isNotEmpty);
  bool get canSubmit => kanji.trim().isNotEmpty && !loading;

  AddCardState copyWith({
    String? kanji,
    String? howToRead,
    List<ReadingRow>? rows,
    bool? loading,
    String? error,
    bool? success,
    KanjiEntry? created,
  }) {
    return AddCardState(
      kanji: kanji ?? this.kanji,
      howToRead: howToRead ?? this.howToRead,
      rows: rows ?? this.rows,
      loading: loading ?? this.loading,
      error: error,
      success: success ?? this.success,
      created: created,
    );
  }

  factory AddCardState.initial() => const AddCardState();

  @override
  List<Object?> get props => [
    kanji,
    howToRead,
    rows,
    loading,
    error,
    success,
    created,
  ];
}
