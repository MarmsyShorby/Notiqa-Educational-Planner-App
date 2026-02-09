import 'package:flutter/material.dart';
import 'package:flutterapp/select_note.dart';
import 'scheduler.dart';
import 'drawing_board.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _screenIndex = 0;

  final List<Widget> _screens = const [
    SelectNote(),
    Scheduler(),
    DrawingBoard(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _screenIndex, children: _screens),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _screenIndex,
        onTap: (bottomNavIndex) {
          setState(() {
            _screenIndex = bottomNavIndex;
          });
        },

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.content_paste),
            label: "Notes",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Schedule",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: "Drawing Board",
          ),
        ],
      ),
    );
  }
}
