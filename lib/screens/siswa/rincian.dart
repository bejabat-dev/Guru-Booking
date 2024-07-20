import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guruku/network.dart';
import 'package:guruku/styles.dart';
import 'package:guruku/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Rincian extends StatefulWidget {
  const Rincian(
      {super.key,
      required this.nama_guru,
      required this.email,
      required this.tarif,
      required this.mata_pelajaran,
      required this.id_guru});
  final String nama_guru;
  final String mata_pelajaran;
  final String email;
  final int tarif;
  final int id_guru;

  @override
  State<Rincian> createState() => _WidgetDetailsState();
}

class _WidgetDetailsState extends State<Rincian> {
  dynamic data = {};
  List<dynamic> jadwal = [];
  String foto = '';
  String? jadwalString;
  final String url = 'http://192.168.1.2:3000/user';

  Future<void> getRincian() async {
    try {
      final response = await Dio()
          .get('${Network().baseUrl}/user', data: {'email': widget.email});
      setState(() {
        data = response.data;
        foto = data['foto_profil'];
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  List<dynamic> formattedDate = [];

  Future<void> loadJadwal() async {
    try {
      final response = await Dio().get('${Network().baseUrl}/jadwal',
          data: {'id_guru': widget.id_guru});
      if (response.statusCode == 200) {
        jadwal = response.data;
        for (var map in jadwal) {
          setState(() {
            formattedDate.add({'tanggal': Utils().formatDate(map['tanggal'])});
            jadwalString = formattedDate[0]['tanggal'];
          });
        }
      }
    } catch (e) {
      if (mounted) Utils().showCustomDialog(context, e.toString());
    }
  }

  Future<void> ajukanOrder(String tanggal) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final response = await Dio().post('${Network().baseUrl}/booking', data: {
        'id_siswa': prefs.getInt('id'),
        'id_guru': widget.id_guru,
        'mata_pelajaran': widget.mata_pelajaran,
        'tanggal': tanggal,
        'status': 'Menunggu konfirmasi'
      });
      if (response.statusCode == 200) {
        Navigator.pop(context);
        Utils().showMessage(context, 'Berhasil order');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getRincian();
    loadJadwal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text(
              'Rincian',
              style: Styles().appBarText,
            ),
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 18,
                ))),
        body: data.toString().isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        foto.isNotEmpty
                            ? Image.network(
                                foto,
                                height: 400,
                                fit: BoxFit.cover,
                              )
                            : const SizedBox(
                                height: 200,
                                width: double.infinity,
                                child:
                                    Center(child: CircularProgressIndicator())),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(),
                              Text(
                                '${data['nama']}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.book),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text('${data['mata_pelajaran']}'),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.phone),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text('${data['nohp']}'),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.place),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text('${data['alamat']}'),
                                ],
                              ),
                              Row(
                                children: [
                                  const Expanded(child: Text('Pilih tanggal ')),
                                  IntrinsicWidth(
                                    child: formattedDate.isNotEmpty
                                        ? DropdownButtonFormField<String>(
                                            decoration: Styles()
                                                .inputDecoration(' ', null),
                                            value: jadwalString,
                                            hint: const Text('Pilih tanggal'),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                jadwalString = newValue!;
                                              });
                                            },
                                            items: formattedDate
                                                .map<DropdownMenuItem<String>>(
                                                    (dynamic mapEntry) {
                                              return DropdownMenuItem<String>(
                                                value: mapEntry['tanggal'],
                                                child:
                                                    Text(mapEntry['tanggal']),
                                              );
                                            }).toList(),
                                          )
                                        : const Row(
                                            children: [
                                              CupertinoActivityIndicator(),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text('Memuat jadwal')
                                            ],
                                          ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Text(
                            'Tarif: ${Utils().formatRupiah(widget.tarif)}',
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: InkWell(
                        onTap: () {
                          ajukanOrder(jadwalString!);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(16)),
                          child: const Center(
                            child: Text(
                              'Ajukan order',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : const SizedBox(
                width: 20, height: 20, child: CircularProgressIndicator()));
  }
}
