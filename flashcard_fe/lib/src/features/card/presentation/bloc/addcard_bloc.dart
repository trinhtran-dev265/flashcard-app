import 'package:flashcard_fe/src/features/card/presentation/bloc/addcard_event.dart';
import 'package:flashcard_fe/src/features/card/presentation/bloc/addcard_state.dart';
import 'package:flashcard_fe/src/features/home/domain/model/kanji_entry.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCardBloc extends Bloc<AddCardEvent, AddCardState> {
  AddCardBloc() : super(AddCardState.initial()) {
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

  Future<void> _onSave(SavePressed e, Emitter<AddCardState> emit) async {
    if (!state.canSubmit) return;

    // build readings
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
    await Future<void>.delayed(const Duration(milliseconds: 250)); // giả lập

    final entry = KanjiEntry(
      kanji: state.kanji.trim(),
      readings: lines,
      listLine: lines.join(' ・ '),
    );

    emit(state.copyWith(loading: false, success: true, created: entry));
  }
}
