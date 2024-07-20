import 'package:flutter/material.dart';
import 'package:guruku/screens/guru/beranda.dart';
import 'package:guruku/screens/guru/riwayat.dart';
import 'package:guruku/screens/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GuruHome extends StatefulWidget {
  const GuruHome({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  State<GuruHome> createState() => _HomeState();
}

class _HomeState extends State<GuruHome> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    const Beranda(),
    const Riwayat(),
    const Profile(),
  ];

  void check() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('loggedin', true);
    prefs.setString('role', 'guru');
  }

  @override
  void initState() {
    super.initState();
    check();
    _currentIndex = widget.currentIndex;
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Colors.white, textTheme: Theme.of(context).textTheme),
        child: BottomNavigationBar(
          showUnselectedLabels: false,
          selectedLabelStyle: const TextStyle(color: Colors.blue),
          unselectedLabelStyle: const TextStyle(color: Colors.black),
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black,
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart,
              ),
              label: 'Order',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.list,
              ),
              label: 'Riwayat',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
