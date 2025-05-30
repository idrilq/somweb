import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/registrator_connect_provider.dart';

class RegistratorConnectStatus extends StatelessWidget {
  const RegistratorConnectStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final isConnected = context.watch<RegistratorConnectProvider>().isConnected;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isConnected ? Icons.check_circle : Icons.cancel,
          color: isConnected ? Colors.green : Colors.red,
          size: 18,
        ),
        const SizedBox(width: 6),
        Text(
          isConnected ? 'ККТ подключена' : 'Нет подключения',
          style: TextStyle(
            color: isConnected ? Colors.green : Colors.red,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
