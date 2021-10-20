import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_music/constants/colors.dart';
import 'package:your_music/models/song_model.dart';
import 'package:your_music/providers/song_provider.dart';
import 'package:your_music/widgets/base_field.dart';
import 'package:your_music/widgets/icon_button_widget.dart';
import 'package:your_music/widgets/responsive_layout.dart';

AlertDialog deleteSong(BuildContext context) {
  return AlertDialog(
    title: const Text('Remove Song'),
    content: const Text('Are you sure you want to delete this song?'),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    backgroundColor: secondaryColor,
    actionsPadding: const EdgeInsets.all(8),
    contentTextStyle: Theme.of(context).textTheme.subtitle1!.copyWith(color: greyColor),
    actions: [
      OutlinedButton(
        onPressed: () {
          final _read = context.read<SongProvider>();
          _read.clearRemoveIds();
          _read.setRemove(false);
          Navigator.pop(context);
        },
        child: const Text('Cancel'),
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all(const Size(80, 35)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          side: MaterialStateProperty.all(const BorderSide(color: greyColor, width: 1)),
          foregroundColor: MaterialStateProperty.all(greyColor),
        ),
      ),
      ElevatedButton(
        onPressed: () {},
        child: const Text('Yes'),
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all(const Size(80, 35)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          backgroundColor: MaterialStateProperty.all(redColor),
          foregroundColor: MaterialStateProperty.all(greyColor),
          elevation: MaterialStateProperty.all(0),
        ),
      ),
    ],
  );
}

