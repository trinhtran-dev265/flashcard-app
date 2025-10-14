import 'dart:async';
import 'package:flashcard_fe/src/features/home/domain/model/kanji_entry.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final List<KanjiEntry>
  source; // dữ liệu để lọc local (MVP). Sau nối API => thay bằng repo.

  SearchBloc({required this.source}) : super(SearchState.initial()) {
    on<QueryChanged>(_onQueryChanged);
    on<QuerySubmitted>(_onSubmit);
    on<QueryCleared>(_onClear);
  }

  Future<void> _onQueryChanged(
    QueryChanged e,
    Emitter<SearchState> emit,
  ) async {
    final q = e.query.trim();
    emit(state.copyWith(query: q, loading: true, error: null, initial: false));

    // (MVP) filter local. Sau này gọi repository/search API ở đây.
    final out = await _filterLocal(q);
    emit(state.copyWith(loading: false, results: out));
  }

  Future<void> _onSubmit(QuerySubmitted e, Emitter<SearchState> emit) async {
    final q = state.query.trim();
    if (q.isEmpty) return;
    emit(state.copyWith(loading: true, error: null, initial: false));
    final out = await _filterLocal(q);
    emit(state.copyWith(loading: false, results: out));
  }

  Future<void> _onClear(QueryCleared e, Emitter<SearchState> emit) async {
    emit(SearchState.initial().copyWith(initial: true));
  }

  Future<List<KanjiEntry>> _filterLocal(String q) async {
    if (q.isEmpty) return [];
    // Giả bộ delay nhẹ cho cảm giác loading
    await Future<void>.delayed(const Duration(milliseconds: 120));

    final lower = q.toLowerCase();
    return source.where((k) {
      final inKanji = k.kanji.contains(q);
      final inHow = (k.howToRead ?? '').toLowerCase().contains(lower);
      final inLine = k.listLine.toLowerCase().contains(lower);
      final inReadings = k.reading.any((r) => r.toLowerCase().contains(lower));
      return inKanji || inHow || inLine || inReadings;
    }).toList();
  }
}
