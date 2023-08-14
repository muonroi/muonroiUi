import 'package:flutter/cupertino.dart';
import 'package:muonroi/Models/Stories/models.stories.story.dart';
import 'package:muonroi/Settings/settings.fonts.dart';
import 'package:muonroi/Settings/settings.language_code.vi..dart';
import 'package:muonroi/Settings/settings.main.dart';

class InfoDetailStory extends StatelessWidget {
  final double value;
  final String text;
  const InfoDetailStory({super.key, required this.text, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 32.0),
      child: Row(
        children: [
          SizedBox(
            child: Column(children: [
              SizedBox(
                child: Text(
                  formatNumberThouSand(value),
                  style: FontsDefault.h4,
                ),
              ),
              SizedBox(
                child: Text(
                  text,
                  style: FontsDefault.h5.copyWith(fontWeight: FontWeight.w300),
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}

class MoreInfoStory extends StatelessWidget {
  final StoryItems widget;
  const MoreInfoStory({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InfoDetailStory(
            value: widget.totalChapters * 1.0,
            text: L(ViCode.chapterNumberTextInfo.toString())),
        Text(
          '|',
          style: FontsDefault.h4.copyWith(fontWeight: FontWeight.w300),
        ),
        InfoDetailStory(
          value: widget.totalView * 1.0,
          text: L(ViCode.totalViewStoryTextInfo.toString()),
        ),
        Text(
          '|',
          style: FontsDefault.h4.copyWith(fontWeight: FontWeight.w300),
        ),
        InfoDetailStory(
          value: double.parse(widget.totalFavorite.toString()),
          text: L(ViCode.totalFavoriteStoryTextInfo.toString()),
        ),
      ],
    );
  }
}