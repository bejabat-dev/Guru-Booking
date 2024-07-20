import 'package:flutter/material.dart';
import 'package:guruku/screens/auth/login.dart';
import 'package:guruku/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileAdmin extends StatefulWidget {
  const ProfileAdmin({super.key});

  @override
  State<ProfileAdmin> createState() => _ProfileGuruState();
}

class _ProfileGuruState extends State<ProfileAdmin> {
  String userData = 'admin';
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipOval(
                        child: Image.asset(
                      'assets/test.png',
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    )),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Admin',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
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
                              const Icon(Icons.person),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(style.capitalizeFirstLetter('Admin'))
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
                child: CircularProgressIndicator(),
              ));
  }
}
