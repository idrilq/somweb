import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/providers/auth_provider.dart';

class TopMenuBar extends StatelessWidget implements PreferredSizeWidget {
  final String currentRoute;

  const TopMenuBar({required this.currentRoute, super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final isAdmin = user?.role == 'admin';

    return AppBar(
      backgroundColor: const Color.fromARGB(255, 126, 229, 255),
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Выйти',
            onPressed: () {
              context.read<AuthProvider>().logout(context);
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
          ),
          const SizedBox(width: 12),
          SvgPicture.asset(
            'assets/images/logo.svg',
            height: 44,
          ),
          const Spacer(),
          if (!isAdmin)
            _MenuButton(
              label: 'Чеки',
              route: '/receipts',
              currentRoute: currentRoute,
            ),
          if (isAdmin) ...[
            _MenuButton(
              label: 'Терминалы',
              route: '/terminals',
              currentRoute: currentRoute,
            ),
            _MenuButton(
              label: 'Чеки',
              route: '/receipts',
              currentRoute: currentRoute,
            ),
            _MenuButton(
              label: 'Настройки',
              route: '/settings',
              currentRoute: currentRoute,
            ),
          ],
          const SizedBox(width: 24),
        ],
      ),
      centerTitle: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MenuButton extends StatelessWidget {
  final String label;
  final String route;
  final String currentRoute;

  const _MenuButton({
    required this.label,
    required this.route,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    final bool selected = currentRoute == route;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: selected ? const Color.fromARGB(255, 255, 255, 255) : const Color.fromARGB(179, 0, 0, 0),
          backgroundColor: selected ? const Color.fromARGB(255, 28, 69, 139) : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        onPressed: () {
          if (!selected) {
            Navigator.pushReplacementNamed(context, route);
          }
        },
        child: Text(
          label,
          style: TextStyle(
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
