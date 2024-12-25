import 'package:flutter_deneme/main.dart';
import 'package:flutter_deneme/screens/expenses.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'in_comes.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

var pageList = [const Expenses(), const InComes()];
int _selectedIndex = 0;
bool isDark = false;

class _BottomNavState extends State<BottomNav> {
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      var currentTheme = Theme.of(context);
      if (currentTheme.brightness == Brightness.dark) {
        isDark = true;
      } else {
        isDark = false;
      }
    });

    return Scaffold(
      body: pageList[_selectedIndex],
      bottomNavigationBar: Container(
        color: isDark
            ? kDarkColorScheme.onTertiary.withOpacity(0.4)
            : kColorScheme.onPrimaryContainer,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
          child: GNav(
            color: isDark
                ? Colors.white
                : Colors.white,
            gap: 5,
            textStyle: const TextStyle(color: Colors.white, fontSize: 18),
            iconSize: 30,
            activeColor: Colors.white,
            tabs: const [
              GButton(
                icon: Icons.remove_circle,
                text: 'Expenses',
                rippleColor: Colors.red,
              ),

              GButton(
                icon: Icons.add_circle,
                text: 'InComes',
                rippleColor: Colors.teal,
              ),
            ],
            onTabChange: (value) => setState(
                  () {
                _selectedIndex = value;
              },
            ),
          ),
        ),
      ),
    );
  }
}
