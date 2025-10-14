import 'dart:ui';
import 'package:flashcard_fe/src/features/card/presentation/bloc/addcard_state.dart';
import 'package:flashcard_fe/src/features/card/presentation/bloc/card_bloc.dart';
import 'package:flashcard_fe/src/features/card/presentation/bloc/card_event.dart';
import 'package:flashcard_fe/src/features/home/domain/model/kanji_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCardPage extends StatelessWidget {
  const AddCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CardBloc(),
      child: const _AddCardScaffold(),
    );
  }
}

class _AddCardScaffold extends StatelessWidget {
  const _AddCardScaffold();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.88;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('New Flashcard'),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          // iOS26 gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1B1734),
                  Color(0xFF302A6B),
                  Color(0xFF0F6C76),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          SafeArea(
            child: BlocConsumer<CardBloc, AddCardState>(
              listenWhen:
                  (p, c) => p.success != c.success || p.error != c.error,
              listener: (context, state) {
                if (state.error != null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.error!)));
                }
                if (state.success && state.created != null) {
                  final KanjiEntry e = state.created!;
                  Navigator.pop(context, {
                    'id': e.id,
                    'kanji': e.kanji,
                    'howToRead': e.howToRead,
                    'readings': e.reading,
                    'listLine': e.listLine,
                  });
                }
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(26),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                        child: Container(
                          width: width,
                          margin: const EdgeInsets.symmetric(vertical: 30),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.25),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Kanji
                              TextField(
                                onChanged:
                                    (v) => context.read<CardBloc>().add(
                                      KanjiChanged(v),
                                    ),
                                style: const TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  hintText: 'Kanji (ex: 日)',
                                  border: InputBorder.none,
                                ),
                              ),

                              const SizedBox(height: 12),

                              // How to Read
                              TextField(
                                onChanged:
                                    (v) => context.read<CardBloc>().add(
                                      HowToReadChanged(v),
                                    ),
                                decoration: const InputDecoration(
                                  hintText: 'How to Read',
                                  border: OutlineInputBorder(),
                                ),
                                style: const TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                              ),

                              const SizedBox(height: 24),

                              // Dynamic rows
                              for (int i = 0; i < state.rows.length; i++)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 5,
                                        child: TextField(
                                          onChanged:
                                              (v) => context
                                                  .read<CardBloc>()
                                                  .add(RowHiraChanged(i, v)),
                                          decoration: const InputDecoration(
                                            hintText: 'Hiragana',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        flex: 5,
                                        child: TextField(
                                          onChanged:
                                              (v) => context
                                                  .read<CardBloc>()
                                                  .add(RowEngChanged(i, v)),
                                          decoration: const InputDecoration(
                                            hintText: 'Eng',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                      if (state.rows.length > 1)
                                        IconButton(
                                          icon: const Icon(
                                            Icons.remove_circle_outline,
                                            color: Colors.redAccent,
                                          ),
                                          onPressed:
                                              () => context
                                                  .read<CardBloc>()
                                                  .add(RemoveRowPressed(i)),
                                        ),
                                    ],
                                  ),
                                ),

                              if (state.canAddMore)
                                TextButton.icon(
                                  onPressed:
                                      () => context.read<CardBloc>().add(
                                        const AddRowPressed(),
                                      ),
                                  icon: const Icon(
                                    Icons.add_circle_outline_rounded,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    'More line',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ),

                              const SizedBox(height: 20),

                              // Buttons
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(Icons.close_rounded),
                                    label: const Text('Cancel'),
                                  ),
                                  FilledButton.icon(
                                    onPressed:
                                        state.canSubmit
                                            ? () => context
                                                .read<CardBloc>()
                                                .add(const SavePressed())
                                            : null,
                                    icon:
                                        state.loading
                                            ? const SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            )
                                            : const Icon(Icons.save_rounded),
                                    label: const Text('Save'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
