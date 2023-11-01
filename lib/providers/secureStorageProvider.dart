import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageNotifier extends StateNotifier<FlutterSecureStorage> {
  SecureStorageNotifier()
      : super(const FlutterSecureStorage(
            aOptions: AndroidOptions(encryptedSharedPreferences: true)));
}

final secureStorageProvider =
    StateNotifierProvider<SecureStorageNotifier, FlutterSecureStorage>((ref) {
  return SecureStorageNotifier();
});
