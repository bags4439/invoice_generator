import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseInvoiceDatasource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  FirebaseInvoiceDatasource({FirebaseFirestore? firestore, FirebaseStorage? storage})
      : firestore = firestore ?? FirebaseFirestore.instance,
        storage = storage ?? FirebaseStorage.instance;

  Future<void> saveInvoice(Map<String, dynamic> data) async {
    final id = data['id'] as String;
    await firestore.collection('invoices').doc(id).set(data);
  }

  Future<List<Map<String, dynamic>>> fetchAll() async {
    final snap = await firestore.collection('invoices').orderBy('date', descending: true).get();
    return snap.docs.map((d) => d.data()).toList();
  }

  Future<bool> fetchEnabled() async {
    final doc = await firestore.collection('config').doc('app').get();
    return doc.data()?['enabled'] ?? true;
  }

  Future<String> uploadImage(String filename, Uint8List bytes) async {
    final ref = storage.ref().child('invoice_images/$filename');
    final task = await ref.putData(bytes);
    return task.ref.getDownloadURL();
  }
}