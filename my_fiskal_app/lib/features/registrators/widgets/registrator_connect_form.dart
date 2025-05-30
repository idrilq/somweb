import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/registrator_connect_provider.dart';

class RegistratorConnectForm extends StatefulWidget {
  const RegistratorConnectForm({super.key});

  @override
  State<RegistratorConnectForm> createState() => _RegistratorConnectFormState();
}

class _RegistratorConnectFormState extends State<RegistratorConnectForm> {
  final _ipController = TextEditingController();
  final _portController = TextEditingController(text: '7778');
  String? _result;
  bool _loading = false;

  @override
  void dispose() {
    _ipController.dispose();
    _portController.dispose();
    super.dispose();
  }

  Future<void> _connectKkt() async {
    setState(() {
      _loading = true;
      _result = null;
    });
    final provider = Provider.of<RegistratorConnectProvider>(context, listen: false);
    final ok = await provider.connect(_ipController.text, int.tryParse(_portController.text) ?? 0);
    setState(() {
      _loading = false;
      _result = ok ? 'ККТ подключена!' : 'Не удалось подключиться к ККТ';
    });
  }

  Future<void> _sendKktCommand(String name, List<int> packet, List<int> expectedResponse) async {
    setState(() {
      _loading = true;
      _result = null;
    });
    final provider = Provider.of<RegistratorConnectProvider>(context, listen: false);
    final res = await provider.sendCommand(name, packet, expectedResponse);
    if (mounted) {
      setState(() {
        _loading = false;
        _result = res;
      });
      _showSnackbar(res);
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistratorConnectProvider>(context);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ipController,
                    decoration: const InputDecoration(labelText: 'IP ККТ'),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _portController,
                    decoration: const InputDecoration(labelText: 'Порт'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _loading ? null : _connectKkt,
                  child: _loading
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Подключить'),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: 'Очистить логи',
                  onPressed: provider.logs.isEmpty
                      ? null
                      : () => provider.clearLogs(),
                ),
              ],
            ),
            const SizedBox(height: 18),
            if (provider.isConnected)
              Wrap(
                spacing: 12,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.receipt_long),
                    label: const Text('Снять X-отчет'),
                    onPressed: _loading
                        ? null
                        : () => _sendKktCommand(
                              'Снять X-отчет',
                              [0x05, 0x02, 0x05, 0x40, 0x1E, 0x00, 0x00, 0x00, 0x5B, 0x03],
                              [0x02, 0x03, 0x40, 0x00, 0x1E, 0xDB],
                            ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Открыть смену'),
                    onPressed: _loading
                        ? null
                        : () => _sendKktCommand(
                              'Открыть смену',
                              [0x05, 0x02, 0x05, 0xE0, 0x1E, 0x00, 0x00, 0x00, 0xFB, 0x03],
                              [0x02, 0x03, 0xE0, 0x00, 0x1E, 0xFD],
                            ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.stop),
                    label: const Text('Закрыть смену'),
                    onPressed: _loading
                        ? null
                        : () => _sendKktCommand(
                              'Закрыть смену',
                              [0x05, 0x02, 0x05, 0x41, 0x1E, 0x00, 0x00, 0x00, 0x5A, 0x03],
                              [0x02, 0x03, 0x41, 0x00, 0x1E, 0x5C],
                            ),
                  ),
                ],
              ),
            if (_result != null)
              Padding(
                padding: const EdgeInsets.only(top: 18),
                child: Text(
                  _result!,
                  style: TextStyle(
                    color: _result!.startsWith('Ошибка') ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 18),
            const Divider(),
            const Text('Логи ККТ:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(
              height: 180,
              child: provider.logs.isEmpty
                  ? const Center(child: Text('Логи отсутствуют'))
                  : Scrollbar(
                      thumbVisibility: true,
                      child: ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.only(top: 8),
                        itemCount: provider.logs.length,
                        itemBuilder: (context, index) => Text(
                          provider.logs[index],
                          style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
