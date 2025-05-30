import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/providers/terminals_provider.dart';
import 'terminal_edit_dialog.dart';
import '../../../shared/widgets/top_menu_bar.dart';

class TerminalsScreen extends StatelessWidget {
  const TerminalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TerminalsProvider>(context);
    final terminals = provider.terminals;

    return Scaffold(
      appBar: const TopMenuBar(currentRoute: '/terminals'),
      body: terminals.isEmpty
          ? const Center(child: Text('Нет терминалов'))
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: terminals
                    .map(
                      (terminal) => Container(
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                terminal,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => TerminalEditDialog(terminal: terminal),
                                    );
                                  },
                                  child: const Text('Изменить'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    provider.deleteTerminal(terminal);
                                  },
                                  child: const Text(
                                    'Удалить',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const TerminalEditDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
