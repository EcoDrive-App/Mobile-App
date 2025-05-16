import 'package:flutter/material.dart';

class CustomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Navbar base
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          height: 60,
          decoration: BoxDecoration(
            color: theme.surface,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(color: theme.onSurface.withValues(alpha: 0.2), blurRadius: 8),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () => onTap(0),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    children: [
                      Icon(
                        Icons.credit_card,
                        size: 28,
                        color: currentIndex == 0 ? theme.primary : theme.onSurface,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Puntos",
                        style: TextStyle(
                          color: currentIndex == 0 ? theme.primary : theme.onSurface,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 40), // Space for the central button
              GestureDetector(
                onTap: () => onTap(2),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    children: [
                      Text(
                        "Perfil",
                        style: TextStyle(
                          color: currentIndex == 2 ? theme.primary : theme.onSurface,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        Icons.person,
                        size: 28,
                        color: currentIndex == 2 ? theme.primary : theme.onSurface,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Central button (Home)
        Positioned(
          bottom: 5,
          child: GestureDetector(
            onTap: () => onTap(1),
            child: AnimatedScale(
              duration: const Duration(milliseconds: 300),
              scale: currentIndex == 1 ? 1.1 : 1.0,
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentIndex == 1 ? theme.primary : theme.surface,
                  boxShadow: [
                    BoxShadow(color: theme.onSurface.withValues(alpha: 0.3), blurRadius: 8),
                  ],
                ),
                child: Icon(Icons.home, color: theme.onSurface, size: 32),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
