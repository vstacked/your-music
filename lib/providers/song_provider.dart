import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:your_music/data/services/firebase_service.dart';
import 'package:your_music/models/song_model.dart';

class SongProvider extends ChangeNotifier {
  //

  final _firestoreService = FirebaseService.instance;

  List<SongModel> queue = [];

  SongModel? _openedSong;
  SongModel? get openedSong => _openedSong;
  void setOpenedSong(SongModel? value) {
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

  bool _isRemoveLoading = false;
  bool get isRemoveLoading => _isRemoveLoading;

  final List<String> _removeIds = [];
  bool containsRemoveId(String id) => _removeIds.contains(id);
  void setRemoveIds(String id) {
    if (_removeIds.contains(id)) {
      _removeIds.remove(id);
    } else {
      _removeIds.add(id);
    }
    notifyListeners();
  }

  void clearRemoveIds() => _removeIds.clear();

  Future<void> saveOrUpdateSong(SongModel song, {bool isEdit = false}) async {
    _openedSong = null;
    queue.add(song);
    notifyListeners();
    final isSuccess = await _firestoreService.saveOrUpdateSong(song, isEdit: isEdit);
    if (isSuccess) queue.remove(song);
    notifyListeners();
  }

  Future<void> deleteSong() async {
    _isRemove = false;
    _isRemoveLoading = true;
    notifyListeners();

    for (var item in _removeIds) {
      await _firestoreService.deleteSong(item);
    }

    clearRemoveIds();
    _isRemoveLoading = false;
    notifyListeners();
  }

  Stream<QuerySnapshot> fetchSongs() => _firestoreService.fetchSongs();
}
