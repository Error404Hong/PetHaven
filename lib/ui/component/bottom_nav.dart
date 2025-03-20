import 'package:flutter/material.dart';
import 'bottomnav/curved_navigation_bar.dart';

class BottomNav extends StatefulWidget {
  final ValueChanged<int> onPageChanged; // Callback to update parent state

  const BottomNav({super.key, required this.onPageChanged});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late int _page;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _page = 2; // Set the middle button (index 2) as default
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      key: _bottomNavigationKey,
      index: _page,
      items: const <Widget>[
        Icon(Icons.add, size: 30),
        Icon(Icons.list, size: 30),
        Icon(Icons.compare_arrows, size: 30), // Middle button
        Icon(Icons.call_split, size: 30),
        Icon(Icons.perm_identity, size: 30),
      ],
        // Color(0xffacd0c1)
        // Color(0xff8bc4a8)
      color: const Color(0xffacd0c1),
      buttonBackgroundColor: const Color(0xffacd0c1),
      backgroundColor: const Color(0xfff7f6ee),
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 600),
      onTap: (index) {
        setState(() {
          _page = index;
        });
        widget.onPageChanged(index); // Notify parent
      },
      letIndexChange: (index) => true,
    );
  }
}
