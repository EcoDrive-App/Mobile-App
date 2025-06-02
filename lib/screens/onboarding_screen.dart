import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mobile_app/preferences/first_time_check.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  isDarkMode
                    ? 'assets/onboardingscreen/Dark.png'
                    : 'assets/onboardingscreen/Light.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              color: theme.surface.withValues(alpha: 0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const Spacer(),
                Text(
                  'Una nueva forma de moverte',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: theme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4,),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildFeatureCard(
                          context: context,
                          icon: Icons.star,
                          text: 'Gana puntos',
                        ),
                        _buildFeatureCard(
                          context: context,
                          icon: Icons.card_giftcard,
                          text: 'Canjea premios',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8,),
                    Align(
                      alignment: Alignment.center,
                      child: _buildFeatureCard(
                        context: context,
                        icon: Icons.public_rounded,
                        text: 'Reduce tu huella de carbono'
                      ),
                    )
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () async{
                    await FirstTimeCheck.setOnboardingSeen();
                    if (context.mounted) {
                      Navigator.pushNamed(context, '/auth');
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: theme.primary,
                      borderRadius: BorderRadius.circular(24)
                    ),
                    child: Center(
                      child: Text(
                        'Empieza ahora',
                        style: TextStyle(
                          color: theme.onPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 42),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({required BuildContext context, required IconData icon, required String text}) {
    var theme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24,
            color: theme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: theme.onSurface,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}