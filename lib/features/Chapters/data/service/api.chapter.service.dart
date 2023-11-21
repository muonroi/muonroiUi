import 'package:muonroi/core/Authorization/setting.api.dart';
import 'package:muonroi/core/services/api_route.dart';
import 'package:muonroi/features/chapters/data/models/models.chapter.group.dart';
import 'package:muonroi/features/chapters/data/models/models.chapter.list.paging.dart';
import 'package:muonroi/features/chapters/data/models/models.chapter.list.paging.range.dart';
import 'package:muonroi/features/chapters/data/models/models.chapter.single.chapter.dart';
import 'package:muonroi/features/chapters/data/models/models.chapter.list.chapter.dart';
import 'package:muonroi/features/chapters/data/models/models.chapter.preview.chapter.dart';
import 'package:muonroi/features/chapters/settings/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprintf/sprintf.dart';

class ChapterService {
  Future<ChapterPreviewModel> getChaptersDataList(int storyId, int pageIndex,
      {bool isLatest = false}) async {
    try {
      var baseEndpoint = await endPoint();
      final response = await baseEndpoint.get(sprintf(
          ApiNetwork.getChapterPaging,
          ["$storyId", "$pageIndex", "100", "$isLatest"]));
      if (response.statusCode == 200) {
        return chapterPreviewModelFromJson(response.data.toString(), pageIndex);
      } else {
        throw Exception("Failed to load chapter");
      }
    } catch (e) {
      throw Exception("Failed to load chapter");
    }
  }

  Future<ListPagingChapters> getGroupChaptersDataDetail(int storyId) async {
    try {
      var baseEndpoint = await endPoint();

      final response = await baseEndpoint
          .get(sprintf(ApiNetwork.getListChapterPaging, ["$storyId"]));
      if (response.statusCode == 200) {
        return listPagingChaptersFromJson(response.data.toString());
      } else {
        throw Exception("Failed to load chapter");
      }
    } catch (e) {
      throw Exception("Failed to load chapter");
    }
  }

  Future<DetailChapterInfo> getChapterDataDetail(int fromChapterId) async {
    try {
      var baseEndpoint = await endPoint();
      final response = await baseEndpoint
          .get(sprintf(ApiNetwork.getChapterDetail, ["$fromChapterId"]));
      if (response.statusCode == 200) {
        var result = detailChapterInfoFromJson(response.data.toString());
        var items = result.result;
        items.body = decryptStringAES(items.body);
        items.bodyChunk = decryptChunkBody(items.bodyChunk, items.chunkSize);
        result.result = items;
        return result;
      } else {
        throw Exception("Failed to load detail chapter");
      }
    } catch (e) {
      throw Exception("Failed to load detail chapter");
    }
  }

  Future<DetailChapterInfo> fetchActionChapterOfStory(
      int chapterId, int storyId, bool action) async {
    try {
      var baseEndpoint = await endPoint();

      var stringEndpointName = action ? "Next" : "Previous";
      final response = await baseEndpoint.get(sprintf(
          ApiNetwork.getActionChapterDetail,
          [stringEndpointName, "$storyId", "$chapterId"]));
      if (response.statusCode == 200) {
        var result = detailChapterInfoFromJson(response.data.toString());
        var items = result.result;
        items.body = decryptStringAES(items.body);
        items.bodyChunk = decryptChunkBody(items.bodyChunk, items.chunkSize);
        result.result = items;
        return result;
      } else {
        throw Exception("Failed to load detail chapter");
      }
    } catch (e) {
      throw Exception("Failed to load detail chapter");
    }
  }

  Future<ChapterInfo> fetchLatestChapterAnyStory(
      {int pageIndex = 1, int pageSize = 5}) async {
    try {
      var baseEndpoint = await endPoint();
      final response = await baseEndpoint.get(
          sprintf(ApiNetwork.getLatestChapterNumber, [pageIndex, pageSize]));
      if (response.statusCode == 200) {
        return chapterInfoFromJson(response.data.toString());
      } else {
        throw Exception("Failed to load list chapter");
      }
    } catch (e) {
      throw Exception("Failed to load list chapter");
    }
  }

  Future<ListPagingRangeChapters> getFromToChaptersDataDetail(
      int storyId, int pageIndex, int from, int to) async {
    try {
      var baseEndpoint = await endPoint();
      final response = await baseEndpoint.get(sprintf(
          ApiNetwork.getFromToChapterPaging,
          ["$storyId", "$pageIndex", "$from", "$to"]));
      if (response.statusCode == 200) {
        return listPagingRangeChaptersFromJson(response.data.toString());
      } else {
        throw Exception("Failed to load chapter");
      }
    } catch (e) {
      throw Exception("Failed to load chapter");
    }
  }

  Future<GroupChapters> getGroupChapters(int storyId, int pageIndex,
      {int pageSize = 100}) async {
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      var chaptersOfficeByIndex = sharedPreferences
          .getString("story-$storyId-current-group-chapter-$pageIndex");
      var baseEndpoint = await endPoint();
      if (chaptersOfficeByIndex == null) {
        final response = await baseEndpoint.get(sprintf(
            ApiNetwork.getGroupChapters,
            ["$storyId", "$pageIndex", "$pageSize"]));
        if (response.statusCode == 200) {
          var result = groupChaptersFromJson(response.data.toString());
          var items = result.result.items;
          result.result.items = decryptBodyChapterAndChunk(items);
          sharedPreferences.setString(
              "story-$storyId-current-group-chapter-$pageIndex",
              groupChaptersToJson(result));
          return result;
        } else {
          throw Exception("Failed to load chapter");
        }
      }
      return groupChaptersFromJson(chaptersOfficeByIndex);
    } catch (e) {
      throw Exception("Failed to load chapter");
    }
  }
}

List<String> decryptChunkBody(dynamic items, int size) {
  List<String> chunkBody = [];
  items = convertDynamicToList(items);
  for (int i = 0; i < size; i++) {
    var chunkTemp = convertDynamicToList(items)[i];
    chunkTemp = decryptStringAES(chunkTemp);
    chunkBody.add(chunkTemp);
  }
  return chunkBody;
}

List<GroupChapterItems> decryptBodyChapterAndChunk(
    List<GroupChapterItems> items) {
  for (int i = 0; i < items.length; i++) {
    var tempChunk = [];
    for (int j = 0; j < items[i].chunkSize; j++) {
      var chunkContent =
          decryptStringAES(convertDynamicToList(items[i].bodyChunk)[j]);
      tempChunk.add(chunkContent);
    }
    items[i].bodyChunk = tempChunk;
    items[i].body = decryptStringAES(items[i].body);
  }
  return items;
}

List<String> convertDynamicToList(dynamic dynamicObject) {
  if (dynamicObject is Iterable) {
    List<String> stringList = [];
    for (var item in dynamicObject) {
      stringList.add(item.toString());
    }

    return stringList;
  } else {
    throw ArgumentError("Dynamic object is not iterable.");
  }
}
