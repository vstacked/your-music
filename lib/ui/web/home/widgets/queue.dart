import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:your_music/constants/colors.dart';

class Queue extends StatelessWidget {
  const Queue({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: const EdgeInsets.all(8),
        height: 175,
        width: 300,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: primaryColor),
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
                itemCount: 3,
                shrinkWrap: true,
                separatorBuilder: (_, __) => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(thickness: 1, color: greyColor, height: 0),
                ),
                itemBuilder: (_, i) {
                  return ListTile(
                    title: Text('Title Music $i'),
                    subtitle: Text('Singer $i'),
                    trailing: const CupertinoActivityIndicator(),
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
