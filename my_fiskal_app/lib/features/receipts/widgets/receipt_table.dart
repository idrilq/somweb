import 'package:flutter/material.dart';

class Receipt {
  final String id;
  final String shop;
  final String terminal;
  final String date;
  final String amount;
  final String status;
  final String type;

  Receipt({
    required this.id,
    required this.shop,
    required this.terminal,
    required this.date,
    required this.amount,
    required this.status,
    required this.type,
  });
}

final List<Receipt> receipts = [
  Receipt(
    id: '0001',
    shop: 'C1',
    terminal: 'COM_1_1',
    date: '3.1.2025',
    amount: '1000.00',
    status: 'Обработан',
    type: 'Приход',
  ),
  Receipt(
    id: '0002',
    shop: 'C2',
    terminal: 'COM_2_1',
    date: '14.1.2025',
    amount: '1500.00',
    status: 'Обрабатывается',
    type: 'Расход',
  ),
  Receipt(
    id: '0003',
    shop: 'C3',
    terminal: 'COM_3_1',
    date: '25.1.2025',
    amount: '1200.00',
    status: 'Не обработан',
    type: 'Возврат прихода',
  ),
  // ... добавьте остальные строки по необходимости
];

class ReceiptsScreen extends StatelessWidget {
  const ReceiptsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.8, // 4/5 ширины экрана
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: DataTable(
                columnSpacing: 0,
                headingRowColor: WidgetStateProperty.all(const Color(0xFFE3EDFB)),
                dataRowMinHeight: 36,
                dataRowMaxHeight: 44,
                columns: const [
                  DataColumn(label: SizedBox(width: 60, child: Text('ID', textAlign: TextAlign.center))),
                  DataColumn(label: SizedBox(width: 70, child: Text('Магазин', textAlign: TextAlign.center))),
                  DataColumn(label: SizedBox(width: 110, child: Text('Терминал', textAlign: TextAlign.center))),
                  DataColumn(label: SizedBox(width: 80, child: Text('Дата', textAlign: TextAlign.center))),
                  DataColumn(label: SizedBox(width: 80, child: Text('Сумма', textAlign: TextAlign.center))),
                  DataColumn(label: SizedBox(width: 130, child: Text('Статус', textAlign: TextAlign.center))),
                  DataColumn(label: SizedBox(width: 90, child: Text('Тип', textAlign: TextAlign.center))),
                ],
                rows: receipts.asMap().entries.map((entry) {
                  final index = entry.key;
                  final r = entry.value;
                  final isEven = index % 2 == 0;
                  return DataRow(
                    color: WidgetStateProperty.all(
                        isEven ? const Color(0xFFF4F6FA) : Colors.white),
                    cells: [
                      DataCell(SizedBox(width: 60, child: Text(r.id, textAlign: TextAlign.center))),
                      DataCell(SizedBox(width: 70, child: Text(r.shop, textAlign: TextAlign.center))),
                      DataCell(SizedBox(width: 110, child: Text(r.terminal, textAlign: TextAlign.center))),
                      DataCell(SizedBox(width: 80, child: Text(r.date, textAlign: TextAlign.center))),
                      DataCell(SizedBox(width: 80, child: Text(r.amount, textAlign: TextAlign.center))),
                      DataCell(SizedBox(
                        width: 130,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _statusIcon(r.status),
                            const SizedBox(width: 4),
                            Flexible(child: Text(r.status, style: const TextStyle(fontSize: 13))),
                          ],
                        ),
                      )),
                      DataCell(SizedBox(width: 90, child: Text(r.type, textAlign: TextAlign.center))),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget _statusIcon(String status) {
    switch (status) {
      case 'Обработан':
        return const Icon(Icons.check_circle, color: Colors.green, size: 16);
      case 'Ошибки обработки':
        return const Icon(Icons.cancel, color: Colors.red, size: 16);
      case 'Обрабатывается':
        return const Icon(Icons.hourglass_top, color: Colors.orange, size: 16);
      case 'Не обработан':
        return const Icon(Icons.info_outline, color: Colors.grey, size: 16);
      case 'Истек срок обработки':
        return const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 16);
      default:
        return const Icon(Icons.info_outline, color: Colors.grey, size: 16);
    }
  }
}
