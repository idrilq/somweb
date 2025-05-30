import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/widgets/top_menu_bar.dart';
import '../widgets/receipt_filter.dart';
import '../../../data/providers/receipts_provider.dart';

class ReceiptsScreen extends StatelessWidget {
  const ReceiptsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopMenuBar(currentRoute: '/receipts'),
      body: Consumer<ReceiptsProvider>(
        builder: (context, provider, _) {
          final receipts = provider.filteredReceipts;
          final paymentTotals = _calculatePaymentTotals(receipts);
          final operationTotals = _calculateOperationTotals(receipts);

          return Column(
            children: [
              ReceiptFilter(
                initialQuery: provider.currentFilter,
                onFilterChanged: (query) => provider.applyQuery(query),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    const colCount = 8;
                    final colWidth = (constraints.maxWidth - 32) / colCount;
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: SingleChildScrollView(
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(Colors.blue[50]),
                          columns: [
                            DataColumn(label: SizedBox(width: colWidth, child: const Text('ID', overflow: TextOverflow.ellipsis))),
                            DataColumn(label: SizedBox(width: colWidth, child: const Text('Магазин', overflow: TextOverflow.ellipsis))),
                            DataColumn(label: SizedBox(width: colWidth, child: const Text('Терминал', overflow: TextOverflow.ellipsis))),
                            DataColumn(label: SizedBox(width: colWidth, child: const Text('Дата', overflow: TextOverflow.ellipsis))),
                            DataColumn(label: SizedBox(width: colWidth, child: const Text('Сумма', overflow: TextOverflow.ellipsis))),
                            DataColumn(label: SizedBox(width: colWidth, child: const Text('Статус', overflow: TextOverflow.ellipsis))),
                            DataColumn(label: SizedBox(width: colWidth, child: const Text('Тип', overflow: TextOverflow.ellipsis))),
                            DataColumn(label: SizedBox(width: colWidth, child: const Text('Оплата', overflow: TextOverflow.ellipsis))),
                          ],
                          rows: receipts.map((receipt) {
                            return DataRow(
                              cells: [
                                DataCell(SizedBox(width: colWidth, child: Text(receipt.id, overflow: TextOverflow.ellipsis))),
                                DataCell(SizedBox(width: colWidth, child: Text(receipt.shop, overflow: TextOverflow.ellipsis))),
                                DataCell(SizedBox(width: colWidth, child: Text(receipt.terminal, overflow: TextOverflow.ellipsis))),
                                DataCell(SizedBox(
                                  width: colWidth,
                                  child: Text('${receipt.dateTime.day}.${receipt.dateTime.month}.${receipt.dateTime.year}', overflow: TextOverflow.ellipsis),
                                )),
                                DataCell(SizedBox(
                                  width: colWidth,
                                  child: Text(receipt.amount.toStringAsFixed(2), overflow: TextOverflow.ellipsis),
                                )),
                                DataCell(SizedBox(width: colWidth, child: Text(receipt.status, overflow: TextOverflow.ellipsis))),
                                DataCell(SizedBox(width: colWidth, child: Text(receipt.transactionType, overflow: TextOverflow.ellipsis))),
                                DataCell(SizedBox(width: colWidth, child: Text(receipt.paymentType, overflow: TextOverflow.ellipsis))),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
              ),
              _CollapsibleTotalsCard(
                payments: paymentTotals,
                operations: operationTotals,
              ),
            ],
          );
        },
      ),
    );
  }

  Map<String, double> _calculatePaymentTotals(List receipts) {
    final totals = {'Наличные': 0.0, 'Безналичные': 0.0};
    for (final r in receipts) {
      if (totals.containsKey(r.paymentType)) {
        totals[r.paymentType] = totals[r.paymentType]! + r.amount;
      }
    }
    return totals;
  }

  Map<String, double> _calculateOperationTotals(List receipts) {
    final totals = {
      'Приход': 0.0,
      'Расход': 0.0,
      'Возврат прихода': 0.0,
      'Возврат расхода': 0.0,
    };
    for (final r in receipts) {
      if (totals.containsKey(r.transactionType)) {
        totals[r.transactionType] = totals[r.transactionType]! + r.amount;
      }
    }
    return totals;
  }
}

class _CollapsibleTotalsCard extends StatefulWidget {
  final Map<String, double> payments;
  final Map<String, double> operations;

  const _CollapsibleTotalsCard({
    required this.payments,
    required this.operations,
  });

  @override
  State<_CollapsibleTotalsCard> createState() => _CollapsibleTotalsCardState();
}

class _CollapsibleTotalsCardState extends State<_CollapsibleTotalsCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: const Text(
                'Итоги по текущим фильтрам',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              trailing: IconButton(
                icon: Icon(_isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up),
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
              ),
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
            AnimatedCrossFade(
              firstChild: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTotalRow('Наличные:', widget.payments['Наличные'] ?? 0),
                    _buildTotalRow('Безналичные:', widget.payments['Безналичные'] ?? 0),
                    const Divider(),
                    _buildTotalRow('Приход:', widget.operations['Приход'] ?? 0),
                    _buildTotalRow('Расход:', widget.operations['Расход'] ?? 0),
                    _buildTotalRow('Возврат прихода:', widget.operations['Возврат прихода'] ?? 0),
                    _buildTotalRow('Возврат расхода:', widget.operations['Возврат расхода'] ?? 0),
                  ],
                ),
              ),
              secondChild: const SizedBox.shrink(),
              crossFadeState: _isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 200),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            '${amount.toStringAsFixed(2)} руб.',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
