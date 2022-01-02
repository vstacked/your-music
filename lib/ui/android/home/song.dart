import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../constants/colors.dart';
import '../../../models/song_model.dart';

class Song extends StatefulWidget {
  final SongModel song;
  final bool isCard;
  const Song({Key? key, this.isCard = false, required this.song}) : super(key: key);

  @override
  _SongState createState() => _SongState();
}

class _SongState extends State<Song> {
  late final AudioPlayer audioPlayer;
  String duration = '';
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    _getDuration();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void _getDuration() async {
    try {
      Uri uri = Uri.parse(widget.song.song!.url!);
      await audioPlayer.setUrl(uri.toString());
      setState(() {
        duration = audioPlayer.duration.toString().split('.').first.substring(2);
      });
    } catch (e) {
      debugPrint('_getDuration() $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    if (widget.isCard) {
      return InkWell(
        onTap: () {},
        customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Ink(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            image: DecorationImage(image: NetworkImage(widget.song.thumbnailUrl!), fit: BoxFit.cover),
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
                  widget.song.title!,
                  style: textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w600, color: greyColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  widget.song.singer!,
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
                        duration,
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
      );
    }
    return ListTile(
      leading: Container(
        height: 56,
        width: 56,
        decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage(widget.song.thumbnailUrl!), fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      title: Text(
        widget.song.title!,
        style: textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w600, color: greyColor),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        widget.song.singer!,
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
                duration,
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
      onTap: () {},
    );
  }
}
