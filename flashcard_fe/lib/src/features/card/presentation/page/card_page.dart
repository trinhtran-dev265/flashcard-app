import 'dart:ui';
import 'package:flashcard_fe/src/features/card/presentation/bloc/card_state.dart';
import 'package:flashcard_fe/src/features/card/presentation/bloc/card_bloc.dart';
import 'package:flashcard_fe/src/features/card/presentation/bloc/card_event.dart';
import 'package:flashcard_fe/src/features/home/domain/model/kanji_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardPage extends StatelessWidget {
  const CardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.88;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // Tiêu đề theo mode
        title: BlocBuilder<CardBloc, CardState>(
          buildWhen: (p, c) => p.mode != c.mode,
          builder:
              (context, state) => Text(
                state.mode == CardFormMode.edit
                    ? 'Edit Flashcard'
                    : 'New Flashcard',
              ),
        ),
        backgroundColor: Colors.transparent,
        // Nút delete chỉ hiện khi edit
        actions: [
          BlocBuilder<CardBloc, CardState>(
            buildWhen: (p, c) => p.mode != c.mode || p.kanji != c.kanji,
            builder: (context, state) {
              if (state.mode != CardFormMode.edit) {
                return const SizedBox.shrink();
              }
              return IconButton(
                icon: const Icon(Icons.delete_outline_rounded),
                onPressed: () async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder:
                        (ctx) => AlertDialog(
                          title: const Text('Xoá thẻ?'),
                          content: Text(
                            'Bạn có chắc muốn xoá "${state.kanji}"?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Huỷ'),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Xoá'),
                            ),
                          ],
                        ),
                  );
                  if (ok == true && context.mounted) {
                    Navigator.pop(context, {
                      'mode': 'delete',
                      'id': context.read<CardBloc>().state.editingId,
                    });
                  }
                },
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // BG
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
            child: BlocConsumer<CardBloc, CardState>(
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
                    'mode': state.mode == CardFormMode.edit ? 'edit' : 'add',
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
                              TextFormField(
                                key:
                                    state.mode == CardFormMode.edit
                                        ? ValueKey(
                                          'kanji-${state.mode}-${state.editingId}-${state.formVersion}',
                                        )
                                        : const ValueKey('kanji-add'),
                                initialValue: state.kanji,
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
                              TextFormField(
                                key:
                                    state.mode == CardFormMode.edit
                                        ? ValueKey(
                                          'how-${state.mode}-${state.editingId}-${state.formVersion}',
                                        )
                                        : const ValueKey('how-add'),
                                initialValue: state.howToRead,
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

                              // Rows
                              for (int i = 0; i < state.rows.length; i++)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 5,
                                        child: TextFormField(
                                          key: ValueKey(
                                            'row-$i-h-${state.formVersion}-${state.rows.length}',
                                          ),
                                          initialValue: state.rows[i].hira,
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
                                        key: ValueKey(
                                          'row-$i-e-${state.formVersion}-${state.rows.length}',
                                        ),
                                        child: TextFormField(
                                          initialValue: state.rows[i].eng,
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
