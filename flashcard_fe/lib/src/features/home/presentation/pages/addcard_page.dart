import 'dart:ui';
import 'package:flutter/material.dart';

class AddCardPage extends StatefulWidget {
  const AddCardPage({super.key});

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  final _kanjiCtrl = TextEditingController();
  final List<_ReadingRow> _rows = [_ReadingRow()]; // bắt đầu với 1 hàng

  void _addRow() {
    if (_rows.length < 10) {
      setState(() => _rows.add(_ReadingRow()));
    }
  }

  void _removeRow(int index) {
    setState(() => _rows.removeAt(index));
  }

  void _onSave() {
    final kanji = _kanjiCtrl.text.trim();
    if (kanji.isEmpty) return;

    final readings =
        _rows.where((r) => r.hira.text.isNotEmpty).map((r) {
          final hira = r.hira.text.trim();
          final eng = r.eng.text.trim();
          return eng.isEmpty ? hira : "$hira: $eng";
        }).toList();

    Navigator.pop(context, {
      'kanji': kanji,
      'readings': readings,
      'listLine': readings.join(' ・ '),
    });
  }

  @override
  void dispose() {
    _kanjiCtrl.dispose();
    for (var r in _rows) {
      r.dispose();
    }
    super.dispose();
  }

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
          // Background blur iOS26 style
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
            child: SingleChildScrollView(
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
                          TextField(
                            controller: _kanjiCtrl,
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
                          TextField(
                            decoration: const InputDecoration(
                              hintText: 'How to Read',
                              border: OutlineInputBorder(),
                            ),
                            style: const TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          for (int i = 0; i < _rows.length; i++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: TextField(
                                      controller: _rows[i].hira,
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
                                      controller: _rows[i].eng,
                                      decoration: const InputDecoration(
                                        hintText: 'Eng',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  if (_rows.length > 1)
                                    IconButton(
                                      icon: const Icon(
                                        Icons.remove_circle_outline,
                                        color: Colors.redAccent,
                                      ),
                                      onPressed: () => _removeRow(i),
                                    ),
                                ],
                              ),
                            ),

                          if (_rows.length < 10)
                            TextButton.icon(
                              onPressed: _addRow,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.close_rounded),
                                label: const Text('Cancel'),
                              ),
                              FilledButton.icon(
                                onPressed: _onSave,
                                icon: const Icon(Icons.save_rounded),
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
            ),
          ),
        ],
      ),
    );
  }
}

/// Controller đôi cho từng hàng đọc-nghĩa
class _ReadingRow {
  final TextEditingController hira = TextEditingController();
  final TextEditingController eng = TextEditingController();
  void dispose() {
    hira.dispose();
    eng.dispose();
  }
}
