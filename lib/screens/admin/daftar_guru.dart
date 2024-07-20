import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guruku/network.dart';
import 'package:guruku/styles.dart';

class DaftarGuru extends StatefulWidget {
  const DaftarGuru({super.key});

  @override
  State<DaftarGuru> createState() => _DaftarSiswaState();
}

class _DaftarSiswaState extends State<DaftarGuru> {
  List<dynamic> data = [];
  Future<void> getSiswa() async {
    try {
      final response = await Dio().get('${Network().baseUrl}/users/guru');
      if (response.statusCode == 200) {
        setState(() {
          data = response.data;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getSiswa();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Daftar guru',
          style: Styles().appBarText,
        ),
      ),
      body: data.isNotEmpty ? CustomScrollView(
        slivers: [
          SliverList.builder(
              itemCount: data.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 1),
                  child: Material(
                    elevation: 1,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          data[i]['foto_profil'] == 'default'
                              ? Image.network(
                                  data[i]['foto_profil'],
                                  height: 140,
                                  width: 90,
                                  fit: BoxFit.cover,
                                )
                              : const SizedBox(
                                  height: 130,
                                  width: 90,
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 140,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    data[i]['nama'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.book),
                                      Text(data[i]['email'],overflow: TextOverflow.ellipsis,),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.book),
                                      Text(data[i]['mata_pelajaran']),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.phone_android),
                                      Text(data[i]['nohp'].toString()),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.place),
                                      Text(data[i]['alamat']),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Material(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/edit');
                              },
                              child: const Padding(
                                padding:
                                    EdgeInsets.fromLTRB(12, 8, 12, 8),
                                child: Text(
                                  'Edit',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ],
      ) : const Center(child:  CupertinoActivityIndicator()),
    );
  }
}
