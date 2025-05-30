import 'package:flutter/material.dart';
import '../../../data/models/receipt.dart';

class ReceiptDetailScreen extends StatelessWidget {
  final Receipt receipt;

  const ReceiptDetailScreen({required this.receipt, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Детали чека')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: ListTile(
            title: Text('Чек №${receipt.id}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Организация: ${receipt.organization}'),
                Text('ID чека: ${receipt.receiptId}'),
                Text('Дата: ${receipt.dateTime}'),
                Text('ЗН ККТ: ${receipt.znKkt}'),
                Text('Номер ФД: ${receipt.fdNumber}'),
                Text('Вид оплаты: ${receipt.paymentType}'),
                Text('Признак расчета: ${receipt.transactionType}'),
                Text('Сумма: ${receipt.amount}'),
                Text('Статус: ${receipt.processed ? 'Обработан' : 'Не обработан'}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
