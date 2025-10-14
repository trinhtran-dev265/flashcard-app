import 'package:flashcard_fe/src/features/home/domain/model/kanji_entry.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState(entries: _demoEntries)) {
    on<TabChanged>((e, emit) => emit(state.copyWith(tabIndex: e.index)));
    on<NavChanged>((e, emit) => emit(state.copyWith(navIndex: e.index)));

    on<NextCard>((e, emit) {
      if (state.entries.isEmpty) return;
      final next = (state.current + 1) % state.entries.length;
      emit(state.copyWith(current: next));
    });

    on<PrevCard>((e, emit) {
      if (state.entries.isEmpty) return;
      final prev =
          (state.current - 1 + state.entries.length) % state.entries.length;
      emit(state.copyWith(current: prev));
    });

    on<AddCard>((e, emit) {
      final list = List<KanjiEntry>.from(state.entries)..add(e.entry);
      emit(
        state.copyWith(entries: list, current: list.length - 1, tabIndex: 0),
      );
    });
  }
}

final _demoEntries = <KanjiEntry>[
  KanjiEntry(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    kanji: '日',
    howToRead: 'にち',
    reading: ['にちようび: sunday', 'にほん／にぼん: Japan', 'きょう: Today'],
    listLine: 'にち ・ にちようび ・ にほん／にぼん ・ きょう',
  ),
  KanjiEntry(
    id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),    
    kanji: '月',
    howToRead: 'げつ',
    reading: ['げつようび: monday', 'げつ: month'],
    listLine: 'げつ ・ げつようび ・ げつ',
  ),
  KanjiEntry(
    id: (DateTime.now().millisecondsSinceEpoch + 2).toString(),
    kanji: '火',
    howToRead: 'か',
    reading: ['かようび: tuesday', 'ひ: fire'],
    listLine: 'か ・ かようび ・ ひ',
  ),
];
