class ColumnSettings {
  final bool showReceiptId;
  final bool showShop;
  final bool showTerminal;
  final bool showDateTime;
  final bool showAmount;
  final bool showStatus;
  final bool showTransactionType;
  final bool showPaymentType;

  const ColumnSettings({
    this.showReceiptId = true,
    this.showShop = true,
    this.showTerminal = true,
    this.showDateTime = true,
    this.showAmount = true,
    this.showStatus = true,
    this.showTransactionType = true,
    this.showPaymentType = true,
  });

  ColumnSettings copyWith({
    bool? showReceiptId,
    bool? showShop,
    bool? showTerminal,
    bool? showDateTime,
    bool? showAmount,
    bool? showStatus,
    bool? showTransactionType,
    bool? showPaymentType,
  }) {
    return ColumnSettings(
      showReceiptId: showReceiptId ?? this.showReceiptId,
      showShop: showShop ?? this.showShop,
      showTerminal: showTerminal ?? this.showTerminal,
      showDateTime: showDateTime ?? this.showDateTime,
      showAmount: showAmount ?? this.showAmount,
      showStatus: showStatus ?? this.showStatus,
      showTransactionType: showTransactionType ?? this.showTransactionType,
      showPaymentType: showPaymentType ?? this.showPaymentType,
    );
  }
}
