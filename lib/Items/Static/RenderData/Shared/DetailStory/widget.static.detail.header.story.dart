import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:muonroi/Models/Stories/models.stories.story.dart';
import 'package:muonroi/Settings/settings.colors.dart';
import 'package:muonroi/Settings/settings.fonts.dart';
import 'package:muonroi/Settings/settings.language_code.vi..dart';
import 'package:muonroi/Settings/settings.main.dart';

class Header extends StatelessWidget {
  final StoryItems widget;
  const Header({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              SizedBox(
                width:
                    MainSetting.getPercentageOfDevice(context, expectWidth: 115)
                        .width,
                height: MainSetting.getPercentageOfDevice(context,
                        expectHeight: 176)
                    .height,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: widget.imgUrl,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              RatingBar.builder(
                itemSize:
                    MainSetting.getPercentageOfDevice(context, expectWidth: 25)
                            .width ??
                        25,
                initialRating: widget.rating * 1.0,
                minRating: 0.5,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {},
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12.0),
            height:
                MainSetting.getPercentageOfDevice(context, expectHeight: 176)
                    .height,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MainSetting.getPercentageOfDevice(context,
                            expectWidth: 210)
                        .width,
                    child: Text(
                      widget.storyTitle,
                      style: FontsDefault.h4.copyWith(fontSize: 20),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(
                    child: Text(
                      widget.authorName,
                      style: FontsDefault.h5.copyWith(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                          color: ColorDefaults.mainColor),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(
                    width: MainSetting.getPercentageOfDevice(context,
                            expectWidth: 200)
                        .width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                              color: ColorDefaults.secondMainColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            widget.nameCategory,
                            style: FontsDefault.h5
                                .copyWith(fontWeight: FontWeight.w400),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                              color: ColorDefaults.secondMainColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            widget.nameCategory,
                            style: FontsDefault.h5
                                .copyWith(fontWeight: FontWeight.w400),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: widget.nameTag
                          .map((e) => e.toString())
                          .map((String item) {
                        return Text(item);
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          child: RichText(
                            text: TextSpan(
                                text: L(ViCode.voteStoryTextInfo.toString()),
                                children: [
                                  TextSpan(
                                      text: ' ${widget.rating}/5 ',
                                      style: FontsDefault.h6.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: ColorDefaults.mainColor)),
                                  TextSpan(
                                      text: L(ViCode.voteStoryTotalTextInfo
                                          .toString()),
                                      style: FontsDefault.h6.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15)),
                                  TextSpan(
                                      text:
                                          '  ${widget.totalFavorite} ${L(ViCode.voteStoryTextInfo.toString()).replaceRange(0, 1, L(ViCode.voteStoryTextInfo.toString())[0].toLowerCase())}',
                                      style: FontsDefault.h6.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: ColorDefaults.mainColor))
                                ],
                                style: FontsDefault.h6.copyWith(fontSize: 15)),
                          ),
                        )
                      ],
                    ),
                  )
                ]),
          )
        ],
      ),
    );
  }
}