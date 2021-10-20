import 'package:flutter/material.dart';
import 'package:your_music/data/services/firebase_service.dart';
import 'package:your_music/models/song_model.dart';

class SongProvider extends ChangeNotifier {
  //

  final _firestoreService = FirebaseService.instance;

  List<SongModel> queue = [];

  int? _openedSong;
  int? get openedSong => _openedSong;
  void setOpenedSong(int? value) {
    _openedSong = value;
    notifyListeners();
  }

  bool get isOpen => _openedSong != null;

  bool _isRemove = false;
  bool get isRemove => _isRemove;
  void setRemove(bool value) {
    _isRemove = value;
    notifyListeners();
  }

  final List<int> _removeIds = [];
  bool containsRemoveId(int id) => _removeIds.contains(id);
  void setRemoveIds(int id) {
    if (_removeIds.contains(id)) {
      _removeIds.remove(id);
    } else {
      _removeIds.add(id);
    }
    notifyListeners();
  }

  void clearRemoveIds() => _removeIds.clear();

  Future<void> saveSong(SongModel song) async {
    queue.add(song);
    notifyListeners();
    final isSuccess = await _firestoreService.saveSong(song);
    if (isSuccess) queue.remove(song);
    notifyListeners();
  }
}
