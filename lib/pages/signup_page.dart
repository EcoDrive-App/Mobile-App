import 'package:flutter/material.dart';
import 'package:mobile_app/api/auth.dart';
import 'package:mobile_app/components/custom_snack_bar.dart';
import 'package:mobile_app/preferences/user_provider.dart';
import 'package:mobile_app/types/user.dart';
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
  bool _hasError = false;
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu nombre';
    }
    if (value.length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu correo electrónico';
    }
    if (!value.contains('@') || !value.contains('.')) {
      return 'Por favor ingresa un correo electrónico válido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa una contraseña';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  void _signup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_acceptTerms) {
      CustomSnackBar.show(context: context, text: 'Debes aceptar los términos y condiciones', icon: Icons.warning_outlined);
      return;
    }

    setState(() {
      _hasError = false;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator.adaptive(),
      )
    );

    final response = await AuthApi.register(_nameController.text, _emailController.text, _passController.text);

    if (mounted) {
      Navigator.pop(context);

      if (response != null) {
        final user = User.fromMap(response);
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.loginUser(user);

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/routes');
        }
      } else {
        setState(() {
          _hasError = true;
        });
        CustomSnackBar.show(
          context: context,
          text: 'Error al crear la cuenta. Por favor intenta nuevamente.',
          icon: Icons.error_outline,
          backgroundColor: Colors.red,
        );
      }
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
              child: Form(
                key: _formKey,
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
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: _hasError ? Colors.red : theme.outline,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    validator: _validateName,
                  ),

                    const SizedBox(height: 20),

                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Correo electrónico',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: _hasError ? Colors.red : theme.outline,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: _validateEmail,
                  ),

                    const SizedBox(height: 20),

                  TextFormField(
                    controller: _passController,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: _hasError ? Colors.red : theme.outline,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: theme.onSurfaceVariant,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscurePassword,
                    validator: _validatePassword,
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
            ),
          ],
        ),
      ),
    );
  }
}