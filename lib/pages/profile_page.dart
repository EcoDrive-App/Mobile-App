import 'package:flutter/material.dart';
import 'package:mobile_app/theme/theme_provider.dart';
import 'package:mobile_app/user/user_provider.dart';
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
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: theme.primary.withValues(alpha: 0.2),
                          child: Icon(Icons.person, size: 40, color: theme.primary),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          user?.name ?? 'Usuario',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: theme.onSurface),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? 'usuario@gmail.com',
                          style: TextStyle(fontSize: 16, color: theme.onSurface),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Puntos: 320",
                          style: TextStyle(fontSize: 16, color: theme.primary, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildOption(
                    icon: Icons.edit,
                    text: "Editar perfil",
                    onTap: () {},
                    theme: theme,
                  ),
                  _buildOption(
                    icon: Icons.help_outline,
                    text: "Ayuda",
                    onTap: () {},
                    theme: theme,
                  ),
                  _buildOption(
                    icon: Icons.privacy_tip_outlined,
                    text: "Políticas",
                    onTap: () {},
                    theme: theme,
                  ),
                  _buildOption(
                    icon: Icons.brightness_6,
                    text: "Cambiar tema",
                    onTap: () => _showThemeSelector(context),
                    theme: theme,
                  ),
                  const SizedBox(height: 40,),
                  _buildOption(
                    icon: Icons.logout,
                    text: "Cerrar sesión",
                    onTap: _logout,
                    theme: theme,
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


  Widget _buildOption({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    required ColorScheme theme,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? theme.primary),
      title: Text(
        text,
        style: TextStyle(color: color ?? theme.onSurface),
      ),
      onTap: onTap,
    );
  }
}