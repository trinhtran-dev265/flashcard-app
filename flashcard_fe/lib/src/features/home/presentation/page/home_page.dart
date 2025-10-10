import 'dart:ui';
import 'package:flashcard_fe/src/features/card/presentation/page/addcard_page.dart';
import 'package:flashcard_fe/src/features/home/domain/model/kanji_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import 'package:flashcard_fe/src/features/profile/presentation/page/profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(),
      child: const _HomeScaffold(),
    );
  }
}

/* ===================== Scaffold & Background ===================== */

class _HomeScaffold extends StatefulWidget {
  const _HomeScaffold();

  @override
  State<_HomeScaffold> createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<_HomeScaffold>
    with SingleTickerProviderStateMixin {
  int _navIndexLocal =
      0; // chỉ để animate NavBar nhanh (UI), state thật nằm trong bloc
  final _flipKey = GlobalKey<_FlipKanjiCardState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          const _LiquidBackground(),
          SafeArea(
            child: Column(
              children: [
                // Title
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Text(
                    'FlashCard Kanji',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Segmented Card/List
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: BlocBuilder<HomeBloc, HomeState>(
                    buildWhen: (p, c) => p.tabIndex != c.tabIndex,
                    builder: (context, state) {
                      return _GlassSegmented(
                        segments: const ['Card', 'List'],
                        index: state.tabIndex,
                        onChanged:
                            (i) => context.read<HomeBloc>().add(TabChanged(i)),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Content
                Expanded(
                  child: Center(
                    child: BlocListener<HomeBloc, HomeState>(
                      listenWhen: (p, c) => p.current != c.current,
                      listener: (context, state) {
                        // Khi đổi thẻ => reset về mặt trước không animation
                        _flipKey.currentState?.resetToFront(instant: true);
                      },
                      child: BlocBuilder<HomeBloc, HomeState>(
                        builder: (context, state) {
                          if (state.tabIndex == 0) {
                            final entry = state.currentEntry;
                            if (entry == null) {
                              return const Text('Chưa có thẻ nào');
                            }
                            final side =
                                MediaQuery.of(context).size.width * 0.6;
                            final size = side.clamp(220.0, 340.0).toDouble();
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _FlipKanjiCard(
                                  key: _flipKey,
                                  size: size,
                                  entry: entry,
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _GlassTextButton(
                                      icon: Icons.flip_camera_android_sharp,
                                      label: 'Flip',
                                      onTap:
                                          () =>
                                              _flipKey.currentState?._toggle(),
                                    ),
                                    const SizedBox(width: 10),
                                    _GlassTextButton(
                                      icon: Icons.navigate_next_rounded,
                                      label: 'Next',
                                      onTap:
                                          () => context.read<HomeBloc>().add(
                                            const NextCard(),
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            return _ListMode();
                          }
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),

      // Bottom Nav
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 18),
        child: BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (p, c) => p.navIndex != c.navIndex,
          builder: (context, state) {
            _navIndexLocal = state.navIndex;
            return _GlassNavBar(
              index: _navIndexLocal,
              items: const [
                Icons.home_rounded,
                Icons.search_rounded,
                Icons.add_circle_outline_rounded,
                Icons.show_chart_rounded,
                Icons.person_rounded,
              ],
              onTap: (i) async {
                // Add
                if (i == 2) {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddCardPage()),
                  );
                  if (result != null) {
                    final entry = KanjiEntry(
                      kanji: result['kanji'] as String,
                      readings:
                          (result['readings'] as List)
                              .map((e) => '$e')
                              .toList(),
                      listLine: result['listLine'] as String,
                    );
                    if (context.mounted) {
                      context.read<HomeBloc>().add(AddCard(entry));
                    }
                  }
                }
                // Profile
                else if (i == 4) {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => const ProfilePage(
                            email: 'demo@demo.com',
                            kanjiCount:
                                3, // có thể thay bằng state.entries.length
                          ),
                    ),
                  );
                }
                // Others: update nav index
                else {
                  context.read<HomeBloc>().add(NavChanged(i));
                }
              },
            );
          },
        ),
      ),
    );
  }
}

/* ===================== Background ===================== */

class _LiquidBackground extends StatelessWidget {
  const _LiquidBackground();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B1734), Color(0xFF302A6B), Color(0xFF0F6C76)],
        ),
      ),
      child: const Stack(
        children: [
          Positioned(right: 24, top: 40, child: _SpecularDot()),
          Positioned(left: 26, bottom: 60, child: _SpecularDot(size: 9)),
        ],
      ),
    );
  }
}

