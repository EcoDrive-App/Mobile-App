import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:mobile_app/pages/login_page.dart';
import 'package:mobile_app/pages/routes_page.dart';
import 'package:mobile_app/user/user_provider.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    final userProvider = Provider.of<UserProvider>(context);

    if (userProvider.isLoading) {
      return Scaffold(
        body: Center(child:
          Theme.of(context).platform == TargetPlatform.iOS
            ? CupertinoActivityIndicator(radius: 16, animating: true, color: theme.primary,)
            : CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(theme.primary),),),
      );
    }

    return userProvider.isLoggedIn ? const RoutesPage() : const LoginPage();
  }
}