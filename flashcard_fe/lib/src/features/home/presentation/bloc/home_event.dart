import 'package:equatable/equatable.dart';
import 'package:flashcard_fe/src/features/home/domain/model/kanji_entry.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object?> get props => [];
}

class TabChanged extends HomeEvent {
  final int index; // 0=Card, 1=List
  const TabChanged(this.index);
  @override
  List<Object?> get props => [index];
}

class NavChanged extends HomeEvent {
  final int index; // 0..4
  const NavChanged(this.index);
  @override
  List<Object?> get props => [index];
}

class NextCard extends HomeEvent {
  const NextCard();
}

class PrevCard extends HomeEvent {
  const PrevCard();
}

class AddCard extends HomeEvent {
  final KanjiEntry entry;
  const AddCard(this.entry);
  @override
  List<Object?> get props => [entry];
}

class UpdateCard extends HomeEvent {
  final KanjiEntry entry;
  const UpdateCard(this.entry);
  @override
  List<Object?> get props => [entry];
}

class DeleteCard extends HomeEvent {
  final String id;
  const DeleteCard(this.id);
  @override
  List<Object?> get props => [id];
}
