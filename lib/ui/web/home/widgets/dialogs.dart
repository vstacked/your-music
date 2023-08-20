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
    contentTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: greyColor),
    actions: [
      OutlinedButton(
        onPressed: () {
          final read = context.read<SongProvider>();
          read.clearRemoveIds();
          read.setRemove(false);
          Navigator.pop(context);
        },
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all(const Size(80, 35)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          side: MaterialStateProperty.all(const BorderSide(color: greyColor, width: 1)),
          foregroundColor: MaterialStateProperty.all(greyColor),
        ),
        child: const Text('Cancel'),
      ),
      ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
          context.read<SongProvider>().deleteSong();
        },
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all(const Size(80, 35)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          backgroundColor: MaterialStateProperty.all(redColor),
          foregroundColor: MaterialStateProperty.all(greyColor),
          elevation: MaterialStateProperty.all(0),
        ),
        child: const Text('Yes'),
      ),
    ],
  );
}

Widget songDialog({bool isEdit = false, SongUpload? songModel}) {
  final formKey = GlobalKey<FormState>();
  String? songEmpty, thumbnailEmpty;
  SongUpload model = songModel ?? SongUpload();

  Widget button(BuildContext context, void Function(void Function()) state) {
    return _button(
      context,
      onSave: () {
        songEmpty = model.songPlatformFile == null ? 'Songs cannot empty' : null;
        thumbnailEmpty = model.thumbnailPlatformFile == null ? 'Thumbnails cannot empty' : null;

        if (formKey.currentState!.validate()) {
          context.read<SongProvider>().saveOrUpdateSong(model, isEdit: isEdit);
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
        key: formKey,
        child: ResponsiveLayout(
          largeScreen: _dialog(
            children: <Widget>[
              _title(context, title: !isEdit ? 'Add Song' : 'Edit Song'),
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
                                    errorText: songEmpty,
                                    songName: model.songPlatformFile != null
                                        ? model.songPlatformFile?.name
                                        : model.fileDetail?.name,
                                    result: (data) {
                                      model.songPlatformFile = data;
                                      state(() {});
                                    },
                                  ),
                                  _field(
                                    'Title',
                                    initialValue: model.title,
                                    onChanged: (value) {
                                      model.title = value;
                                      state(() {});
                                    },
                                  ),
                                  _field(
                                    'Singer',
                                    initialValue: model.singer,
                                    onChanged: (value) {
                                      model.singer = value;
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
                                  Text('Thumbnail', style: textTheme.titleMedium!.copyWith(color: greyColor)),
                                  const SizedBox(height: 10),
                                  _thumbnail(
                                    180,
                                    textTheme,
                                    errorText: thumbnailEmpty,
                                    urlPath: model.thumbnailUrl,
                                    bytes: model.thumbnailPlatformFile?.bytes,
                                    result: (data) {
                                      model.thumbnailPlatformFile = data;
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
                                initialValue: model.lyric,
                                onChanged: (value) {
                                  model.lyric = value;
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
                                initialValue: model.description,
                                onChanged: (data) {
                                  model.description = data;
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
              _title(context, title: !isEdit ? 'Add Song' : 'Edit Song'),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Text('Thumbnail', style: textTheme.titleMedium!.copyWith(color: greyColor)),
                            const SizedBox(width: 50),
                            _thumbnail(
                              150,
                              textTheme,
                              errorText: thumbnailEmpty,
                              urlPath: model.thumbnailUrl,
                              bytes: model.thumbnailPlatformFile?.bytes,
                              result: (data) {
                                model.thumbnailPlatformFile = data;
                                state(() {});
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        _song(
                          textTheme,
                          errorText: songEmpty,
                          songName:
                              model.songPlatformFile != null ? model.songPlatformFile?.name : model.fileDetail?.name,
                          result: (data) {
                            model.songPlatformFile = data;
                            state(() {});
                          },
                        ),
                        _field(
                          'Title',
                          initialValue: model.title,
                          onChanged: (value) {
                            model.title = value;
                            state(() {});
                          },
                        ),
                        _field(
                          'Singer',
                          initialValue: model.singer,
                          onChanged: (value) {
                            model.singer = value;
                            state(() {});
                          },
                        ),
                        _field(
                          'Lyric',
                          isTextArea: true,
                          isOptional: true,
                          initialValue: model.lyric,
                          onChanged: (value) {
                            model.lyric = value;
                            state(() {});
                          },
                        ),
                        _field(
                          'Description',
                          isTextArea: true,
                          isOptional: true,
                          initialValue: model.description,
                          onChanged: (data) {
                            model.description = data;
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
    child: SizedBox(width: 500, child: Column(mainAxisSize: MainAxisSize.min, children: children)),
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
              style: textTheme.titleLarge!.copyWith(color: greyColor.withOpacity(.75), fontWeight: FontWeight.w600),
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
    style: ButtonStyle(
      fixedSize: MaterialStateProperty.all(size),
      side: MaterialStateProperty.all(const BorderSide(width: .75, color: greyColor)),
    ),
    child: const Text('Choose File'),
  );
}

Column _thumbnail(double size, TextTheme textTheme,
    {required void Function(PlatformFile data) result, String urlPath = '', Uint8List? bytes, String? errorText}) {
  return Column(
    children: [
      Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: greyColor,
          image: urlPath.isNotEmpty && bytes == null
              ? DecorationImage(image: NetworkImage(urlPath), fit: BoxFit.cover)
              : (bytes != null ? DecorationImage(image: MemoryImage(bytes), fit: BoxFit.cover) : null),
        ),
      ),
      const SizedBox(height: 20),
      if (errorText != null) Text(errorText, style: textTheme.bodyLarge!.copyWith(color: redColor)),
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
      Text('Song', style: textTheme.titleMedium!.copyWith(color: greyColor)),
      const SizedBox(height: 10),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (songName != null)
            Text(
              songName,
              style: textTheme.bodyLarge!.copyWith(color: greyColor),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          if (errorText != null) Text(errorText, style: textTheme.bodyLarge!.copyWith(color: redColor)),
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
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(const Size(88, 36)),
                side: MaterialStateProperty.all(const BorderSide(width: .75, color: greyColor)),
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: onSave,
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(const Size(88, 36)),
                backgroundColor: MaterialStateProperty.all(greenColor),
                elevation: MaterialStateProperty.all(0),
                foregroundColor: MaterialStateProperty.all(greyColor),
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    ],
  );
}
