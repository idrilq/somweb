import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(String login, String password) onSubmitted;

  const AuthForm({required this.onSubmitted, super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmitted(
        _loginController.text.trim(),
        _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _loginController,
            decoration: const InputDecoration(labelText: 'Логин'),
            validator: (v) => v == null || v.isEmpty ? 'Введите логин' : null,
            onFieldSubmitted: (_) => _submit(),
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Пароль'),
            obscureText: true,
            validator: (v) => v == null || v.isEmpty ? 'Введите пароль' : null,
            onFieldSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Войти'),
          ),
        ],
      ),
    );
  }
}
