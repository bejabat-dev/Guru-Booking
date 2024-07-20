import 'package:flutter/material.dart';
import 'package:guruku/screens/admin/daftar_guru.dart';
import 'package:guruku/screens/admin/daftar_siswa.dart';
import 'package:guruku/screens/admin/kategori.dart';
import 'package:guruku/screens/admin/profile_admin.dart';

class Admin extends StatefulWidget {
  const Admin({super.key,required this.index});
  final int index;

  @override
  State<Admin> createState() => _HomeState();
}

class _HomeState extends State<Admin> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    const DaftarSiswa(),
    const DaftarGuru(),
    const Kategori(),
    const ProfileAdmin()
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
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
          unselectedLabelStyle:
              const TextStyle(color: Color.fromARGB(255, 49, 49, 49)),
          selectedItemColor: Colors.blue,
          unselectedItemColor: const Color.fromARGB(255, 54, 54, 54),
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: 'Siswa',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.group,
              ),
              label: 'Guru',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.book,
              ),
              label: 'Kategori',
            ),BottomNavigationBarItem(
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
