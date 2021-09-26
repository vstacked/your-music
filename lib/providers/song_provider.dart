import 'package:flutter/material.dart';

class SongProvider extends ChangeNotifier {
  //

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
}
