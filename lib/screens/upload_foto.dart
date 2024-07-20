import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UploadPhotoPage extends StatefulWidget {
  final String url;
  const UploadPhotoPage({super.key,required this.url});

  @override
  State<UploadPhotoPage> createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {

  

  File? _image;
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        debugPrint('No image selected.');
      }
    });
  }

  Future uploadImage() async {
    if (_image == null) {
      debugPrint('No image to upload');
      return;
    }

    String uploadUrl =
        "http://192.168.1.2:3000/upload"; // Replace with your server URL

    try {
      final prefs = await SharedPreferences.getInstance();
      String email = prefs.getString('email')!;
      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
      request.fields['email'] = email;
      request.files
          .add(await http.MultipartFile.fromPath('photo', _image!.path));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        String photoUrl = responseData['photoUrl'];
        debugPrint("Uploaded photo URL: $photoUrl");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Upload berhasil, refresh halaman")),
        );
        Navigator.pop(context);
      } else {
        debugPrint("Failed to upload image: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Upload gagal")),
        );
      }
    } catch (e) {
      print("Error uploading image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Upload gagal")),
      );
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
        backgroundColor: Colors.blue,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: const Text(
          "Upload Photo",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: pickImage,
              child: const Text("Pilih Foto"),
            ),
            const SizedBox(height: 20.0),
            _image == null
                ? const Text('Tidak ada foto terpilih.')
                : Image.file(
                    _image!,
                    height: 300.0,
                  ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: uploadImage,
              child: const Text("Upload Foto"),
            ),
          ],
        ),
      ),
    );
  }
}
