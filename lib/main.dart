import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_app/pages/destination_page.dart';
import 'package:mobile_app/pages/home_page.dart';
import 'package:mobile_app/pages/navigation_page.dart';
import 'package:mobile_app/pages/points_page.dart';
import 'package:mobile_app/pages/profile_page.dart';
import 'package:mobile_app/pages/routes_page.dart';
import 'package:mobile_app/theme/theme.dart';
import 'package:mobile_app/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  final themeProvider = ThemeProvider();
  await themeProvider.loadThemeMode();

  runApp(
    ChangeNotifierProvider(
      create: (context) => themeProvider,
      child: const MainApp(),
    )
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,
      home: RoutesPage(),
      routes: {
        '/home': (context) => HomePage(),
        '/points': (context) => PointsPage(),
        '/profile': (context) => ProfilePage(),
        '/destination': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

          return DestinationPage(
            initialAddress: args?['currentAddress'],
            initialPos: args?['initialPos'],
          );
        },
        '/navigation': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

          return NavigationPage(
            currentAddress: args?['currentAddress'],
            currentPos: args?['currentPos'],
            destinationAddress: args?['destinationAddress'],
            destinationPos: args?['destinationPos'],
          );
        },
      },
    );
  }
}