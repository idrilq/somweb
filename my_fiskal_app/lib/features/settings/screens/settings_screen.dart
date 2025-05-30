import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/widgets/top_menu_bar.dart';
import '../screens/widgets/users_section.dart';
import '../../registrators/widgets/shift_auto_section.dart';
import '../../registrators/providers/shift_auto_provider.dart';
import '../../registrators/providers/registrator_connect_provider.dart';
import '../../registrators/widgets/registrator_connect_status.dart';
// Если нужен RegistratorSettingsScreen — оставьте импорт ниже, иначе удалите
import '../../registrators/screens/registrator_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initAutoShiftCallbacks();
    });
  }

  void _initAutoShiftCallbacks() {
    final shiftProvider = Provider.of<ShiftAutoProvider>(context, listen: false);
    final kktProvider = Provider.of<RegistratorConnectProvider>(context, listen: false);

    shiftProvider.setCallbacks(
      onOpen: () async {
        if (kktProvider.isConnected) {
          final result = await kktProvider.sendCommand(
            'Открыть смену',
            [0x05, 0x02, 0x05, 0xE0, 0x1E, 0x00, 0x00, 0x00, 0xFB, 0x03],
            [0x02, 0x03, 0xE0, 0x00, 0x1E, 0xFD],
          );
          if (mounted) _showResultSnackbar(context, result);
        }
      },
      onClose: () async {
        if (kktProvider.isConnected) {
          final result = await kktProvider.sendCommand(
            'Закрыть смену',
            [0x05, 0x02, 0x05, 0x41, 0x1E, 0x00, 0x00, 0x00, 0x5A, 0x03],
            [0x02, 0x03, 0x41, 0x00, 0x1E, 0x5C],
          );
          if (mounted) _showResultSnackbar(context, result);
        }
      },
    );
  }

  void _showResultSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopMenuBar(currentRoute: '/settings'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const UsersSection(),
            const SizedBox(height: 24),
            const ShiftAutoSection(),
            const SizedBox(height: 24),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.print),
                title: const Text('Подключение ККТ'),
                subtitle: const Text('Настройка и подключение ККТ Ритейл-01ФМ'),
                trailing: const RegistratorConnectStatus(), // ← без const, если конструктор не const
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const RegistratorSettingsScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
