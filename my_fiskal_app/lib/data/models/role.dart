class Role {
  final String id;
  final String name;
  final Map<String, dynamic> permissions;

  const Role({
    required this.id,
    required this.name,
    required this.permissions,
  });

  bool hasPermission(String path) {
    final parts = path.split('.');
    dynamic current = permissions;
    
    for (final part in parts) {
      if (current is! Map<String, dynamic>) return false;
      current = current[part];
      if (current == null) return false;
    }
    
    return current == true;
  }

  Role copyWith({
    String? id,
    String? name,
    Map<String, dynamic>? permissions,
  }) {
    return Role(
      id: id ?? this.id,
      name: name ?? this.name,
      permissions: permissions ?? Map.from(this.permissions),
    );
  }

  static Role admin() {
    return const Role(
      id: 'admin',
      name: 'Администратор',
      permissions: {
        'terminals': true,
        'receipts': {
          'view': true,
          'columns': {
            'id': true,
            'organization': true,
            'receiptId': true,
            'dateTime': true,
            'znkkt': true,
            'fdNumber': true,
            'paymentType': true,
            'transactionType': true,
            'amount': true,
            'processed': true,
          },
          'filters': {
            'organization': true,
            'registrator': true,
            'status': true,
            'dateFrom': true,
            'dateTo': true,
            'receiptId': true,
            'amountFrom': true,
            'amountTo': true,
            'terminal': true,
            'transactionType': true,
          },
        },
      },
    );
  }

  static Role user() {
    return const Role(
      id: 'user',
      name: 'Пользователь',
      permissions: {
        'terminals': true,
        'receipts': {
          'view': true,
          'columns': {
            'id': true,
            'organization': false,
            'receiptId': true,
            'dateTime': true,
          },
        },
      },
    );
  }
}
