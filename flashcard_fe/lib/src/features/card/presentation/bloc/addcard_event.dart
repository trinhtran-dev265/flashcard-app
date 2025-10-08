import 'package:equatable/equatable.dart';

abstract class AddCardEvent extends Equatable {
  const AddCardEvent();
  @override
  List<Object?> get props => [];
}

class KanjiChanged extends AddCardEvent {
  final String kanji;
  const KanjiChanged(this.kanji);
  @override
  List<Object?> get props => [kanji];
}

class HowToReadChanged extends AddCardEvent {
  final String text; // field “How to Read”
  const HowToReadChanged(this.text);
  @override
  List<Object?> get props => [text];
}

class RowHiraChanged extends AddCardEvent {
  final int index;
  final String hira;
  const RowHiraChanged(this.index, this.hira);
  @override
  List<Object?> get props => [index, hira];
}

class RowEngChanged extends AddCardEvent {
  final int index;
  final String eng;
  const RowEngChanged(this.index, this.eng);
  @override
  List<Object?> get props => [index, eng];
}

class AddRowPressed extends AddCardEvent {
  const AddRowPressed();
}

class RemoveRowPressed extends AddCardEvent {
  final int index;
  const RemoveRowPressed(this.index);
  @override
  List<Object?> get props => [index];
}

class SavePressed extends AddCardEvent {
  const SavePressed();
}

class ResetForm extends AddCardEvent {
  const ResetForm();
}