Widget songDialog({bool isEditSong = false, SongModel? songModel}) {
  final _formKey = GlobalKey<FormState>();
  String? _songEmpty, _thumbnailEmpty;
  SongModel _songModel = songModel ?? SongModel();

  Widget button(BuildContext context, void Function(void Function()) state) {
    return _button(
      context,
      onSave: () {
        _songEmpty = _songModel.songPlatformFile == null ? 'Songs cannot empty' : null;
        _thumbnailEmpty = _songModel.thumbnailPlatformFile == null ? 'Thumbnails cannot empty' : null;

        if (_formKey.currentState!.validate()) {
          context.read<SongProvider>().saveSong(_songModel);
          Navigator.pop(context);
        }
        state(() {});
      },
    );
  }

  return StatefulBuilder(
    builder: (context, state) {
      final textTheme = Theme.of(context).textTheme;
      return Form(
        key: _formKey,
        child: ResponsiveLayout(
          largeScreen: _dialog(
            children: <Widget>[
              _title(context, title: !isEditSong ? 'Add Song' : 'Edit Song'),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  _song(
                                    textTheme,
                                    errorText: _songEmpty,
                                    songName: _songModel.songPlatformFile != null
                                        ? _songModel.songPlatformFile?.name
                                        : _songModel.song?.path,
                                    result: (data) {
                                      _songModel.songPlatformFile = data;
                                      state(() {});
                                    },
                                  ),
                                  _field(
                                    'Title',
                                    initialValue: _songModel.title,
                                    onChanged: (value) {
                                      _songModel.title = value;
                                      state(() {});
                                    },
                                  ),
                                  _field(
                                    'Singer',
                                    initialValue: _songModel.singer,
                                    onChanged: (value) {
                                      _songModel.singer = value;
                                      state(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 25),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Text('Thumbnail', style: textTheme.subtitle1!.copyWith(color: greyColor)),
                                  const SizedBox(height: 10),
                                  _thumbnail(
                                    180,
                                    textTheme,
                                    errorText: _thumbnailEmpty,
                                    urlPath: _songModel.thumbnail,
                                    bytes: _songModel.thumbnailPlatformFile?.bytes,
                                    result: (data) {
                                      _songModel.thumbnailPlatformFile = data;
                                      state(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _field(
                                'Lyric',
                                isTextArea: true,
                                isOptional: true,
                                initialValue: _songModel.lyric,
                                onChanged: (value) {
                                  _songModel.lyric = value;
                                  state(() {});
                                },
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _field(
                                'Description',
                                isTextArea: true,
                                isOptional: true,
                                initialValue: _songModel.description,
                                onChanged: (data) {
                                  _songModel.description = data;
                                  state(() {});
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              button(context, state),
            ],
          ),
          smallScreen: _dialog(
            children: <Widget>[
              _title(context, title: !isEditSong ? 'Add Song' : 'Edit Song'),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Text('Thumbnail', style: textTheme.subtitle1!.copyWith(color: greyColor)),
                            const SizedBox(width: 50),
                            _thumbnail(
                              150,
                              textTheme,
                              errorText: _thumbnailEmpty,
                              urlPath: _songModel.thumbnail,
                              bytes: _songModel.thumbnailPlatformFile?.bytes,
                              result: (data) {
                                _songModel.thumbnailPlatformFile = data;
                                state(() {});
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        _song(
                          textTheme,
                          errorText: _songEmpty,
                          songName: _songModel.songPlatformFile != null
                              ? _songModel.songPlatformFile?.name
                              : _songModel.song?.path,
                          result: (data) {
                            _songModel.songPlatformFile = data;
                            state(() {});
                          },
                        ),
                        _field(
                          'Title',
                          initialValue: _songModel.title,
                          onChanged: (value) {
                            _songModel.title = value;
                            state(() {});
                          },
                        ),
                        _field(
                          'Singer',
                          initialValue: _songModel.singer,
                          onChanged: (value) {
                            _songModel.singer = value;
                            state(() {});
                          },
                        ),
                        _field(
                          'Lyric',
                          isTextArea: true,
                          isOptional: true,
                          initialValue: _songModel.lyric,
                          onChanged: (value) {
                            _songModel.lyric = value;
                            state(() {});
                          },
                        ),
                        _field(
                          'Description',
                          isTextArea: true,
                          isOptional: true,
                          initialValue: _songModel.description,
                          onChanged: (data) {
                            _songModel.description = data;
                            state(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              button(context, state),
            ],
          ),
        ),
      );
    },
  );
}

Dialog _dialog({required List<Widget> children}) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    backgroundColor: secondaryColor,
    child: SizedBox(width: 500, child: Column(children: children, mainAxisSize: MainAxisSize.min)),
  );
}

Column _title(BuildContext context, {required String title}) {
  final textTheme = Theme.of(context).textTheme;
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: textTheme.headline6!.copyWith(color: greyColor.withOpacity(.75), fontWeight: FontWeight.w600),
            ),
            IconButtonWidget(
              icon: const Icon(Icons.close),
              color: greyColor,
              iconSize: 27.5,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      const Divider(thickness: 1, color: greyColor, height: 0),
      const SizedBox(height: 15),
    ],
  );
}

OutlinedButton _chooseFile(Size size, {required VoidCallback onPressed}) {
  return OutlinedButton(
    onPressed: onPressed,
    child: const Text('Choose File'),
    style: ButtonStyle(
      fixedSize: MaterialStateProperty.all(size),
      side: MaterialStateProperty.all(const BorderSide(width: .75, color: greyColor)),
    ),
  );
}

Column _thumbnail(double size, TextTheme textTheme,
    {required void Function(PlatformFile data) result, String? urlPath, Uint8List? bytes, String? errorText}) {
  return Column(
    children: [
      Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: greyColor,
          image: urlPath != null
              ? DecorationImage(image: NetworkImage(urlPath), fit: BoxFit.cover)
              : (bytes != null ? DecorationImage(image: MemoryImage(bytes), fit: BoxFit.cover) : null),
        ),
      ),
      const SizedBox(height: 20),
      if (errorText != null) Text(errorText, style: textTheme.bodyText1!.copyWith(color: redColor)),
      _chooseFile(
        const Size(160, 35),
        onPressed: () async {
          FilePickerResult? picker = await FilePicker.platform.pickFiles(type: FileType.image);
          if (picker != null) result(picker.files.single);
        },
      ),
    ],
  );
}

Column _song(TextTheme textTheme,
    {String? songName, String? errorText, required void Function(PlatformFile data) result}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Song', style: textTheme.subtitle1!.copyWith(color: greyColor)),
      const SizedBox(height: 10),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (songName != null)
            Text(
              songName,
              style: textTheme.bodyText1!.copyWith(color: greyColor),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          if (errorText != null) Text(errorText, style: textTheme.bodyText1!.copyWith(color: redColor)),
          const SizedBox(height: 10),
          _chooseFile(
            const Size(140, 30),
            onPressed: () async {
              FilePickerResult? picker = await FilePicker.platform.pickFiles(type: FileType.audio);
              if (picker != null) result(picker.files.single);
            },
          ),
        ],
      ),
    ],
  );
}

Column _field(String title,
    {bool isTextArea = false, bool isOptional = false, void Function(String value)? onChanged, String? initialValue}) {
  return Column(
    children: [
      const SizedBox(height: 25),
      BaseField(
        title: title,
        isTextArea: isTextArea,
        isOptional: isOptional,
        onChanged: onChanged,
        initialValue: initialValue,
      ),
    ],
  );
}

Column _button(BuildContext context, {required void Function()? onSave}) {
  return Column(
    children: [
      const SizedBox(height: 15),
      const Divider(thickness: 1, color: greyColor, height: 0),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: .5),
        child: ButtonBar(
          children: [
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(const Size(88, 36)),
                side: MaterialStateProperty.all(const BorderSide(width: .75, color: greyColor)),
              ),
            ),
            ElevatedButton(
              onPressed: onSave,
              child: const Text('Save'),
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(const Size(88, 36)),
                backgroundColor: MaterialStateProperty.all(greenColor),
                elevation: MaterialStateProperty.all(0),
                foregroundColor: MaterialStateProperty.all(greyColor),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
