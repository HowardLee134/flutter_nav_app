import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const BottomNav({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,  // Slightly increase the height to prevent overflow
      padding: const EdgeInsets.only(bottom: 5),  // Add some padding
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemSelected,
        iconSize: 20,  // Ensure the icon size fits well within the height
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bike),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_walk),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flight),
            label: '',
          ),
        ],
        type: BottomNavigationBarType.fixed, 
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
