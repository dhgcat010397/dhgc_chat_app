import 'package:dhgc_chat_app/src/core/services/firestore_service.dart';
import 'package:dhgc_chat_app/src/core/services/fstorage_service.dart';
import 'package:dhgc_chat_app/src/core/utils/dependencies_injection.dart';

Future<void> firebaseInjectionContainer() async {
  final firestoreService = FirestoreService();
  final fstorageService = FStorageService();

  // Register with your DI system (get_it, provider, etc.)
  sl.registerSingleton<FirestoreService>(firestoreService);
  sl.registerSingleton<FStorageService>(fstorageService);
}
