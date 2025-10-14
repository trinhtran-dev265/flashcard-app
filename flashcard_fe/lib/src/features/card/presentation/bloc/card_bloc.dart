import 'package:flashcard_fe/src/features/card/presentation/bloc/card_event.dart';
import 'package:flashcard_fe/src/features/card/presentation/bloc/card_state.dart';
import 'package:flashcard_fe/src/features/home/domain/model/kanji_entry.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardBloc extends Bloc<CardEvent, AddCardState> {
  CardBloc() : super(AddCardState.initial()) {
    on<KanjiChanged>(
      (e, emit) => emit(
        state.copyWith(
          kanji: e.kanji,
          error: null,
          success: false,
          created: null,
        ),
      ),
    );

    on<HowToReadChanged>(
      (e, emit) => emit(
        state.copyWith(
          howToRead: e.text,
          error: null,
          success: false,
          created: null,
        ),
      ),
    );

    on<RowHiraChanged>((e, emit) {
      if (e.index < 0 || e.index >= state.rows.length) return;
      final list = List<ReadingRow>.from(state.rows);
      list[e.index] = list[e.index].copyWith(hira: e.hira);
      emit(
        state.copyWith(rows: list, error: null, success: false, created: null),
      );
    });

    on<RowEngChanged>((e, emit) {
      if (e.index < 0 || e.index >= state.rows.length) return;
      final list = List<ReadingRow>.from(state.rows);
      list[e.index] = list[e.index].copyWith(eng: e.eng);
      emit(
        state.copyWith(rows: list, error: null, success: false, created: null),
      );
    });

    on<AddRowPressed>((e, emit) {
      if (!state.canAddMore) return;
      emit(state.copyWith(rows: [...state.rows, const ReadingRow()]));
    });

    on<RemoveRowPressed>((e, emit) {
      if (state.rows.length <= 1) return;
      final list = List<ReadingRow>.from(state.rows)..removeAt(e.index);
      emit(state.copyWith(rows: list));
    });

    on<SavePressed>(_onSave);
    on<ResetForm>((e, emit) => emit(AddCardState.initial()));
  }

  void _onPrefill(PrefillForEdit e, Emitter<AddCardState> emit) {
    final entry = e.entry;

    // parse readings "hira: eng" (dòng đầu có thể là howToRead tuỳ cách bạn lưu)
    // Ở app của bạn: howToRead là field riêng, phần readings còn lại là các dòng dưới
    final rows =
        entry.reading.map((line) {
          final parts = line.split(':');
          final hira = parts.first.trim();
          final eng = parts.length > 1 ? parts.sublist(1).join(':').trim() : '';
          return ReadingRow(hira: hira, eng: eng);
        }).toList();

    emit(
      state.copyWith(
        mode: CardFormMode.edit,
        editingId: entry.id,
        kanji: entry.kanji,
        howToRead: entry.howToRead,
        rows: rows.isEmpty ? [const ReadingRow()] : rows,
        error: null,
        success: false,
        created: null,
      ),
    );
  }

  Future<void> _onSave(SavePressed e, Emitter<AddCardState> emit) async {
    if (!state.canSubmit) return;

    // build readings lines
    final lines = <String>[];
    if (state.howToRead.trim().isNotEmpty) {
      lines.add(state.howToRead.trim());
    }
    for (final r in state.rows) {
      final hira = r.hira.trim();
      if (hira.isEmpty) continue;
      final eng = r.eng.trim();
      lines.add(eng.isEmpty ? hira : '$hira: $eng');
    }

    if (lines.isEmpty) {
      emit(
        state.copyWith(error: 'Hãy nhập ít nhất 1 dòng đọc.', success: false),
      );
      return;
    }

    emit(
      state.copyWith(loading: true, error: null, success: false, created: null),
    );
    await Future<void>.delayed(
      const Duration(milliseconds: 250),
    ); // giả lập I/O

    final isEdit = state.mode == CardFormMode.edit;
    final id =
        isEdit
            ? (state.editingId ??
                DateTime.now().millisecondsSinceEpoch.toString())
            : DateTime.now().millisecondsSinceEpoch.toString();

    final entry = KanjiEntry(
      id: id,
      kanji: state.kanji.trim(),
      howToRead: state.howToRead.trim(),
      reading: lines,
      listLine: lines.join(' ・ '),
    );

    // success = true để page pop result ra ngoài
    emit(state.copyWith(loading: false, success: true, created: entry));
  }
}
