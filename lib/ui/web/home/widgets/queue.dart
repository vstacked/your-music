import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:your_music/constants/colors.dart';
import 'package:provider/provider.dart';
import 'package:your_music/providers/song_provider.dart';

class Queue extends StatelessWidget {
  const Queue({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final songWatch = context.watch<SongProvider>();
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: const EdgeInsets.all(8),
        height: 175,
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: primaryColor,
          boxShadow: const [BoxShadow(color: secondaryColor, blurRadius: 3, spreadRadius: 5)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Queue',
                style: textTheme.subtitle1!.copyWith(color: greyColor, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(thickness: 1, color: greyColor, height: 0),
            Flexible(
              child: ListView.separated(
                itemCount: songWatch.queue.length,
                shrinkWrap: true,
                separatorBuilder: (_, __) => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(thickness: 1, color: greyColor, height: 0),
                ),
                itemBuilder: (_, i) {
                  return Material(
                    color: Colors.transparent,
                    child: ListTile(
                      title: Text(songWatch.queue[i].title),
                      subtitle: Text(songWatch.queue[i].singer),
                      tileColor: !songWatch.queue[i].isError ? Colors.transparent : redColor,
                      trailing: !songWatch.queue[i].isError
                          ? const CupertinoActivityIndicator()
                          : IconButton(
                              onPressed: () {
                                songWatch.queue[i].isError = false;
                                context.read<SongProvider>().saveOrUpdateSong(songWatch.queue[i]);
                              },
                              icon: const Icon(Icons.refresh_rounded),
                            ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