class _SpecularDot extends StatelessWidget {
  final double size;
  const _SpecularDot({this.size = 12});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(blurRadius: 12, spreadRadius: 2, color: Colors.white24),
        ],
        color: Colors.white,
      ),
    );
  }
}

/* ===================== Card Mode (flip) ===================== */

class _FlipKanjiCard extends StatefulWidget {
  final double size;
  final KanjiEntry entry;
  const _FlipKanjiCard({super.key, required this.size, required this.entry});
  @override
  State<_FlipKanjiCard> createState() => _FlipKanjiCardState();
}

class _FlipKanjiCardState extends State<_FlipKanjiCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ac;
  late final Animation<double> _rot;
  bool _front = true;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _rot = CurvedAnimation(parent: _ac, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  void _toggle() async {
    if (_front) {
      await _ac.forward();
    } else {
      await _ac.reverse();
    }
    setState(() => _front = !_front);
  }

  void resetToFront({bool instant = true}) {
    if (!_front) {
      if (instant) {
        _ac.value = 0;
        setState(() => _front = true);
      } else {
        _ac.reverse();
        setState(() => _front = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = Colors.white.withValues(alpha: 0.10);

    return GestureDetector(
      onTap: _toggle,
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity == null) return;
        // trái (âm) => next; phải (dương) => prev
        final bloc = context.read<HomeBloc>();
        if (details.primaryVelocity! < 0) {
          bloc.add(const NextCard());
        } else if (details.primaryVelocity! > 0) {
          bloc.add(const PrevCard());
        }
      },
      child: AnimatedBuilder(
        animation: _rot,
        builder: (context, child) {
          final angle = _rot.value * 3.1415926535;
          final isFront = angle <= 1.5708;
          return Transform(
            alignment: Alignment.center,
            transform:
                Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(angle),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.28),
                      width: 1.2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 100),
                    child:
                        isFront
                            ? Text(
                              widget.entry.kanji,
                              key: const ValueKey('front'),
                              style: Theme.of(
                                context,
                              ).textTheme.displayLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: 80,
                              ),
                            )
                            : Transform(
                              alignment: Alignment.center,
                              transform:
                                  Matrix4.identity()..rotateY(3.1415926535),
                              child: _BackFace(readings: widget.entry.readings),
                            ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BackFace extends StatelessWidget {
  final List<String> readings;
  const _BackFace({required this.readings});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final line in readings)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                line,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(height: 1.2),
              ),
            ),
        ],
      ),
    );
  }
}

/* ===================== List Mode ===================== */

class _ListMode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (p, c) => p.entries != c.entries,
      builder: (context, state) {
        final entries = state.entries;
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: entries.length,
          itemBuilder: (context, i) {
            final e = entries[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.25),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.font_download_rounded,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e.kanji,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                e.listLine,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/* ===================== Small UI components ===================== */

class _GlassTextButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _GlassTextButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
            ),
            child: Row(
              children: [
                Icon(icon, size: 18),
                const SizedBox(width: 6),
                Text(label),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassSegmented extends StatelessWidget {
  final List<String> segments;
  final int index;
  final ValueChanged<int> onChanged;
  const _GlassSegmented({
    required this.segments,
    required this.index,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
          ),
          child: Row(
            children: [
              for (int i = 0; i < segments.length; i++)
                Expanded(
                  child: InkWell(
                    onTap: () => onChanged(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color:
                            i == index
                                ? Colors.white.withValues(alpha: 0.10)
                                : Colors.transparent,
                        borderRadius:
                            i == index ? BorderRadius.circular(14) : null,
                      ),
                      child: Center(
                        child: Text(
                          segments[i],
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: i == index ? Colors.white : Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassNavBar extends StatelessWidget {
  final int index;
  final List<IconData> items;
  final ValueChanged<int> onTap;
  const _GlassNavBar({
    required this.index,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (int i = 0; i < items.length; i++)
                GestureDetector(
                  onTap: () => onTap(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          i == index
                              ? Colors.white.withValues(alpha: 0.12)
                              : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      items[i],
                      color: i == index ? Colors.white : Colors.white70,
                      size: 26,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
