import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
  @override
  List<Object?> get props => [];
}

class QueryChanged extends SearchEvent {
  final String query;
  const QueryChanged(this.query);
  @override
  List<Object?> get props => [query];
}

class QuerySubmitted extends SearchEvent {
  const QuerySubmitted();
}

class QueryCleared extends SearchEvent {
  const QueryCleared();
}
