class Receipt {
  final int id;
  final String organization;
  final String receiptId;
  final DateTime dateTime;
  final String znKkt;
  final String fdNumber;
  final String paymentType;
  final String transactionType;
  final double amount;
  final bool processed;

  const Receipt({
    required this.id,
    required this.organization,
    required this.receiptId,
    required this.dateTime,
    required this.znKkt,
    required this.fdNumber,
    required this.paymentType,
    required this.transactionType,
    required this.amount,
    required this.processed,
  });
}
