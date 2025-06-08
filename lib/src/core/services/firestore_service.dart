import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  final FirebaseFirestore _firestore;

  factory FirestoreService() => _instance;

  FirestoreService._internal() : _firestore = FirebaseFirestore.instance {
    // Enable offline persistence (optional)
    _firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  Future<bool> checkDocumentExists({
    required String collection,
    required String docId,
  }) async {
    try {
      final doc = await _firestore.collection(collection).doc(docId).get();
      return doc.exists;
    } on FirebaseException catch (e) {
      throw FirestoreFailure.fromCode(e.code);
    } catch (e) {
      throw const FirestoreFailure();
    }
  }

  // ========== Document Operations ==========
  Future<String> setDocument({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
    bool merge = false, // Set true for partial updates
  }) async {
    try {
      final docRef = _firestore.collection(collection).doc(docId);

      await docRef.set(data, SetOptions(merge: merge));

      return docRef.id;
    } on FirebaseException catch (e) {
      throw FirestoreFailure.fromCode(e.code);
    } catch (e) {
      throw const FirestoreFailure();
    }
  }

  Future<void> updateDocument({
    required String collection,
    required String docId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      await _firestore.collection(collection).doc(docId).update(updates);
    } on FirebaseException catch (e) {
      throw FirestoreFailure.fromCode(e.code);
    } catch (e) {
      throw const FirestoreFailure();
    }
  }

  Future<void> deleteDocument({
    required String collection,
    required String docId,
  }) async {
    try {
      await _firestore.collection(collection).doc(docId).delete();
    } on FirebaseException catch (e) {
      throw FirestoreFailure.fromCode(e.code);
    } catch (e) {
      throw const FirestoreFailure();
    }
  }

  Future<Map<String, dynamic>?> getDocument({
    required String collection,
    required String docId,
    Source source =
        Source.serverAndCache, // Default: try server first, fallback to cache
  }) async {
    try {
      final doc = await _firestore
          .collection(collection)
          .doc(docId)
          .get(GetOptions(source: source));
      return doc.data();
    } on FirebaseException catch (e) {
      throw FirestoreFailure.fromCode(e.code);
    } catch (e) {
      throw const FirestoreFailure();
    }
  }

  Stream<DocumentSnapshot> streamDocument({
    required String collection,
    required String docId,
  }) {
    return _firestore.collection(collection).doc(docId).snapshots().handleError(
      (e) {
        if (e is FirebaseException) {
          throw FirestoreFailure.fromCode(e.code);
        } else {
          throw const FirestoreFailure();
        }
      },
    );
  }

  String getDocId(String collection) =>
      _firestore.collection(collection).doc().id;

  // ========== Collection Operations ==========
  Stream<QuerySnapshot> streamCollection({
    required String path,
    Query Function(Query query)? queryBuilder,
  }) {
    Query query = _firestore.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    return query.snapshots().handleError(_handleError);
  }

  Future<QuerySnapshot> getCollection({
    required String path,
    Query Function(Query query)? queryBuilder,
  }) {
    Query query = _firestore.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    return query.get().catchError(_handleError);
  }

  // ========== Subcollection Operations ==========

  Future<QuerySnapshot> getSubcollection({
    required String collection,
    required String docId,
    required String subcollection,
    Query Function(Query query)? queryBuilder,
  }) {
    Query query = _firestore
        .collection(collection)
        .doc(docId)
        .collection(subcollection);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    return query.get().catchError(_handleError);
  }

  Stream<QuerySnapshot> streamSubcollection({
    required String collection,
    required String docId,
    required String subcollection,
    Query Function(Query query)? queryBuilder,
  }) {
    Query query = _firestore
        .collection(collection)
        .doc(docId)
        .collection(subcollection);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    return query.snapshots().handleError(_handleError);
  }

  Future<void> addSubcollectionDocument({
    required String collection,
    required String docId,
    required String subcollection,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore
          .collection(collection)
          .doc(docId)
          .collection(subcollection)
          .add(data);
    } on FirebaseException catch (e) {
      throw FirestoreFailure.fromCode(e.code);
    } catch (e) {
      throw const FirestoreFailure();
    }
  }

  Future<void> deleteSubcollectionDocument({
    required String collection,
    required String docId,
    required String subcollection,
    required String subDocId,
  }) async {
    try {
      await _firestore
          .collection(collection)
          .doc(docId)
          .collection(subcollection)
          .doc(subDocId)
          .delete();
    } on FirebaseException catch (e) {
      throw FirestoreFailure.fromCode(e.code);
    } catch (e) {
      throw const FirestoreFailure();
    }
  }

  Future<void> updateSubcollectionDocument({
    required String collection,
    required String docId,
    required String subcollection,
    required String subDocId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      await _firestore
          .collection(collection)
          .doc(docId)
          .collection(subcollection)
          .doc(subDocId)
          .update(updates);
    } on FirebaseException catch (e) {
      throw FirestoreFailure.fromCode(e.code);
    } catch (e) {
      throw const FirestoreFailure();
    }
  }

  dynamic _handleError(dynamic error) {
    if (error is FirebaseException) {
      throw FirestoreFailure.fromCode(error.code);
    } else {
      throw const FirestoreFailure();
    }
  }
}

// Custom exception class
class FirestoreFailure implements Exception {
  final String message;

  const FirestoreFailure([this.message = 'Firestore operation failed']);

  factory FirestoreFailure.fromCode(String code) {
    switch (code) {
      case 'permission-denied':
        return const FirestoreFailure('Permission denied');
      case 'not-found':
        return const FirestoreFailure('Document not found');
      default:
        return const FirestoreFailure();
    }
  }
}
