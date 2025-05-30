import 'package:flutter/material.dart';
import '../widgets/registrator_connect_form.dart';
import '../widgets/registrator_connect_status.dart';

class RegistratorSettingsScreen extends StatelessWidget {
  const RegistratorSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки ККТ')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: RegistratorConnectStatus(),
                    ),
                    SizedBox(height: 8),
                    RegistratorConnectForm(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
