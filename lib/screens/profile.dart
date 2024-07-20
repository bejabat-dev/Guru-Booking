import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guruku/screens/auth/login.dart';
import 'package:guruku/screens/guru/atur_jadwal.dart';
import 'package:guruku/screens/guru/edit_profil.dart';
import 'package:guruku/screens/siswa/edit_profil.dart';
import 'package:guruku/styles.dart';
import 'package:guruku/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Widget profileWidget;
  bool isLoaded = false;

  void checkRole() async {
    final prefs = await SharedPreferences.getInstance();
    String role = prefs.getString('role')!;
    if (role == 'siswa') {
      setState(() {
        profileWidget = const ProfileSiswa();
        isLoaded = true;
      });
    } else if (role == 'guru') {
      setState(() {
        profileWidget = const ProfileGuru();

        isLoaded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkRole();
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded == true
        ? profileWidget
        : const CupertinoActivityIndicator();
  }
}

class ProfileGuru extends StatefulWidget {
  const ProfileGuru({super.key});

  @override
  State<ProfileGuru> createState() => _ProfileGuruState();
}

class _ProfileGuruState extends State<ProfileGuru> {
  Map<String, dynamic> userData = {};
  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      String data = prefs.getString('data')!;
      userData = jsonDecode(data);
      debugPrint(userData['email']);
    });
  }

  final style = Styles();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Profil',
            style: style.appBarText,
          ),
          centerTitle: true,
        ),
        body: userData.isNotEmpty
            ? SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    userData['foto_profil'] != 'default'
                        ? ClipOval(
                            child: Image.network(
                            userData['foto_profil'],
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ))
                        : const CupertinoActivityIndicator(),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      userData['nama'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(userData['email']),
                    const SizedBox(
                      height: 10,
                    ),
                    Material(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.blue,
                      child: InkWell(
                          onTap: () {
                            Utils().Navigate(
                                context,
                                EditProfilGuru(
                                    id: userData['id'],
                                    mata_pelajaran: userData['mata_pelajaran'],
                                    url: userData['foto_profil'],
                                    nama: userData['nama'],
                                    alamat: userData['alamat'],
                                    email: userData['email'],
                                    nohp: userData['nohp'].toString()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text('Edit profil', style: style.whiteText),
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Informasi Akun',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 1),
                      child: Material(
                        color: Colors.white,
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              const Icon(Icons.place),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(userData['alamat'])
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 1),
                      child: Material(
                        color: Colors.white,
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              const Icon(Icons.phone_android),
                              const SizedBox(
                                width: 4,
                              ),
                              Text('0${userData['nohp']}')
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 1),
                      child: Material(
                        color: Colors.white,
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              const Icon(Icons.person),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                  style.capitalizeFirstLetter(userData['role']))
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 1),
                      child: Material(
                        color: Colors.white,
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              const Icon(Icons.book),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(style.capitalizeFirstLetter(
                                  userData['mata_pelajaran']))
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 1, left: 4),
                      child: Material(
                        color: Colors.white,
                        elevation: 1,
                        child: InkWell(
                          onTap: () {
                            Utils().Navigate(
                                context,
                                AturJadwal(
                                  id_guru: userData['id'],
                                ));
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_month),
                                SizedBox(
                                  width: 4,
                                ),
                                Text('Atur Jadwal')
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 1, left: 4),
                      child: Material(
                        color: Colors.white,
                        elevation: 1,
                        child: InkWell(
                          onTap: () async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool('loggedin', false);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()),
                                (Route<dynamic> route) => false);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Icon(Icons.logout),
                                SizedBox(
                                  width: 4,
                                ),
                                Text('Keluar')
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const Center(
                child: CupertinoActivityIndicator(),
              ));
  }
}

class ProfileSiswa extends StatefulWidget {
  const ProfileSiswa({super.key});

  @override
  State<ProfileSiswa> createState() => _ProfileSiswaState();
}

class _ProfileSiswaState extends State<ProfileSiswa> {
  Map<String, dynamic> userData = {};
  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      String data = prefs.getString('data')!;
      userData = jsonDecode(data);
      debugPrint(userData['email']);
    });
  }

  final style = Styles();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Profil',
            style: style.appBarText,
          ),
          centerTitle: true,
        ),
        body: userData.isNotEmpty
            ? SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    userData['foto_profil'].toString() != 'default'
                        ? ClipOval(
                            child: Image.network(
                            userData['foto_profil'],
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ))
                        : const CupertinoActivityIndicator(),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      userData['nama'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(userData['email']),
                    const SizedBox(
                      height: 10,
                    ),
                    Material(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.blue,
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfilSiswa(
                                        url: userData['foto_profil'],
                                        id: userData['id'],
                                        nama: userData['nama'],
                                        alamat: userData['alamat'],
                                        email: userData['email'],
                                        nohp:
                                            '0${userData['nohp'].toString()}')));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text('Edit profil', style: style.whiteText),
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Informasi Akun',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 1),
                      child: Material(
                        color: Colors.white,
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              const Icon(Icons.place),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(userData['alamat'])
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 1),
                      child: Material(
                        color: Colors.white,
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              const Icon(Icons.phone_android),
                              const SizedBox(
                                width: 4,
                              ),
                              Text('0${userData['nohp'].toString()}')
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 1),
                      child: Material(
                        color: Colors.white,
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              const Icon(Icons.person),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                  style.capitalizeFirstLetter(userData['role']))
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 1),
                      child: Material(
                        color: Colors.white,
                        elevation: 1,
                        child: InkWell(
                          onTap: () async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool('loggedin', false);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()),
                                (Route<dynamic> route) => false);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Icon(Icons.logout),
                                SizedBox(
                                  width: 4,
                                ),
                                Text('Keluar')
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const Center(
                child: CupertinoActivityIndicator(),
              ));
  }
}
