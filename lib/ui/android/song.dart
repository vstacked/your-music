import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class Song extends StatefulWidget {
  const Song({Key? key}) : super(key: key);

  @override
  _SongState createState() => _SongState();
}

class _SongState extends State<Song> {
  bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
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
