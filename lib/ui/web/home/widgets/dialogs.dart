import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_music/constants/colors.dart';
import 'package:your_music/providers/song_provider.dart';

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
