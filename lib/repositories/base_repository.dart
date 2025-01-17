// Import required packages
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseRepository {
  late FirebaseFirestore _firestore;

  BaseRepository() {
    _firestore = FirebaseFirestore.instance;
  }

  BaseRepository.withMockFirestore(this._firestore);

  FirebaseFirestore get firestore => _firestore;
}