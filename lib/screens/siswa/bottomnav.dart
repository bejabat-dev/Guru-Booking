import 'package:flutter/material.dart';
import 'package:guruku/screens/profile.dart';
import 'package:guruku/screens/siswa/kategori.dart';
import 'package:guruku/screens/siswa/riwayat.dart';
import 'package:guruku/screens/siswa/beranda.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home2 extends StatefulWidget {
  const Home2({super.key, required this.currentIndex});
  final int currentIndex;

  @override
  State<Home2> createState() => _HomeState();
}

class _HomeState extends State<Home2> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    const BerandaSiswa(),
    const KategoriSiswa(),
    const Riwayat(),
    const Profile(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void cek() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('loggedin', true);
    prefs.setString('role', 'siswa');
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    cek();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Colors.white, textTheme: Theme.of(context).textTheme),
        child: BottomNavigationBar(
          elevation: 2,
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
                Icons.home,
              ),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Kategori',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Riwayat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
