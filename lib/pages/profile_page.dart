import 'package:flutter/material.dart';
import 'package:mobile_app/components/profile_option.dart';
import 'package:mobile_app/theme/theme_provider.dart';
import 'package:mobile_app/preferences/user_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void _showThemeSelector(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final currentMode = themeProvider.themeMode;

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            const Text("Selecciona un tema", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),

            RadioListTile<ThemeMode>(
              value: ThemeMode.light,
              groupValue: currentMode,
              title: const Text("Claro"),
              secondary: const Icon(Icons.wb_sunny),
              onChanged: (value) {
                themeProvider.setTheme(value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              value: ThemeMode.dark,
              groupValue: currentMode,
              title: const Text("Oscuro"),
              secondary: const Icon(Icons.nightlight_round),
              onChanged: (value) {
                themeProvider.setTheme(value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              value: ThemeMode.system,
              groupValue: currentMode,
              title: const Text("Usar sistema"),
              secondary: const Icon(Icons.settings),
              onChanged: (value) {
                themeProvider.setTheme(value!);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  void _logout() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.logout();

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      backgroundColor: theme.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                theme.primary,
                                theme.primary.withValues(alpha: 0.7),
                              ],
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: theme.surface,
                            child: Icon(Icons.person, size: 40, color: theme.primary),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user?.name ?? 'Usuario',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: theme.onSurface),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? 'usuario@gmail.com',
                          style: TextStyle(fontSize: 16, color: theme.onSurface.withValues(alpha: 0.7)),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: theme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, color: theme.primary, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                "320 puntos",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: theme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  ProfileOption(
                    icon: Icons.edit,
                    text: "Editar perfil",
                    onTap: () {},
                  ),
                  ProfileOption(
                    icon: Icons.help_outline,
                    text: "Ayuda",
                    onTap: () {},
                  ),
                  ProfileOption(
                    icon: Icons.privacy_tip_outlined,
                    text: "Políticas",
                    onTap: () {},
                  ),
                  ProfileOption(
                    icon: Icons.brightness_6,
                    text: "Cambiar tema",
                    onTap: () => _showThemeSelector(context),
                  ),
                  const SizedBox(height: 40),
                  ProfileOption(
                    icon: Icons.logout,
                    text: "Cerrar sesión",
                    onTap: _logout,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}