import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:guruku/network.dart';
import 'package:guruku/screens/admin/bottomnav.dart';
import 'package:guruku/styles.dart';
import 'package:image_picker/image_picker.dart';

class TambahKategori extends StatefulWidget {
  const TambahKategori(
      {super.key,
      required this.editing,
      required this.deskripsi,
      required this.tarif,
      required this.url});
  final bool editing;
  final String? url;
  final String? deskripsi;
  final String? tarif;

  @override
  State<TambahKategori> createState() => _TambahKategoriState();
}

class _TambahKategoriState extends State<TambahKategori> {
  final formKey = GlobalKey<FormState>();

  final Deskripsi = TextEditingController();

  final Harga = TextEditingController();

  String title = 'Tambah kategori';

  Widget image = const Column(
    children: [
      Icon(Icons.add),
      Text(
        'Pilih icon',
        style: TextStyle(color: Color.fromARGB(255, 117, 117, 117)),
      )
    ],
  );

  File? _image;
  final _picker = ImagePicker();
  final dio = Dio();
  final url = '${Network().baseUrl}/setmatapelajaran';

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        image = Image.file(
          _image!,
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        );
      }
    });
  }

  

  Future<void> _uploadImage(BuildContext context) async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Pilih icon'),
        duration: Duration(seconds: 2),
      ));
      return;
    }

    String fileName = _image!.path.split('/').last;

    FormData formData = FormData.fromMap({
      "deskripsi": Deskripsi.text,
      "tarif": Harga.text,
      "photo": await MultipartFile.fromFile(_image!.path, filename: fileName),
    });

    try {
      Response response = await dio
          .post('${Network().baseUrl}/setmatapelajaran', data: formData);
      if (response.statusCode == 200) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Admin(index: 2)),
            (rpute) => false);
      } else {
        debugPrint('File upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error occurred during file upload: $e');
    }
  }

  void validate(String? value, String errorText) {
    if (value == null || value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('$errorText tidak boleh kosong'),
        duration: const Duration(seconds: 2),
      ));
    }
  }

  void _editing() async {
    setState(() {
      title = 'Edit kategori';
      Deskripsi.text = widget.deskripsi!;
      Harga.text = widget.tarif!;
      image = Image.network(
        widget.url!,
        height: 100,
        width: 100,
        fit: BoxFit.fill,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.editing) {
      _editing();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: Styles().appBarText,
        ),
      ),
      body: Center(
        child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  elevation: 2,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                      onTap: () {
                        _pickImage();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: image,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                      controller: Deskripsi,
                      validator: (value) {
                        validate(value, 'Deskripsi');
                        return null;
                      },
                      style: Styles().inputText,
                      decoration: Styles().inputDecoration('Deskripsi', null)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                      style: Styles().inputText,
                      controller: Harga,
                      validator: (value) {
                        validate(value, 'Harga');
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: Styles().inputDecoration('Harga', 'Rp')),
                ),
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            _uploadImage(context);
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
