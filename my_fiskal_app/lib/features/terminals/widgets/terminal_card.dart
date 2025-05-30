import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/providers/terminals_provider.dart';

class TerminalCard extends StatelessWidget {
  final String terminal;
  const TerminalCard({super.key, required this.terminal});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(terminal),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            Provider.of<TerminalsProvider>(context, listen: false)
                .deleteTerminal(terminal);
          },
        ),
      ),
    );
  }
}
