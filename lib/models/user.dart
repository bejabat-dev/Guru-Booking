import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://192.168.1.2:3000';

  Future<List<User>> fetchGuruUsers() async {
    final response = await http.get(Uri.parse('$_baseUrl/users/guru'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      debugPrint(jsonResponse.toString());
      return jsonResponse.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<List<Map<String, dynamic>>> getDetails(String email) async {
    List<Map<String, dynamic>> data = [];
    final response = await Dio().get('$_baseUrl/user', data: {'email': email});
    debugPrint('List: ${response.data}');
    if (response.statusCode == 200) {
      data = List<Map<String, dynamic>>.from(response.data);
    } else {
      throw Exception('Error');
    }
    return data;
  }
}

class User {
  final String nama;
  final String mataPelajaran;
  final String fotoProfil;
  final String alamat;
  final String nohp;

  User(
      {required this.nama,
      required this.mataPelajaran,
      required this.fotoProfil,
      required this.alamat,
      required this.nohp});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      nama: json['nama'],
      mataPelajaran: json['mata_pelajaran'],
      fotoProfil: json['foto_profil'],
      alamat: json['alamat'],
      nohp: json['nohp'],
    );
  }
}
