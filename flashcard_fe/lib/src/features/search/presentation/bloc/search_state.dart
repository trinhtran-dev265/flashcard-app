import 'package:equatable/equatable.dart';
import 'package:flashcard_fe/src/features/home/domain/model/kanji_entry.dart';

class SearchState extends Equatable {
  final String query;
  final bool loading;
  final String? error;
  final List<KanjiEntry> results;
  final bool initial;

  const SearchState({
    this.query = '',
    this.loading = false,
    this.error,
    this.results = const [],
    this.initial = true,
  });

  bool get hasResults => results.isNotEmpty;

  SearchState copyWith({
    String? query,
    bool? loading,
    String? error,
    List<KanjiEntry>? results,
    bool? initial,
  }) => SearchState(
    query: query ?? this.query,
    loading: loading ?? this.loading,
    error: error,
    results: results ?? this.results,
    initial: initial ?? this.initial,
  );

  factory SearchState.initial() => const SearchState();
  
  @override
  List<Object?> get props => [query, loading, error, results, initial];
}
