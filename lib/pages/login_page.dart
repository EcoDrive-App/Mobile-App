import 'package:flutter/material.dart';
import 'package:mobile_app/user/user_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  void _login() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loginUser(
      'Kevin',
      _emailController.text
    );

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/routes');
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 250,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    isDarkMode
                      ? 'assets/login/Dark_Background.PNG'
                      : 'assets/login/Light_Background.PNG',
                    fit: BoxFit.cover,
                  ),
                  Image.asset(
                    isDarkMode
                      ? 'assets/login/Dark_FirstLayer.PNG'
                      : 'assets/login/Light_FirstLayer.PNG',
                    fit: BoxFit.cover,
                  ),
                  if (isDarkMode)
                    Image.asset(
                      'assets/login/Dark_LightLayer.PNG',
                      fit: BoxFit.cover,
                    ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 32.0, right: 32.0, top: 20),
              child: Column(
                children: [
                  Text(
                    "Inicio de Sesión",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Correo electrónico',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _passController,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(
                          color: theme.secondary,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  GestureDetector(
                    onTap: _login,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: theme.primary,
                        borderRadius: BorderRadius.circular(24)
                      ),
                      child: Center(
                        child: Text(
                          'Iniciar Sesión',
                          style: TextStyle(
                            color: theme.onPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('¿No tienes cuenta? '),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: Text(
                          'Crea una',
                          style: TextStyle(
                            color: theme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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