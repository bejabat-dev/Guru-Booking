import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:guruku/network.dart';
import 'package:image_picker/image_picker.dart';

class UploadFoto extends StatefulWidget {
  const UploadFoto(
      {super.key, required this.id, required this.editing, required this.url});
  final bool editing;
  final String? url;
  final int id;

  @override
  State<UploadFoto> createState() => _TambahKategoriState();
}

class _TambahKategoriState extends State<UploadFoto> {
  final formKey = GlobalKey<FormState>();

  final Deskripsi = TextEditingController();

  final Harga = TextEditingController();

  String title = 'Tambah kategori';

  Widget image = const Column(
    children: [
      Icon(Icons.add),
      Text(
        'Tambahkan foto',
        style: TextStyle(color: Color.fromARGB(255, 117, 117, 117)),
      )
    ],
  );

  File? _image;
  final _picker = ImagePicker();
  final dio = Dio();
  final url = '${Network().baseUrl}/update_foto';
  XFile? pickedFile;

  Future<void> _pickImage() async {
    pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile!.path);
      });
    }
    if (mounted) {
      _uploadImage(context);
    }
  }

  Future<void> _uploadImage(BuildContext context) async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Pilih foto'),
        duration: Duration(seconds: 2),
      ));
      return;
    }

    String fileName = _image!.path.split('/').last;

    FormData formData = FormData.fromMap({
      "id": widget.id,
      "photo": await MultipartFile.fromFile(_image!.path, filename: fileName),
    });

    try {
      Response response =
          await dio.post('${Network().baseUrl}/update_foto', data: formData);
      if (response.statusCode == 200) {
        setState(() {
          if (pickedFile != null) {
            _image = File(pickedFile!.path);
            image = ClipOval(
              child: Image.file(
                _image!,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            );
          }
        });
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

  

  @override
  void initState() {
    super.initState();
    if (widget.url != 'default') {
      image = ClipOval(
        child: Image.network(
          widget.url!,
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.white,
        child: InkWell(
            onTap: () {
              _pickImage();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: image,
            )),
      ),
    );
  }
}
