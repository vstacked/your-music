import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/colors.dart';
import '../../../models/song_model.dart';
import '../../../providers/song_provider.dart';
import '../../../utils/routes/routes.dart';

class Song extends StatefulWidget {
  final SongModel song;
  final bool isDisable;
  final bool isCard;
  const Song({Key? key, this.isCard = false, required this.song, this.isDisable = false}) : super(key: key);

  @override
  _SongState createState() => _SongState();
}

class _SongState extends State<Song> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    isFavorite = context.watch<SongProvider>().favorite.where((element) => element.id == widget.song.id).isNotEmpty;
    if (widget.isCard) {
      return Opacity(
        opacity: !widget.isDisable ? 1 : .5,
        child: InkWell(
          onTap: !widget.isDisable
              ? () {
                  context.read<SongProvider>().detailSong = widget.song;
                  Navigator.pushNamed(context, Routes.detail);
                }
              : () => _showSongDeletedSnackbar(textTheme),
          customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Ink(
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              image: DecorationImage(image: NetworkImage(widget.song.thumbnailUrl), fit: BoxFit.cover),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: overlayColor,
                  borderRadius:
                      const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                ),
                child: ListTile(
                  title: Text(
                    widget.song.title,
                    style: textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w600, color: greyColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    widget.song.singer,
                    style: textTheme.caption!.copyWith(color: greyColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: SizedBox(
                    width: 40,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                isFavorite = !isFavorite;
                              });
                              context.read<SongProvider>().setFavorite(song: widget.song, isFavorite: isFavorite);
                            },
                            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_outline),
                            iconSize: 20,
                            padding: EdgeInsets.zero,
                            color: greyColor,
                            visualDensity: VisualDensity.compact,
                            splashRadius: 20,
                          ),
                        ),
                        Text(
                          widget.song.fileDetail!.duration,
                          style: textTheme.bodyText2!.copyWith(color: greyColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Opacity(
      opacity: !widget.isDisable ? 1 : .5,
      child: ListTile(
        leading: Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            image: DecorationImage(image: NetworkImage(widget.song.thumbnailUrl), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        title: Text(
          widget.song.title,
          style: textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w600, color: greyColor),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          widget.song.singer,
          style: textTheme.caption!.copyWith(color: greyColor),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: SizedBox(
          width: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Flexible(
                child: Text(
                  widget.song.fileDetail!.duration,
                  style: textTheme.bodyText2!.copyWith(color: greyColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                  context.read<SongProvider>().setFavorite(song: widget.song, isFavorite: isFavorite);
                },
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_outline),
                iconSize: 20,
                color: greyColor,
                visualDensity: VisualDensity.compact,
                splashRadius: 20,
              )
            ],
          ),
        ),
        onTap: !widget.isDisable
            ? () {
                context.read<SongProvider>().detailSong = widget.song;
                Navigator.pushNamed(context, Routes.detail);
              }
            : () => _showSongDeletedSnackbar(textTheme),
      ),
    );
  }

  void _showSongDeletedSnackbar(TextTheme textTheme) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Song deleted from Cloud, sorry',
          style: textTheme.bodyText1!.copyWith(color: greyColor),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: redColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 16.0),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () => ScaffoldMessenger.of(context).removeCurrentSnackBar(),
          textColor: greyColor,
        ),
      ),
    );
  }
}
