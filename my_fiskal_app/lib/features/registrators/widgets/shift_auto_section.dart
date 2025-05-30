import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shift_auto_provider.dart';

class ShiftAutoSection extends StatelessWidget {
  const ShiftAutoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShiftAutoProvider>(
      builder: (context, provider, _) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Автоматическое закрытие/открытие смен', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                SwitchListTile(
                  title: const Text('Включить автоматическое открытие/закрытие смен'),
                  value: provider.enabled,
                  onChanged: (val) {
                    provider.setEnabled(val);
                    provider.restartScheduler();
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text('Время открытия смены'),
                        subtitle: Text(provider.openTime.format(context)),
                        trailing: IconButton(
                          icon: const Icon(Icons.access_time),
                          onPressed: !provider.enabled
                              ? null
                              : () async {
                                  final picked = await showTimePicker(
                                    context: context,
                                    initialTime: provider.openTime,
                                  );
                                  if (picked != null) {
                                    provider.setOpenTime(picked);
                                    provider.restartScheduler();
                                  }
                                },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text('Время закрытия смены'),
                        subtitle: Text(provider.closeTime.format(context)),
                        trailing: IconButton(
                          icon: const Icon(Icons.access_time),
                          onPressed: !provider.enabled
                              ? null
                              : () async {
                                  final picked = await showTimePicker(
                                    context: context,
                                    initialTime: provider.closeTime,
                                  );
                                  if (picked != null) {
                                    provider.setCloseTime(picked);
                                    provider.restartScheduler();
                                  }
                                },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Текущее время: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    _LiveTimeText(),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LiveTimeText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime>(
      stream: Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now()),
      builder: (context, snapshot) {
        final now = snapshot.data ?? DateTime.now();
        final time = TimeOfDay.fromDateTime(now).format(context);
        return Text(
          time,
          style: const TextStyle(fontSize: 16),
        );
      },
    );
  }
}
