import 'dart:convert';

List<ListShow> parseList(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<ListShow>((object) => ListShow.fromJson(object)).toList();
}

class ListShow {
  final String score;
  final Show show;

  ListShow({this.score, this.show});

  factory ListShow.fromJson(Map<String, dynamic> object) {
    return ListShow(
      score: object['score'].toString(),
      show: Show.fromJson(object['show']),
    );
  }
}

class Show {
  final String name, id, premiered;
  final List<String> genre;
  //String medium;
  final ShowImage image;

  Show({this.id, this.name, this.premiered, this.image, this.genre});

  factory Show.fromJson(Map<String, dynamic> object) {
    print(object['name']);
    return Show(
      id: object['id'].toString(),
      name: object['name'] == null ? "" : object['name'] as String,
      premiered:
          object['premiered'] == null ? "" : object['premiered'] as String,
      image: ShowImage?.fromJson(object['image'] ??= object['rating']),
      genre: List<String>.from(object['genres']),
    );
  }
}

class ShowImage {
  final String medium;
  final String original;

  ShowImage({this.medium, this.original});

  factory ShowImage.fromJson(Map<String, dynamic> object) {
    print(object['medium']);
    return ShowImage(
      medium: object['medium'] == null ? "" : object['medium'],
      original: object['original'] == null ? "" : object['original'],
    );
  }
}