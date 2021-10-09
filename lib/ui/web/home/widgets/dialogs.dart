import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_music/constants/colors.dart';
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

ResponsiveLayout addSong(BuildContext context) {
  final textTheme = Theme.of(context).textTheme;

  Widget title() => _title(context, textTheme, title: 'Add Song');

  return ResponsiveLayout(
    largeScreen: _dialog(
      children: <Widget>[
        title(),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _song(textTheme),
                        _field('Title'),
                        _field('Singer'),
                        _field('Lyric', isTextArea: true),
                      ],
                    ),
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text('Thumbnail', style: textTheme.subtitle1!.copyWith(color: greyColor)),
                        const SizedBox(height: 10),
                        _thumbnail(180),
                        _field('Description', isTextArea: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        _button(),
      ],
    ),
    smallScreen: _dialog(
      children: <Widget>[
        title(),
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
                      _thumbnail(150),
                    ],
                  ),
                  const SizedBox(height: 25),
                  _song(textTheme),
                  _field('Title'),
                  _field('Singer'),
                  _field('Lyric'),
                  _field('Lyric', isTextArea: true),
                  _field('Description', isTextArea: true),
                ],
              ),
            ),
          ),
        ),
        _button(),
      ],
    ),
  );
}

ResponsiveLayout editSong(BuildContext context) {
  final textTheme = Theme.of(context).textTheme;

  Widget title() => _title(context, textTheme, title: 'Edit Song');

  Widget song() => _song(textTheme, songName: 'song_name.mp3');

  return ResponsiveLayout(
    largeScreen: _dialog(
      children: <Widget>[
        title(),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        song(),
                        _field('Title'),
                        _field('Singer'),
                        _field('Lyric', isTextArea: true),
                      ],
                    ),
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text('Thumbnail', style: textTheme.subtitle1!.copyWith(color: greyColor)),
                        const SizedBox(height: 10),
                        _thumbnail(180),
                        const SizedBox(height: 27),
                        _field('Description', isTextArea: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        _button(),
      ],
    ),
    smallScreen: _dialog(
      children: <Widget>[
        title(),
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
                      _thumbnail(150),
                    ],
                  ),
                  const SizedBox(height: 25),
                  song(),
                  _field('Title'),
                  _field('Singer'),
                  _field('Lyric'),
                  _field('Lyric', isTextArea: true),
                  _field('Description', isTextArea: true),
                ],
              ),
            ),
          ),
        ),
        _button(),
      ],
    ),
  );
}

Dialog _dialog({required List<Widget> children}) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    backgroundColor: secondaryColor,
    child: SizedBox(width: 500, child: Column(children: children)),
  );
}

Column _title(BuildContext context, TextTheme textTheme, {required String title}) {
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

Column _thumbnail(double size) {
  return Column(
    children: [
      Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: const DecorationImage(
            image: NetworkImage('https://placeimg.com/640/480/business'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      const SizedBox(height: 20),
      _chooseFile(
        const Size(160, 35),
        onPressed: () {},
      ),
    ],
  );
}

Column _song(TextTheme textTheme, {String? songName}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Song', style: textTheme.subtitle1!.copyWith(color: greyColor)),
      const SizedBox(height: 10),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (songName != null) ...[
            Text(songName),
            const SizedBox(height: 10),
          ],
          _chooseFile(
            const Size(140, 30),
            onPressed: () {},
          ),
        ],
      ),
    ],
  );
}

Column _field(String title, {bool isTextArea = false}) {
  return Column(
    children: [
      const SizedBox(height: 25),
      BaseField(title: title, isTextArea: isTextArea),
    ],
  );
}

Column _button() {
  return Column(
    children: [
      const SizedBox(height: 15),
      const Divider(thickness: 1, color: greyColor, height: 0),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: .5),
        child: ButtonBar(
          children: [
            OutlinedButton(
              onPressed: () {},
              child: const Text('Cancel'),
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(const Size(88, 36)),
                side: MaterialStateProperty.all(const BorderSide(width: .75, color: greyColor)),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
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
