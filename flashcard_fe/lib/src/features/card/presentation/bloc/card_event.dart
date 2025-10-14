import 'package:equatable/equatable.dart';
import 'package:flashcard_fe/src/features/home/domain/model/kanji_entry.dart';

abstract class CardEvent extends Equatable {
  const CardEvent();
  @override
  List<Object?> get props => [];
}

/// Vào màn Edit thì bắn event này để fill sẵn form
class PrefillForEdit extends CardEvent {
  final KanjiEntry entry;
  const PrefillForEdit(this.entry);
  @override
  List<Object?> get props => [entry];
}

class KanjiChanged extends CardEvent {
  final String kanji;
  const KanjiChanged(this.kanji);
  @override
  List<Object?> get props => [kanji];
}

class HowToReadChanged extends CardEvent {
  final String text;
  const HowToReadChanged(this.text);
  @override
  List<Object?> get props => [text];
}

class RowHiraChanged extends CardEvent {
  final int index;
  final String hira;
  const RowHiraChanged(this.index, this.hira);
  @override
  List<Object?> get props => [index, hira];
}

class RowEngChanged extends CardEvent {
  final int index;
  final String eng;
  const RowEngChanged(this.index, this.eng);
  @override
  List<Object?> get props => [index, eng];
}

class AddRowPressed extends CardEvent {
  const AddRowPressed();
}

class RemoveRowPressed extends CardEvent {
  final int index;
  const RemoveRowPressed(this.index);
  @override
  List<Object?> get props => [index];
}

class SavePressed extends CardEvent {
  const SavePressed();
}

class ResetForm extends CardEvent {
  const ResetForm();
}
