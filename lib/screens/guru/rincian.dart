import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:guruku/network.dart';
import 'package:guruku/screens/guru/bottomnav.dart';
import 'package:guruku/styles.dart';

class RincianOrder extends StatefulWidget {
  const RincianOrder(
      {super.key,
      required this.foto,
      required this.id,
      required this.nama_siswa,
      required this.tarif,
      required this.mata_pelajaran,
      required this.id_guru});
  final int id;
  final String nama_siswa;
  final String mata_pelajaran;
  final String tarif;
  final String foto;
  final int id_guru;

  @override
  State<RincianOrder> createState() => _WidgetDetailsState();
}

class _WidgetDetailsState extends State<RincianOrder> {
  dynamic data = {};
  final String url = 'http://192.168.1.2:3000/user';

  Future<void> ubahOrder(int id, String status) async {
    try {
      final response = await Dio().post('${Network().baseUrl}/booking/terima',
          data: {'id': id, 'status': status});
      if (response.statusCode == 200) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const GuruHome(currentIndex: 0)),
            (route) => false);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text(
              'Rincian order',
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
                        widget.foto.isNotEmpty
                            ? Image.network(
                                widget.foto,
                                height: 400,
                                fit: BoxFit.cover,
                              )
                            : const SizedBox(
                                width: double.infinity,
                                height: 200,
                                child: Center(
                                  child: SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: CircularProgressIndicator()),
                                )),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(),
                              Text(
                                widget.nama_siswa,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.book),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(widget.mata_pelajaran),
                                ],
                              ),
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
                            'Tarif: ${widget.tarif}',
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
                          ubahOrder(widget.id, 'Booking ditolak');
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(16)),
                          child: const Center(
                            child: Text(
                              'Tolak',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      child: InkWell(
                        onTap: () {
                          ubahOrder(widget.id, 'Booking diterima');
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(16)),
                          child: const Center(
                            child: Text(
                              'Terima',
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
