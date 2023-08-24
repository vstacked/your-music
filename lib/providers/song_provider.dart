import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:your_music/constants/key.dart';

import '../data/services/firebase_service.dart';
import '../models/favorite_model.dart';
import '../models/song_model.dart';

class SongProvider extends ChangeNotifier {
  final FirebaseService _firebaseService;

  SongProvider(this._firebaseService) {
    if (!kIsWeb) {
      _getFavorite();
      _firebaseService.initMessaging();
    }
  }

  bool get isVoiceAssistantActive => _firebaseService.isVoiceAssistantActive;

  Future<void> recordError(dynamic e, StackTrace? s) => _firebaseService.recordError(e, s);

  List<SongUpload> queue = [];
  List<FavoriteModel> _favorite = [];

  List<FavoriteModel> get favorite => _favorite;

  SongUpload? _openedSong;

  SongUpload? get openedSong => _openedSong;

  void setOpenedSong(SongModel? value) {
    _openedSong = value != null ? SongUpload.fromJson(value.toJson()) : null;
    notifyListeners();
  }

  SongModel? _detailSong;

  SongModel? get detailSong => _detailSong;

  set detailSong(SongModel? song) {
    _detailSong = song;
    notifyListeners();
  }

  final AudioPlayer _audioPlayer = AudioPlayer();

  AudioPlayer get audioPlayer => _audioPlayer;

  SongModel? _playedSong;

  SongModel? get playedSong => _playedSong;

  set playedSong(SongModel? song) {
    _playedSong = song;
    notifyListeners();
  }

  List<SongModel> _playlistSource = [];

  int sourceAudioIndex(String id) => _playlistSource.indexWhere((element) => element.id == id);

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

  bool isRemoveIdsEmpty() => _removeIds.isEmpty;

  void clearRemoveIds() => _removeIds.clear();

  Future<void> saveOrUpdateSong(SongUpload song, {bool isEdit = false}) async {
    _openedSong = null;
    if (queue.where((element) => element == song).isEmpty) queue.add(song);
    notifyListeners();

    final isSuccess = isEdit ? await _firebaseService.updateSong(song) : await _firebaseService.saveSong(song);
    if (isSuccess) {
      queue.remove(song);
      _firebaseService.sendMessage(
        type: !isEdit ? MessageType.added : MessageType.edited,
        title: '${song.singer} - ${song.title}',
        songId: song.id,
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
      bool isDeleted = await _firebaseService.deleteSong(item);
      if (!isDeleted) {
        _isRemoveFailed = true;
        break;
      }
    }

    if (!_isRemoveFailed) {
      _firebaseService.sendMessage(type: MessageType.deleted, title: _removeIds.length.toString());
      clearRemoveIds();
    }
    _isRemoveLoading = false;
    notifyListeners();
  }

  void _getFavorite() {
    final box = Hive.box<FavoriteModel>(KeyConstant.boxFavorites);

    _favorite = box.values.toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt))
      ..toList();

    notifyListeners();
  }

  void setFavorite({required SongModel song, required bool isFavorite}) {
    final box = Hive.box<FavoriteModel>(KeyConstant.boxFavorites);

    final data = box.values.toList();
    if (isFavorite && data.where((element) => element.id == song.id).isEmpty) {
      box.add(
        FavoriteModel(
          id: song.id,
          title: song.title,
          singer: song.singer,
          duration: song.fileDetail!.duration,
          thumbnail: song.thumbnailUrl,
          createdAt: DateTime.now(),
        ),
      );
    } else {
      box.deleteAt(data.indexWhere((element) => element.id == song.id));
    }

    _getFavorite();
  }

  Stream<QuerySnapshot> fetchSongs() => _firebaseService.fetchSongs();

  void setLoopMode(LoopMode mode) => audioPlayer.setLoopMode(mode);

  void setShuffleMode(bool enabled) => audioPlayer.setShuffleModeEnabled(enabled);

  Future<void> loadPlayer() async {
    try {
      final snapshot = await _firebaseService.fetchSongsAsync();
      _playlistSource = snapshot.docs
          .map((e) => SongModel.fromJson(Map.from(e.data() as LinkedHashMap)..remove('created_at'))..id = e.id)
          .toList();

      await audioPlayer.setAudioSource(
        ConcatenatingAudioSource(
          children: _playlistSource
              .map(
                (e) => AudioSource.uri(
                  Uri.parse(e.fileDetail!.url),
                  tag: MediaItem(id: e.id, title: e.title, artist: e.singer, artUri: Uri.parse(e.thumbnailUrl)),
                ),
              )
              .toList(),
        ),
      );

      await audioPlayer.load();
      audioPlayer.sequenceStateStream.listen((event) {
        if (event != null) {
          if (audioPlayer.playing) {
            playedSong = _playlistSource[event.currentIndex];
          }
          detailSong = _playlistSource[event.currentIndex];
        }
      });
      audioPlayer.playingStream.listen((isPlaying) {
        if (isPlaying && detailSong != null) playedSong = detailSong;
      });
      notifyListeners();
    } catch (e, s) {
      recordError(e, s);
      debugPrint('_setAudio()| $e');
    }
  }

  void voiceAssistantAction(Map<String, dynamic> map) {
    switch (map['command']) {
      case 'play_specific':
        final title = map['title'];
        final playlist = _playlistSource;

        final data = extractTop(query: title, choices: playlist.map((e) => e.title).toList(), limit: 1, cutoff: 80);
        final matchingSong = data.isNotEmpty ? playlist[data.first.index] : null;

        if (matchingSong != null) {
          playedSong = matchingSong;
          _audioPlayer.seek(Duration.zero, index: sourceAudioIndex(matchingSong.id));
          _audioPlayer.play();
        }
        break;
      case 'play':
        final playlist = _playlistSource;

        final r = Random();
        final song = playlist[r.nextInt(playlist.length)];

        playedSong = song;
        _audioPlayer.seek(Duration.zero, index: sourceAudioIndex(song.id));
        _audioPlayer.play();
        break;
      case 'resume':
        if (_playedSong != null && !_audioPlayer.playing) _audioPlayer.play();
        break;
      case 'stop':
        if (_playedSong != null && _audioPlayer.playing) _audioPlayer.pause();
        break;
      case 'next':
        if (_playedSong != null) _audioPlayer.seekToNext();
        break;
      case 'prev':
        if (_playedSong != null) _audioPlayer.seekToPrevious();
        break;
      default:
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
