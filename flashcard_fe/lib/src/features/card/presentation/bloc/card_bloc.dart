import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flashcard_fe/src/features/home/domain/model/kanji_entry.dart';
import 'card_event.dart';
import 'card_state.dart';

class CardBloc extends Bloc<CardEvent, CardState> {
  CardBloc() : super(CardState.initial()) {
    on<PrefillForEdit>((e, emit) {
      final nextVersion = state.formVersion + 1;
      emit(CardState.fromEntryForEdit(e.entry, version: nextVersion));
    });

    on<KanjiChanged>((e, emit) {
      emit(
        state.copyWith(
          kanji: e.kanji,
          error: null,
          success: false,
          created: null,
        ),
      );
    });

    on<HowToReadChanged>((e, emit) {
      emit(
        state.copyWith(
          howToRead: e.text,
          error: null,
          success: false,
          created: null,
        ),
      );
    });

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
    on<ResetForm>(
      (e, emit) => emit(
        CardState.initial().copyWith(formVersion: state.formVersion + 1),
      ),
    );
  }

  Future<void> _onSave(SavePressed e, Emitter<CardState> emit) async {
    if (!state.canSubmit) return;

    // build lines: howToRead (nếu có) + các hàng “hira: eng”
    final lines = <String>[];

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
      const Duration(milliseconds: 200),
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
      listLine: preview,
    );

    emit(state.copyWith(loading: false, success: true, created: entry));
  }
}
