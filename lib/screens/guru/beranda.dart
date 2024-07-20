import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:guruku/network.dart';
import 'package:guruku/screens/guru/rincian.dart';
import 'package:guruku/styles.dart';
import 'package:guruku/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _RiwayatState();
}

class _RiwayatState extends State<Beranda> {
  List<dynamic> data = [];
  List<dynamic> dataTarif = [];
  List<dynamic> dataSiswa = [];

  Future<void> getRiwayat() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final response = await Dio().get('${Network().baseUrl}/booking/guru',
          data: {'id': prefs.getInt('id'), 'status': 'Menunggu konfirmasi'});
      debugPrint('Status : ${response.data}');
      if (response.statusCode == 200) {
        setState(() {
          data = response.data;
        });
        getDataSiswa();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getDataSiswa() async {
    for (var map in data) {
      final response = await Dio()
          .get('${Network().baseUrl}/userid', data: {'id': map['id_siswa']});
      debugPrint('Status : ${response.data}');
      setState(() {
        dataSiswa.add(response.data);
      });
    }
  }

  Future<void> getTarif() async {
    if (context.mounted) {
      final response = await Dio().get('${Network().baseUrl}/tarif');
      debugPrint(response.toString());
      if (mounted) {
        setState(() {
          dataTarif = response.data;
        });
      }
    }
  }

  String getTarifinRupiah(String s) {
    String h = '';
    for (var map in dataTarif) {
      if (map['deskripsi'] == s) {
        h = Utils().formatRupiah(map['tarif']);
      }
    }
    return h;
  }

  @override
  void initState() {
    super.initState();
    getRiwayat();
    getTarif();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Order Masuk',
          style: Styles().appBarText,
        ),
      ),
      body: dataSiswa.isNotEmpty
          ? ListView.builder(
              itemCount: dataSiswa.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 1),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RincianOrder(
                                    foto: dataSiswa[i]['foto_profil'],
                                    id: data[i]['id'],
                                    nama_siswa: dataSiswa[i]['nama'],
                                    tarif: getTarifinRupiah(
                                        data[i]['mata_pelajaran']),
                                    mata_pelajaran: data[i]['mata_pelajaran'],
                                    id_guru: 5,
                                  )));
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
                                      dataSiswa[i]['nama'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.book),
                                        Text(data[i]['mata_pelajaran']),
                                      ],
                                    ),
                                    const Row(
                                      children: [
                                        Icon(Icons.calendar_month),
                                        Text('21/2/2023'),
                                      ],
                                    ),
                                    Text(getTarifinRupiah(
                                        data[i]['mata_pelajaran'])),
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
          : const Center(
              child: Text(
              'Belum ada order masuk',
              style: TextStyle(color: Colors.grey),
            )),
    );
  }
}
