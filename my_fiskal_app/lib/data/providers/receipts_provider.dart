import 'package:flutter/material.dart';

class Receipt {
  final String id;
  final String shop;
  final String terminal;
  final DateTime dateTime;
  final double amount;
  final String status;
  final String transactionType;
  final String paymentType;

  const Receipt({
    required this.id,
    required this.shop,
    required this.terminal,
    required this.dateTime,
    required this.amount,
    required this.status,
    required this.transactionType,
    required this.paymentType,
  });
}

class ReceiptQuery {
  final String? containsId;
  final Set<String>? shops;
  final Set<String>? terminals;
  final DateTimeRange? dateRange;
  final RangeValues? amountRange;
  final Set<String>? statuses;
  final Set<String>? transactionTypes;
  final Set<String>? paymentTypes;

  const ReceiptQuery({
    this.containsId,
    this.shops,
    this.terminals,
    this.dateRange,
    this.amountRange,
    this.statuses,
    this.transactionTypes,
    this.paymentTypes,
  });

  bool fits(Receipt receipt) {
    if (containsId != null && containsId!.isNotEmpty && !receipt.id.contains(containsId!)) {
      return false;
    }
    if (shops != null && shops!.isNotEmpty && !shops!.contains(receipt.shop)) {
      return false;
    }
    if (terminals != null && terminals!.isNotEmpty && !terminals!.contains(receipt.terminal)) {
      return false;
    }
    if (dateRange != null &&
        (receipt.dateTime.isBefore(dateRange!.start) || receipt.dateTime.isAfter(dateRange!.end))) {
      return false;
    }
    if (amountRange != null &&
        (receipt.amount < amountRange!.start || receipt.amount > amountRange!.end)) {
      return false;
    }
    if (statuses != null && statuses!.isNotEmpty && !statuses!.contains(receipt.status)) {
      return false;
    }
    if (transactionTypes != null && transactionTypes!.isNotEmpty && !transactionTypes!.contains(receipt.transactionType)) {
      return false;
    }
    if (paymentTypes != null && paymentTypes!.isNotEmpty && !paymentTypes!.contains(receipt.paymentType)) {
      return false;
    }
    return true;
  }
}

class ReceiptsProvider extends ChangeNotifier {
  final List<Receipt> _receipts = []; // <-- Теперь список пустой

  ReceiptQuery _currentFilter = const ReceiptQuery();
  ReceiptQuery get currentFilter => _currentFilter;

  List<Receipt> filteredReceipts = [];

  ReceiptsProvider() {
    filteredReceipts = List.from(_receipts);
  }

  void applyQuery(ReceiptQuery query) {
    _currentFilter = query;
    filteredReceipts = _receipts.where((r) => query.fits(r)).toList();
    notifyListeners();
  }

  void resetFilters() {
    _currentFilter = const ReceiptQuery();
    filteredReceipts = List.from(_receipts);
    notifyListeners();
  }

  // Добавьте методы для загрузки реальных чеков из API/БД, если нужно:
  void setReceipts(List<Receipt> receipts) {
    _receipts.clear();
    _receipts.addAll(receipts);
    applyQuery(_currentFilter);
  }
}
