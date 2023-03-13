import 'dart:convert';

PostModel postModelFromJson(String str) => PostModel.fromJson(json.decode(str));

class PostModel {
  PostModel({
    required this.kind,
    required this.data,
  });

  String kind;
  PostModelData data;

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        kind: json["kind"],
        data: PostModelData.fromJson(json["data"]),
      );
}

class PostModelData {
  PostModelData({
    required this.after,
    required this.dist,
    required this.modhash,
    this.geoFilter,
    required this.children,
    this.before,
  });

  String after;
  int dist;
  String modhash;
  dynamic geoFilter;
  List<Child> children;
  dynamic before;

  factory PostModelData.fromJson(Map<String, dynamic> json) => PostModelData(
        after: json["after"],
        dist: json["dist"],
        modhash: json["modhash"],
        geoFilter: json["geo_filter"],
        children:
            List<Child>.from(json["children"].map((x) => Child.fromJson(x))),
        before: json["before"],
      );
}

class Child {
  Child({
    required this.kind,
    required this.data,
  });

  Kind kind;
  ChildData data;

  factory Child.fromJson(Map<String, dynamic> json) => Child(
        kind: kindValues.map[json["kind"]]!,
        data: ChildData.fromJson(json["data"]),
      );
}

class ChildData {
  ChildData({
    required this.selftext,
    required this.authorFullname,
    required this.title,
    required this.name,
    required this.score,
    required this.thumbnail,
    this.likes,
    this.viewCount,
    required this.over18,
    required this.id,
    required this.author,
    required this.numComments,
    required this.url,
    required this.subredditSubscribers,
    required this.createdUtc,
    required this.numCrossposts,
  });

  String selftext;
  String authorFullname;
  String title;
  String name;
  dynamic score;
  String thumbnail;
  dynamic likes;
  dynamic viewCount;
  bool over18;
  String id;
  String author;
  dynamic numComments;
  String url;
  dynamic subredditSubscribers;
  dynamic createdUtc;
  dynamic numCrossposts;

  factory ChildData.fromJson(Map<String, dynamic> json) => ChildData(
        selftext: json["selftext"],
        authorFullname: json["author_fullname"],
        title: json["title"],
        name: json["name"],
        score: json["score"],
        thumbnail: json["thumbnail"],
        likes: json["likes"],
        viewCount: json["view_count"],
        over18: json["over_18"],
        id: json["id"],
        author: json["author"],
        numComments: json["num_comments"],
        url: json["url"],
        subredditSubscribers: json["subreddit_subscribers"],
        createdUtc: json["created_utc"],
        numCrossposts: json["num_crossposts"],
      );
}

enum Kind { T3 }

final kindValues = EnumValues({"t3": Kind.T3});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
