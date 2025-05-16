import 'package:flutter/material.dart';
import 'package:mobile_app/components/navbar.dart';
import 'package:mobile_app/pages/home_page.dart';
import 'package:mobile_app/pages/points_page.dart';
import 'package:mobile_app/pages/profile_page.dart';

class RoutesPage extends StatefulWidget {
  const RoutesPage({super.key});

  @override
  State<RoutesPage> createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> with AutomaticKeepAliveClientMixin {
  int _currentIndex = 1;
  final List<Widget> _pages = [
    PointsPage(),
    HomePage(),
    ProfilePage(),
  ];

  @override
  bool get wantKeepAlive => true;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Main Conent
            Positioned.fill(
              child: IndexedStack(
                index: _currentIndex,
                children: _pages,
              ),
            ),

            // Floating navbar
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: CustomNavbar(
                currentIndex: _currentIndex,
                onTap: _onTabSelected,
              ),
            ),
          ],
        ),
      ),
    );
  }
}