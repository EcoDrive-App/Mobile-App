import 'package:flutter/material.dart';
import 'package:mobile_app/user/user_provider.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _acceptTerms = false;

  void _signup() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loginUser(
      _nameController.text,
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
      body: Column(
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
                  "Registro",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.name,
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

                const SizedBox(height: 10),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      side: BorderSide(width: 1.5, color: theme.onSurface),
                      value: _acceptTerms,
                      onChanged: (value) {
                        setState(() {
                          _acceptTerms = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Wrap(
                          children: [
                            const Text('Acepto los '),
                            GestureDetector(
                              onTap: () {
                              },
                              child: Text(
                                'términos y condiciones',
                                style: TextStyle(
                                  color: theme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Text(' y '),
                            GestureDetector(
                              onTap: () {
                              },
                              child: Text(
                                'políticas de privacidad',
                                style: TextStyle(
                                  color: theme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                GestureDetector(
                  onTap: _signup,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: theme.primary,
                      borderRadius: BorderRadius.circular(24)
                    ),
                    child: Center(
                      child: Text(
                        'Crear Cuenta',
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
                    Text('Ya tienes cuenta? '),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text(
                        'Empiza Ahora',
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
    );
  }
}