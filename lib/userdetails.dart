import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Userdetails{
  static Map<String,dynamic>? userData;
  
  static String? email;

  Future<void> savePrefs()async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('loggedin', true);
  }
  Future<void> getToken()async{
    final fcm = FirebaseMessaging.instance;
    final db = FirebaseFirestore.instance;
    String? token = await fcm.getToken();
    if(token!=null){
      await db.collection('tokens').doc('noob').set({'token':token}).catchError((e){
        debugPrint('Gagal upload token : $e');
      });
    }
  }
}