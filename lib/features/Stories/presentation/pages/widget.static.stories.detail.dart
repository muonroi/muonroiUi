import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muonroi/features/stories/data/models/models.single.story.dart';
import 'package:muonroi/features/stories/data/repositories/story_repository.dart';
import 'package:muonroi/features/stories/presentation/pages/widget.static.stories.download.dart';
import 'package:muonroi/features/stories/presentation/widgets/widget.static.detail.more.info.story.dart';
import 'package:muonroi/features/stories/presentation/widgets/widget.static.detail.similar.story.dart';
import 'package:muonroi/shared/settings/enums/theme/enum.code.color.theme.dart';
import 'package:muonroi/shared/static/buttons/widget.static.button.dart';
import 'package:muonroi/features/chapters/presentation/pages/widget.static.model.chapter.dart';
import 'package:muonroi/shared/settings/settings.fonts.dart';
import 'package:muonroi/core/localization/settings.language.code.dart';
import 'package:muonroi/shared/settings/settings.main.dart';
import 'package:muonroi/features/stories/bloc/DetailData/detail_bloc.dart';
import 'package:muonroi/features/stories/presentation/widgets/widget.static..detail.chapter.story.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/widget.static.detail.header.story.dart';
import '../widgets/widget.static.detail.intro.notify.story.dart';

class StoryDetail extends StatefulWidget {
  final int storyId;
  final String storyTitle;
  const StoryDetail({
    Key? key,
    required this.storyId,
    required this.storyTitle,
  }) : super(key: key);
  @override
  State<StoryDetail> createState() => _StoryDetailState();
}

class _StoryDetailState extends State<StoryDetail> {
  @override
  void initState() {
    _detailStory = DetailStoryPageBloc(widget.storyId);
    _detailStory.add(GetDetailStory());
    _isFirstLoad = true;
    _initSharedPreferences();
    super.initState();
  }

  @override
  void dispose() {
    _detailStory.close();
    _isFirstLoad = true;
    super.dispose();
  }

  Future<void> getChapterId() async {
    final SharedPreferences chapterTemp = await SharedPreferences.getInstance();
    setState(() {
      _chapterId =
          (chapterTemp.getInt("story-${widget.storyId}-current-chapter-id") ??
              0);
      _chapterNumber =
          (chapterTemp.getInt("story-${widget.storyId}-current-chapter") ?? 0);
    });
  }

