import 'package:flutter/material.dart';
import '../../../data/providers/receipts_provider.dart';

class ReceiptItem extends StatelessWidget {
  final Receipt receipt;

  const ReceiptItem({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(receipt.id),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Магазин: ${receipt.shop}'),
          Text('Терминал: ${receipt.terminal}'),
          Text('Сумма: ${receipt.amount} руб.'),
          Text('Статус: ${receipt.status}'),
        ],
      ),
    );
  }
}
