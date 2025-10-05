class PostData {
  final int? userId;
  final int? id;
  final String? title;
  final String? body;

  PostData({this.userId, this.id, this.title, this.body});

  factory PostData.fromJson(Map<String, dynamic> json) {
    return PostData(
      userId: json['userId'] as int?,
      id: json['id'] as int?,
      title: json['title'] as String?,
      body: json['body'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'userId': userId, 'id': id, 'title': title, 'body': body};
  }
}
