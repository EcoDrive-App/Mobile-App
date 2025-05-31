import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:mobile_app/pages/login_page.dart';
import 'package:mobile_app/pages/routes_page.dart';
import 'package:mobile_app/preferences/user_provider.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    if (userProvider.isLoading) {
      return Scaffold(
        body: Center(
          child:  CircularProgressIndicator.adaptive()
        )
      );
    }

    return userProvider.isLoggedIn ? const RoutesPage() : const LoginPage();
  }
}