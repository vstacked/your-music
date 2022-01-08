import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/colors.dart';
import '../../../models/song_model.dart';
import '../../../providers/song_provider.dart';
import '../../../utils/device/device_layout.dart';
import 'song.dart';

class Favorite extends StatelessWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'FAVORITE',
          style: textTheme.subtitle1!.copyWith(color: greyColor, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          iconSize: 20,
          alignment: Alignment.center,
          color: greyColor,
          splashRadius: 25,
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: context.read<SongProvider>().fetchSongs(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final song = snapshot.data!.docs
                .map((e) => SongModel.fromJson(Map.from(e.data() as LinkedHashMap)..remove('created_at'))..id = e.id)
                .toList();

            final favorite = context.read<SongProvider>().favorite.map((e) {
              final x = song.where((element) => element.id == e.id);
              return x.isNotEmpty
                  ? x.first
                  : SongModel(
                      id: e.id,
                      thumbnailUrl: e.thumbnail,
                      title: e.title,
                      singer: e.singer,
                      fileDetail: FileDetail(duration: e.duration),
                    );
            }).toList();

            if (isTablet(context)) {
              return GridView.builder(
                itemBuilder: (_, i) => Song(
                  isCard: true,
                  song: favorite[i],
                  isDisable: song.where((element) => element.id == favorite[i].id).isEmpty,
                ),
                itemCount: favorite.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                ),
              );
            } else {
              return ListView.builder(
                itemCount: favorite.length,
                itemBuilder: (_, i) => Song(
                  song: favorite[i],
                  isDisable: song.where((element) => element.id == favorite[i].id).isEmpty,
                ),
              );
            }
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something Went Wrong..',
                style: Theme.of(context).textTheme.subtitle1!.copyWith(color: greyColor),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
