import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../data/providers/roles_provider.dart';
import '../../../../../data/models/role.dart';
import 'role_edit_dialog.dart'; // теперь файл существует

class RolesSection extends StatelessWidget {
  const RolesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final roles = context.watch<RolesProvider>().roles.values.toList();

    return Column(
      children: [
        ...roles.map((role) => _buildRoleTile(context, role)),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => _showRoleEditDialog(context),
          child: const Text('Создать роль'),
        ),
      ],
    );
  }

  Widget _buildRoleTile(BuildContext context, Role role) {
    return ListTile(
      title: Text(role.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showRoleEditDialog(context, role),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => context.read<RolesProvider>().deleteRole(role.id),
          ),
        ],
      ),
    );
  }

  void _showRoleEditDialog(BuildContext context, [Role? role]) {
    showDialog(
      context: context,
      builder: (_) => RoleEditDialog(role: role),
    );
  }
}
