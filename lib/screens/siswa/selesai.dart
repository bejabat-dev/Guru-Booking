import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:guruku/network.dart';
import 'package:guruku/screens/siswa/bottomnav.dart';
import 'package:guruku/styles.dart';
import 'package:guruku/utils.dart';

class Selesai extends StatefulWidget {
  const Selesai(
      {super.key,
      required this.id,
      required this.nama_guru,
      required this.tarif,
      required this.email,required this.tanggal,
      required this.mata_pelajaran,
      required this.id_guru});
      final int id;
      final String email;
  final String nama_guru;
  final String mata_pelajaran;
  final int tarif;
  final int id_guru;
  final String tanggal;

  @override
  State<Selesai> createState() => _WidgetDetailsState();
}

class _WidgetDetailsState extends State<Selesai> {
  dynamic data = {};
  String foto = '';
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

  Future<void> OrderSelesai() async {
    try {
      final response = await Dio().post('${Network().baseUrl}/booking/selesai', data: {
        'id' : widget.id,
        'status': 'Selesai'
      });
      if (response.statusCode == 200) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const Home2(currentIndex: 2,)), (route)=> false);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getRincian();
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
                            : const SizedBox(height: 200,width: double.infinity,
                              
                              child: Center(child: CircularProgressIndicator())),
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
                              ),Row(
                                children: [
                                  const Icon(Icons.calendar_month),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(widget.tanggal),
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
                          OrderSelesai();
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(16)),
                          child: const Center(
                            child: Text(
                              'Selesai',
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
