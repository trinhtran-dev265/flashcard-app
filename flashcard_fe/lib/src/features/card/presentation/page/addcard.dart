// add_card_page.dart
import 'package:flashcard_fe/src/features/card/presentation/bloc/card_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'card_page.dart';

class AddCardPage extends StatelessWidget {
  const AddCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CardBloc(), // mode add (trạng thái rỗng)
      child: const CardPage(),
    );
  }
}
