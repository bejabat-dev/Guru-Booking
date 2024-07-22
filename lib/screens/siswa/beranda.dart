import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guruku/network.dart';
import 'package:guruku/notifications.dart';
import 'package:guruku/screens/siswa/rincian.dart';
import 'package:guruku/styles.dart';
import 'package:guruku/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BerandaSiswa extends StatefulWidget {
  const BerandaSiswa({super.key});

  @override
  State<BerandaSiswa> createState() => _BerandaSiswaState();
}

class _BerandaSiswaState extends State<BerandaSiswa> {
  List<dynamic> dataGuru = [];
  List<dynamic> dataTarif = [];
  void loadMapel() async {
    try {
      final response = await Dio().get('${Network().baseUrl}/mata_pelajaran');
      if (response.statusCode == 200) {
        debugPrint(response.data.toString());
        dataTarif = response.data;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void loadGuru() async {
    try {
      final response = await Dio().get('${Network().baseUrl}/users/guru');
      if (response.statusCode == 200) {
        setState(() {
          dataGuru = response.data;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  int getHarga(String mapel) {
    int harga = 0;
    for (var map in dataTarif) {
      if (map['deskripsi'] == mapel) {
        harga = map['tarif'];
      }
    }
    return harga;
  }

  String nama = '';

  void getNama() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      nama = pref.getString('nama')!;
    });
  }

  @override
  void initState() {
    super.initState();
    loadGuru();
    loadMapel();
    getNama();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Utils().Navigate(context, const Notifications());
              },
              icon: const Icon(Icons.notifications))
        ],
        backgroundColor: Colors.white,
        title: Text(
          'Beranda',
          style: Styles().appBarText,
        ),
      ),
      body: dataGuru.isNotEmpty
          ? ListView.builder(
              itemCount: dataGuru.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 1),
                  child: Material(
                    elevation: 2,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          dataGuru[i]['foto_profil'].toString() != 'default'
                              ? Image.network(
                                  dataGuru[i]['foto_profil'],
                                  height: 130,
                                  width: 90,
                                  fit: BoxFit.cover,
                                )
                              : const SizedBox(
                                  height: 130,
                                  width: 90,
                                  child:
                                      Center(child: Text('Tidak ada\nfoto'))),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: SizedBox(
                                height: 130,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      dataGuru[i]['nama'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.book),
                                        Text(dataGuru[i]['mata_pelajaran'])
                                      ],
                                    ),
                                    Text(Utils().formatRupiah(getHarga(
                                        dataGuru[i]['mata_pelajaran'])))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 130,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Material(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(12),
                                  child: InkWell(
                                    onTap: () {
                                      Utils().Navigate(
                                          context,
                                          Rincian(
                                              nama_guru: dataGuru[i]['nama'],
                                              mata_pelajaran: dataGuru[i]
                                                  ['mata_pelajaran'],
                                              id_guru: dataGuru[i]['id'],
                                              email: dataGuru[i]['email'],
                                              tarif: getHarga(dataGuru[i]
                                                  ['mata_pelajaran'])));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Rincian',
                                        style: Styles().whiteText,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              })
          : const Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoActivityIndicator(),SizedBox(height: 5,),Text('Memuat')
            ],
          ),
    );
  }
}
