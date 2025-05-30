import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/registrator_connect_provider.dart';

class KkmLogScreen extends StatelessWidget {
  const KkmLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RegistratorConnectProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Логи ККТ'),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                tooltip: 'Очистить логи',
                onPressed: provider.logs.isEmpty
                    ? null
                    : provider.clearLogs,
              ),
            ],
          ),
          body: provider.logs.isEmpty
              ? const Center(child: Text('Логи отсутствуют'))
              : ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(12),
                  itemCount: provider.logs.length,
                  itemBuilder: (context, index) => Text(
                    provider.logs[index],
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
        );
      },
    );
  }
}
