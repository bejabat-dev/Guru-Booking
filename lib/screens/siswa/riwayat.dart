import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:guruku/network.dart';
import 'package:guruku/screens/siswa/selesai.dart';
import 'package:guruku/styles.dart';
import 'package:guruku/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Riwayat extends StatefulWidget {
  const Riwayat({super.key});

  @override
  State<Riwayat> createState() => _RiwayatState();
}

class _RiwayatState extends State<Riwayat> {
  List<dynamic> data = [];
  List<dynamic> dataGuru = [];
  List<dynamic> dataTarif = [];
  Future<void> getRiwayat() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final response = await Dio().get('${Network().baseUrl}/booking',
          data: {'id': prefs.getInt('id')});
      if (response.statusCode == 200) {
        setState(() {
          data = response.data;
        });
        getDataGuru();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getTarif(BuildContext context) async {
    final response = await Dio().get('${Network().baseUrl}/tarif');
    debugPrint(response.toString());
    if (context.mounted) {
      setState(() {
        dataTarif = response.data;
      });
    }
  }

  int getTarifs(String s) {
    int h = 0;
    for (var map in dataTarif) {
      if (map['deskripsi'] == s) {
        h = map['tarif'];
      }
    }
    return h;
  }

  Future<void> getDataGuru() async {
    for (var map in data) {
      final response = await Dio()
          .get('${Network().baseUrl}/userid', data: {'id': map['id_guru']});

      setState(() {
        dataGuru.add(response.data);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getRiwayat();
    getTarif(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Riwayat',
          style: Styles().appBarText,
        ),
      ),
      body: dataGuru.isNotEmpty
          ? ListView.builder(
              reverse: false,
              itemCount: dataGuru.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 1),
                  child: InkWell(
                    onTap: () {
                      Utils().Navigate(
                          context,
                          Selesai(
                              tanggal: data[i]['tanggal'],
                              email: dataGuru[i]['email'],
                              id: data[i]['id'],
                              nama_guru: dataGuru[i]['nama'],
                              tarif: getTarifs(dataGuru[i]['mata_pelajaran']),
                              mata_pelajaran: dataGuru[i]['mata_pelajaran'],
                              id_guru: dataGuru[i]['id']));
                    },
                    child: Material(
                      color: Colors.white,
                      elevation: 2,
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      dataGuru[i]['nama'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.book),
                                        Text(dataGuru[i]['mata_pelajaran']),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_month),
                                        Text(data[i]['tanggal']),
                                      ],
                                    ),
                                    Text(Utils().formatRupiah(getTarifs(
                                        dataGuru[i]['mata_pelajaran']))),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 108,
                                child: Text(
                                  data[i]['status'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          )),
                    ),
                  ),
                );
              })
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
