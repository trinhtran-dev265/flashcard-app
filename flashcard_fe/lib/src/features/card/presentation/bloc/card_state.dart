import 'package:equatable/equatable.dart';
import 'package:flashcard_fe/src/features/home/domain/model/kanji_entry.dart';

enum CardFormMode { add, edit }

class ReadingRow extends Equatable {
  final String hira;
  final String eng;
  const ReadingRow({this.hira = '', this.eng = ''});

  ReadingRow copyWith({String? hira, String? eng}) =>
      ReadingRow(hira: hira ?? this.hira, eng: eng ?? this.eng);

  @override
  List<Object?> get props => [hira, eng];
}

class CardState extends Equatable {
  final CardFormMode mode; // add | edit
  final String? editingId; // id khi edit
  final String kanji;
  final String howToRead;
  final List<ReadingRow> rows;

  final bool loading;
  final String? error;
  final bool success; // true sau khi Save thành công
  final KanjiEntry? created; // dữ liệu build xong để pop ra ngoài

  final int formVersion;

  const CardState({
    this.mode = CardFormMode.add,
    this.editingId,
    this.kanji = '',
    this.howToRead = '',
    this.rows = const [ReadingRow()],
    this.loading = false,
    this.error,
    this.success = false,
    this.created,
    this.formVersion = 0,
  });

  bool get canAddMore => rows.length < 10;
  bool get hasAnyRow => rows.any((r) => r.hira.trim().isNotEmpty);
  bool get canSubmit {
    if (kanji.trim().isEmpty) return false;
    final hasHow = howToRead.trim().isNotEmpty;
    return (hasHow || hasAnyRow) && !loading;
  }

  CardState copyWith({
    CardFormMode? mode,
    String? editingId,
    String? kanji,
    String? howToRead,
    List<ReadingRow>? rows,
    bool? loading,
    String? error,
    bool? success,
    KanjiEntry? created,
    int? formVersion,
  }) {
    return CardState(
      mode: mode ?? this.mode,
      editingId: editingId ?? this.editingId,
      kanji: kanji ?? this.kanji,
      howToRead: howToRead ?? this.howToRead,
      rows: rows ?? this.rows,
      loading: loading ?? this.loading,
      error: error,
      success: success ?? this.success,
      created: created,
      formVersion: formVersion ?? this.formVersion,
    );
  }

  factory CardState.initial() => const CardState();

  /// Dùng để fill sẵn form khi vào màn Edit
  factory CardState.fromEntryForEdit(KanjiEntry e, {required int version}) {
    final rows =
        e.reading.map((line) {
          final parts = line.split(':');
          final hira = parts.first.trim();
          final eng = parts.length > 1 ? parts.sublist(1).join(':').trim() : '';
          return ReadingRow(hira: hira, eng: eng);
        }).toList();

    return CardState(
      mode: CardFormMode.edit,
      editingId: e.id,
      kanji: e.kanji,
      howToRead: e.howToRead.toString(),
      rows: rows.isEmpty ? const [ReadingRow()] : rows,
      formVersion: version,
    );
  }

  @override
  List<Object?> get props => [
    mode,
    editingId,
    kanji,
    howToRead,
    rows,
    loading,
    error,
    success,
    created,
    formVersion,
  ];
}
