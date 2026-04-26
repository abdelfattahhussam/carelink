import 'package:carelink_app/core/network/auth_storage.dart';

/// In-memory [AuthStorage] implementation for unit tests.
///
/// Avoids platform channel dependencies from FlutterSecureStorage.
class FakeAuthStorage implements AuthStorage {
  final _store = <String, String>{};

  @override
  Future<String?> read(String key) async => _store[key];

  @override
  Future<void> write(String key, String value) async => _store[key] = value;

  @override
  Future<void> delete(String key) async => _store.remove(key);

  @override
  Future<void> deleteAll() async => _store.clear();
}
