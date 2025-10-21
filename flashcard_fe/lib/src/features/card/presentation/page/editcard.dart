// edit_card_page.dart
import 'package:flashcard_fe/src/features/card/presentation/bloc/card_bloc.dart';
import 'package:flashcard_fe/src/features/card/presentation/bloc/card_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home/domain/model/kanji_entry.dart';
import 'card_page.dart';

class EditCardPage extends StatelessWidget {
  final KanjiEntry entry;
  const EditCardPage({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => CardBloc()..add(PrefillForEdit(entry)), // đẩy dữ liệu vào form
      child: const CardPage(),
    );
  }
}
