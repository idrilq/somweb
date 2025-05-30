import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/providers/roles_provider.dart';
import '../../../../data/models/role.dart';

class RoleEditDialog extends StatefulWidget {
  final Role? role;

  const RoleEditDialog({this.role, super.key});

  @override
  State<RoleEditDialog> createState() => _RoleEditDialogState();
}

class _RoleEditDialogState extends State<RoleEditDialog> {
  late Role _editedRole;
  final Map<String, dynamic> _expandedState = {};

  @override
  void initState() {
    super.initState();
    _editedRole = widget.role ??
        Role(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: 'Новая роль',
          permissions: {
            'receipts': {
              'columns': {
                'id': true,
                'organization': true,
                'receiptId': true,
                'dateTime': true,
                'znkkt': false,
                'fdNumber': false,
                'paymentType': false,
                'transactionType': false,
                'amount': true,
                'processed': true,
              },
              'filters': {
                'organization': true,
                'registrator': false,
                'status': true,
                'dateFrom': true,
                'dateTo': true,
                'receiptId': true,
                'amountFrom': true,
                'amountTo': true,
                'terminal': false,
                'transactionType': false,
              }
            }
          },
        );
  }

  void _togglePermission(String path, bool value) {
    final keys = path.split('.');
    Map<String, dynamic> current = _editedRole.permissions;

    for (int i = 0; i < keys.length - 1; i++) {
      current = current.putIfAbsent(keys[i], () => <String, dynamic>{});
    }

    current[keys.last] = value;
    setState(() {});
  }

  Widget _buildPermissionTree(Map<String, dynamic> permissions, [String path = '']) {
    return Column(
      children: permissions.entries.map((entry) {
        final currentPath = path.isEmpty ? entry.key : '$path.${entry.key}';
        final isExpanded = _expandedState[currentPath] ?? false;

        if (entry.value is Map<String, dynamic>) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(_getPermissionLabel(entry.key)),
                trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                onTap: () => setState(() => _expandedState[currentPath] = !isExpanded),
              ),
              if (isExpanded)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: _buildPermissionTree(entry.value, currentPath),
                ),
            ],
          );
        }

        return CheckboxListTile(
          title: Text(_getPermissionLabel(entry.key)),
          value: entry.value == true,
          onChanged: (v) => _togglePermission(currentPath, v ?? false),
        );
      }).toList(),
    );
  }

  String _getPermissionLabel(String key) {
    switch (key) {
      case 'columns': return 'Столбцы таблицы чеков';
      case 'filters': return 'Фильтры чеков';
      case 'id': return 'ID';
      case 'organization': return 'Организация';
      case 'receiptId': return 'ID чека';
      case 'dateTime': return 'Дата и время';
      case 'znkkt': return 'ЗН ККТ';
      case 'fdNumber': return 'Номер ФД';
      case 'paymentType': return 'Вид оплаты';
      case 'transactionType': return 'Признак расчета';
      case 'amount': return 'Сумма';
      case 'processed': return 'Статус обработки';
      case 'registrator': return 'Регистратор';
      case 'status': return 'Статус';
      case 'dateFrom': return 'Дата с';
      case 'dateTo': return 'Дата до';
      case 'amountFrom': return 'Сумма от';
      case 'amountTo': return 'Сумма до';
      case 'terminal': return 'Терминал';
      default: return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Роль администратора нельзя редактировать
    if (widget.role != null && widget.role!.name.toLowerCase() == 'администратор') {
      return AlertDialog(
        title: const Text('Администратор'),
        content: const Text('Роль администратора нельзя редактировать.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      );
    }

    return AlertDialog(
      title: Text(_editedRole.name),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: _editedRole.name,
              decoration: const InputDecoration(labelText: 'Название роли'),
              onChanged: (v) => setState(() => _editedRole = _editedRole.copyWith(name: v)),
            ),
            const SizedBox(height: 20),
            const Text('Настройте доступные столбцы и фильтры для чеков:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildPermissionTree(_editedRole.permissions['receipts'] ?? {}),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            final rolesProvider = Provider.of<RolesProvider>(context, listen: false);
            if (widget.role == null) {
              rolesProvider.addRole(_editedRole);
            } else {
              rolesProvider.updateRole(_editedRole.id, _editedRole);
            }
            Navigator.pop(context);
          },
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}
