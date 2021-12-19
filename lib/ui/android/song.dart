import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class Song extends StatefulWidget {
  final bool isCard;
  const Song({Key? key, this.isCard = false}) : super(key: key);

  @override
  _SongState createState() => _SongState();
}

class _SongState extends State<Song> {
  bool isFavorite = false;
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
            image: const DecorationImage(image: NetworkImage('http://placeimg.com/640/480'), fit: BoxFit.cover),
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
                  'Title',
                  style: textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w600, color: greyColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  'Singer',
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
                        '03:40',
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
          image: const DecorationImage(
            image: NetworkImage('http://placeimg.com/640/480'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      title: Text(
        'Title',
        style: textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w600, color: greyColor),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        'Singer',
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
                '03:40',
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
