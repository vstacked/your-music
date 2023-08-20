import 'package:flutter/material.dart';
import 'package:your_music/constants/colors.dart';

class VoiceAssistantCommandInfo extends StatelessWidget {
  const VoiceAssistantCommandInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          barrierColor: overlayColor,
          routeSettings: const RouteSettings(name: '/voice-assistant-command'),
          builder: (context) => AlertDialog(
            title: const Text('Voice Assistant Command'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Table(
                  columnWidths: const <int, TableColumnWidth>{
                    0: FlexColumnWidth(.7),
                    1: FlexColumnWidth(.1),
                    2: FlexColumnWidth(),
                  },
                  children: <TableRow>[
                    _command(
                      theme,
                      title: RichText(
                        text: TextSpan(
                          style: theme.bodyLarge?.copyWith(color: greyColor),
                          text: 'play',
                          children: [
                            TextSpan(text: ' title ', style: theme.bodyLarge?.copyWith(color: blueColor)),
                            const TextSpan(text: 'song'),
                          ],
                        ),
                      ),
                      caption: 'play a song based on the song title',
                    ),
                    _command(
                      theme,
                      title: Text('play', style: theme.bodyLarge?.copyWith(color: greyColor)),
                      caption: 'play songs randomly',
                    ),
                    _command(
                      theme,
                      title: Text('resume', style: theme.bodyLarge?.copyWith(color: greyColor)),
                      caption: 'play the song that was paused again',
                    ),
                    _command(
                      theme,
                      title: Text('stop | pause', style: theme.bodyLarge?.copyWith(color: greyColor)),
                      caption: 'stop the currently playing song',
                    ),
                    _command(
                      theme,
                      title: Text('next', style: theme.bodyLarge?.copyWith(color: greyColor)),
                      caption: 'play the next song',
                    ),
                    _command(
                      theme,
                      title: Text('previous', style: theme.bodyLarge?.copyWith(color: greyColor)),
                      caption: 'play the previous song',
                    ),
                    _command(
                      theme,
                      title: Text('about', style: theme.bodyLarge?.copyWith(color: greyColor)),
                      caption: 'description about the application',
                    ),
                  ],
                ),
              ],
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: secondaryColor,
            actionsPadding: const EdgeInsets.all(8),
            contentTextStyle: theme.titleMedium!.copyWith(color: greyColor),
          ),
        );
      },
      icon: const Icon(Icons.record_voice_over_outlined),
      iconSize: 30,
      color: greyColor,
      splashRadius: 25,
    );
  }

  TableRow _command(TextTheme theme, {required Widget title, required String caption}) {
    return TableRow(
      children: <Widget>[
        title,
        Text('-', style: theme.bodyLarge),
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Text(caption, style: theme.bodySmall?.copyWith(color: Colors.white)),
        ),
      ],
    );
  }
}
