import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/providers/users_provider.dart';
import '../../../../data/models/user.dart';

class UsersSection extends StatelessWidget {
  const UsersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final usersProvider = Provider.of<UsersProvider>(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.person_add),
              label: const Text('Создать пользователя'),
              onPressed: () => _showCreateDialog(context),
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 400),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: usersProvider.users.length,
                itemBuilder: (context, index) {
                  final user = usersProvider.users[index];
                  return ListTile(
                    title: Text(user.username),
                    subtitle: Text(user.role == 'admin' ? 'Администратор' : 'Пользователь'),
                   trailing: Row(
                       mainAxisSize: MainAxisSize.min,
                         children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showEditDialog(context, user),
                         ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => usersProvider.deleteUser(user.id),
                         ),
                        ],
                      ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const _UserDialog(),
    );
  }

  void _showEditDialog(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (_) => _UserDialog(user: user),
    );
  }
}

class _UserDialog extends StatefulWidget {
  final User? user;
  const _UserDialog({this.user});

  @override
  State<_UserDialog> createState() => _UserDialogState();
}

class _UserDialogState extends State<_UserDialog> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  String _role = 'user';

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user?.username ?? '');
    _passwordController = TextEditingController(text: widget.user?.password ?? '');
    _role = widget.user?.role ?? 'user';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.user != null;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 340),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isEdit ? 'Редактировать пользователя' : 'Создать пользователя',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Логин',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Пароль',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                obscureText: true,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField(
                value: _role,
                items: const [
                  DropdownMenuItem(value: 'user', child: Text('Пользователь')),
                  DropdownMenuItem(value: 'admin', child: Text('Администратор')),
                ],
                onChanged: isEdit && widget.user!.role == 'admin'
                    ? null
                    : (v) => setState(() => _role = v as String),
                decoration: const InputDecoration(
                  labelText: 'Роль',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Отмена'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      final usersProvider = Provider.of<UsersProvider>(context, listen: false);
                      if (isEdit) {
                        usersProvider.updateUser(
                          widget.user!.id,
                          widget.user!.copyWith(
                            username: _usernameController.text,
                            password: _passwordController.text,
                            role: _role,
                          ),
                        );
                      } else {
                        usersProvider.addUser(
                          User(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            username: _usernameController.text,
                            password: _passwordController.text,
                            role: _role,
                          ),
                        );
                      }
                      Navigator.pop(context);
                    },
                    child: Text(isEdit ? 'Сохранить' : 'Создать'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
