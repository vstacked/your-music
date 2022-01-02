import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../data/services/firebase_service.dart';
import '../models/song_model.dart';

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

  SongModel? _playedSong;
  SongModel? get playedSong => _playedSong;

  bool get isOpen => _openedSong != null;

  bool _isRemove = false;
  bool get isRemove => _isRemove;
  void setRemove(bool value) {
    _isRemove = value;
    notifyListeners();
  }

  bool _isRemoveLoading = false;
  bool get isRemoveLoading => _isRemoveLoading;

  bool _isRemoveFailed = false;
  bool get isRemoveFailed => _isRemoveFailed;

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
    if (queue.where((element) => element == song).isEmpty) queue.add(song);
    notifyListeners();

    final isSuccess = await _firestoreService.saveOrUpdateSong(song, isEdit: isEdit);
    if (isSuccess) {
      queue.remove(song);
      _firestoreService.sendMessage(
        type: !isEdit ? MessageType.added : MessageType.edited,
        title: '${song.singer} - ${song.title}',
      );
    } else {
      queue.firstWhere((element) => element == song).isError = true;
    }

    notifyListeners();
  }

  Future<void> deleteSong() async {
    _isRemove = _isRemoveFailed = false;
    _isRemoveLoading = true;
    _openedSong = null;
    notifyListeners();

    for (var item in _removeIds) {
      bool isDeleted = await _firestoreService.deleteSong(item);
      if (!isDeleted) {
        _isRemoveFailed = true;
        break;
      }
    }

    if (!_isRemoveFailed) {
      _firestoreService.sendMessage(type: MessageType.deleted, title: _removeIds.length.toString());
      clearRemoveIds();
    }
    _isRemoveLoading = false;
    notifyListeners();
  }

  Stream<QuerySnapshot> fetchSongs() => _firestoreService.fetchSongs();
}
