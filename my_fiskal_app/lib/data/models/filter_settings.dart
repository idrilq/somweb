class FilterSettings {
  final bool showReceiptId;
  final bool showShop;
  final bool showTerminal;
  final bool showDateRange;
  final bool showAmountRange;
  final bool showStatus;
  final bool showTransactionType;
  final bool showPaymentType;

  const FilterSettings({
    this.showReceiptId = true,
    this.showShop = true,
    this.showTerminal = true,
    this.showDateRange = true,
    this.showAmountRange = true,
    this.showStatus = true,
    this.showTransactionType = true,
    this.showPaymentType = true,
  });

  FilterSettings copyWith({
    bool? showReceiptId,
    bool? showShop,
    bool? showTerminal,
    bool? showDateRange,
    bool? showAmountRange,
    bool? showStatus,
    bool? showTransactionType,
    bool? showPaymentType,
  }) {
    return FilterSettings(
      showReceiptId: showReceiptId ?? this.showReceiptId,
      showShop: showShop ?? this.showShop,
      showTerminal: showTerminal ?? this.showTerminal,
      showDateRange: showDateRange ?? this.showDateRange,
      showAmountRange: showAmountRange ?? this.showAmountRange,
      showStatus: showStatus ?? this.showStatus,
      showTransactionType: showTransactionType ?? this.showTransactionType,
      showPaymentType: showPaymentType ?? this.showPaymentType,
    );
  }
}
