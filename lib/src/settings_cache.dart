import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:hive/hive.dart';

class HiveSettingsCache extends CacheProvider {
  late final Box _box;
  final String _boxName;
  HiveSettingsCache(this._boxName);
  
  @override
  bool containsKey(String key) {
    return _box.containsKey(key);
  }

  @override
  bool? getBool(String key, {bool? defaultValue}) {
    return _box.get(key, defaultValue: defaultValue);
  }

  @override
  double? getDouble(String key, {double? defaultValue}) {
    return _box.get(key, defaultValue: defaultValue);
  }

  @override
  int? getInt(String key, {int? defaultValue}) {
    return _box.get(key, defaultValue: defaultValue);
  }

  @override
  Set getKeys() {
    return _box.keys.toSet();
  }

  @override
  String? getString(String key, {String? defaultValue}) {
    return _box.get(key, defaultValue: defaultValue);
  }
  
  @override
  T? getValue<T>(String key, {T? defaultValue}) {
    return _box.get(key, defaultValue: defaultValue);
  }

  @override
  Future<void> init() {
    return Hive.openBox(_boxName).then((value) => _box = value);
  }

  @override
  Future<void> remove(String key) {
    return _box.delete(key);
  }

  @override
  Future<void> removeAll() {
    return _box.clear();
  }

  @override
  Future<void> setBool(String key, bool? value) {
    return _box.put(key, value);
  }

  @override
  Future<void> setDouble(String key, double? value) {
    return _box.put(key, value);
  }

  @override
  Future<void> setInt(String key, int? value) {
    return _box.put(key, value);
  }

  @override
  Future<void> setObject<T>(String key, T? value) {
    return _box.put(key, value);
  }

  @override
  Future<void> setString(String key, String? value) {
    return _box.put(key, value);
  }

}