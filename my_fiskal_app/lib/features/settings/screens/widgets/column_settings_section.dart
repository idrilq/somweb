import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/providers/column_settings_provider.dart';

class ColumnSettingsSection extends StatelessWidget {
  const ColumnSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ColumnSettingsProvider>(context);
    final settings = provider.settings;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: const Text('ID чека'),
          value: settings.showReceiptId,
          onChanged: (v) => provider.updateSettings(
            settings.copyWith(showReceiptId: v),
          ),
        ),
        SwitchListTile(
          title: const Text('Магазин'),
          value: settings.showShop,
          onChanged: (v) => provider.updateSettings(
            settings.copyWith(showShop: v),
          ),
        ),
        SwitchListTile(
          title: const Text('Терминал'),
          value: settings.showTerminal,
          onChanged: (v) => provider.updateSettings(
            settings.copyWith(showTerminal: v),
          ),
        ),
        SwitchListTile(
          title: const Text('Дата и время'),
          value: settings.showDateTime,
          onChanged: (v) => provider.updateSettings(
            settings.copyWith(showDateTime: v),
          ),
        ),
        SwitchListTile(
          title: const Text('Сумма'),
          value: settings.showAmount,
          onChanged: (v) => provider.updateSettings(
            settings.copyWith(showAmount: v),
          ),
        ),
        SwitchListTile(
          title: const Text('Статус'),
          value: settings.showStatus,
          onChanged: (v) => provider.updateSettings(
            settings.copyWith(showStatus: v),
          ),
        ),
        SwitchListTile(
          title: const Text('Признак расчета'),
          value: settings.showTransactionType,
          onChanged: (v) => provider.updateSettings(
            settings.copyWith(showTransactionType: v),
          ),
        ),
        SwitchListTile(
          title: const Text('Вид оплаты'),
          value: settings.showPaymentType,
          onChanged: (v) => provider.updateSettings(
            settings.copyWith(showPaymentType: v),
          ),
        ),
      ],
    );
  }
}