  Future<void> _initSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  late DetailStoryPageBloc _detailStory;
  late SharedPreferences _sharedPreferences;
  late int _chapterId = 0;
  late int _chapterNumber = 0;
  late StoryRepository _storyRepository = StoryRepository();
  late bool _isFirstLoad = true;
  late Color? _colorBookmark;
  @override
  Widget build(BuildContext context) {
    getChapterId();
    // #region not use now
    // List<Widget> componentOfDetailStory = [
    //   Header(infoStory: widget.storyInfo),
    //   MoreInfoStory(infoStory: widget.storyInfo),
    //   IntroAndNotificationStory(
    //     name:L(context,ViCode.introStoryTextInfo.toString()),
    //     value: widget.storyInfo.storySynopsis,
    //   ),
    //   // IntroAndNotificationStory(
    //   //   name:L(context,ViCode.notifyStoryTextInfo.toString()),
    //   //   value: "", //widget.storyInfo.notification ?? "",
    //   // ),
    //   ChapterOfStory(
    //     callback: (val) {
    //       WidgetsBinding.instance.addPostFrameCallback((_) {
    //         setState(() {
    //           latestChapter = double.parse(val);
    //         });
    //       });
    //     },
    //     storyId: widget.storyInfo.id,
    //   ),
    //   // CommentOfStory(
    //   //   widget: widget.storyInfo,
    //   // ),
    //   // RechargeStory(
    //   //   widget: widget.storyInfo,
    //   // ),
    //   SimilarStories(
    //     infoStory: widget.storyInfo,
    //   )
    // ];
    // #endregion
    return BlocProvider(
      create: (context) => _detailStory,
      child: BlocListener<DetailStoryPageBloc, DetailStoryState>(
        listener: (context, state) {
          const Center(child: CircularProgressIndicator());
        },
        child: BlocBuilder<DetailStoryPageBloc, DetailStoryState>(
          builder: (context, state) {
            if (state is DetailStoryLoadedState) {
              var storyInfo = state.story.result;
              late bool _isBookmarkColor = storyInfo.isBookmark;
              _sharedPreferences.setString(
                  "recently-story", singleStoryModelToJson(state.story));
              _sharedPreferences.setInt("recently-chapterId", _chapterId);
              if (_isFirstLoad && _isBookmarkColor) {
                _colorBookmark = themMode(context, ColorCode.mainColor.name);
              } else if (!_isFirstLoad) {
                _colorBookmark = themMode(context, ColorCode.mainColor.name);
              } else {
                _colorBookmark = null;
              }
              return Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: themMode(context, ColorCode.modeColor.name),
                  leading: BackButton(
                    color: themMode(context, ColorCode.textColor.name),
                  ),
                ),
                backgroundColor: themMode(context, ColorCode.modeColor.name),
                body: SizedBox(
                    child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Header(infoStory: storyInfo),
                            MoreInfoStory(infoStory: storyInfo),
                            IntroAndNotificationStory(
                              name: L(context,
                                  LanguageCodes.introStoryTextInfo.toString()),
                              value: storyInfo.storySynopsis,
                            ),
                            ChapterOfStory(
                              storyId: storyInfo.id,
                              storyInfo: storyInfo,
                            ),
                            SimilarStories(infoStory: storyInfo)
                          ],
                        ));
                  },
                )),
                bottomNavigationBar: BottomAppBar(
                  color: themMode(context, ColorCode.modeColor.name),
                  child: SizedBox(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MainSetting.getPercentageOfDevice(context,
                                expectWidth: 200)
                            .width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                                child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.headphones_outlined,
                                      color: themMode(
                                          context, ColorCode.textColor.name),
                                    ))),
                            SizedBox(
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                StoriesDownloadPage(
                                                  storyName:
                                                      storyInfo.storyTitle,
                                                  storyId: storyInfo.id,
                                                  totalChapter:
                                                      storyInfo.totalChapter,
                                                )));
                                  },
                                  icon: Icon(
                                    Icons.download_outlined,
                                    color: themMode(
                                        context, ColorCode.textColor.name),
                                  )),
                            ),
                            SizedBox(
                              child: IconButton(
                                  onPressed: () async {
                                    final bool isBookmarked =
                                        await _storyRepository
                                            .bookmarkStory(storyInfo.id);
                                    setState(() {
                                      _colorBookmark = isBookmarked
                                          ? themMode(
                                              context, ColorCode.mainColor.name)
                                          : null;
                                      _isFirstLoad = false;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.bookmark_add_outlined,
                                    color: _colorBookmark ??
                                        themMode(
                                            context, ColorCode.textColor.name),
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: SizedBox(
                          width: MainSetting.getPercentageOfDevice(context,
                                  expectWidth: 150)
                              .width,
                          child: ButtonWidget.buttonNavigatorNextPreviewLanding(
                              context,
                              Chapter(
                                isLoadHistory: true,
                                storyId: widget.storyId,
                                storyName: widget.storyTitle,
                                chapterId: _chapterId == 0
                                    ? storyInfo.firstChapterId
                                    : _chapterId,
                                lastChapterId: storyInfo.lastChapterId,
                                firstChapterId: storyInfo.firstChapterId,
                              ),
                              textStyle: CustomFonts.h5(context).copyWith(
                                  color: themMode(
                                      context, ColorCode.textColor.name),
                                  fontWeight: FontWeight.w500),
                              color:
                                  themMode(context, ColorCode.mainColor.name),
                              borderColor:
                                  themMode(context, ColorCode.mainColor.name),
                              widthBorder: 2,
                              textDisplay:
                                  '${L(context, LanguageCodes.chapterNumberTextInfo.toString())} ${_chapterNumber == 0 ? 1 : _chapterNumber}'),
                        ),
                      )
                    ],
                  )),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
