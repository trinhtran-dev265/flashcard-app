import 'package:equatable/equatable.dart';
import 'package:flashcard_fe/src/features/home/domain/model/kanji_entry.dart';

class HomeState extends Equatable {
  final int tabIndex; // Card / List
  final int navIndex; // bottom nav
  final int current; // index thẻ hiện tại
  final List<KanjiEntry> entries;

  const HomeState({
    this.tabIndex = 0,
    this.navIndex = 0,
    this.current = 0,
    this.entries = const [],
  });

  bool get isEmpty => entries.isEmpty;
  KanjiEntry? get currentEntry =>
      (entries.isEmpty || current < 0 || current >= entries.length)
          ? null
          : entries[current];

  HomeState copyWith({
    int? tabIndex,
    int? navIndex,
    int? current,
    List<KanjiEntry>? entries,
  }) {
    return HomeState(
      tabIndex: tabIndex ?? this.tabIndex,
      navIndex: navIndex ?? this.navIndex,
      current: current ?? this.current,
      entries: entries ?? this.entries,
    );
  }

  @override
  List<Object?> get props => [tabIndex, navIndex, current, entries];
}
