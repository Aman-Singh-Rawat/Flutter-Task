class PostModel {
  final int? id;
  final int? userId;
  final String? title;
  final String? body;
  final bool isRead;
  final int remainingTime;

  PostModel({
    this.id,
    this.userId,
    this.title,
    this.body,
    this.isRead = false,
    this.remainingTime = 0,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      title: json['title'] as String?,
      body: json['body'] as String?,
      isRead: false,
      remainingTime: 0, 
    );
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] as int?,
      userId: map['userId'] as int?,
      title: map['title'] as String?,
      body: map['body'] as String?,
      isRead: (map['isRead'] as int) == 1,
      remainingTime: map['remainingTime'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
      'isRead': isRead ? 1 : 0,
      'remainingTime': remainingTime,
    };
  }

  PostModel copyWith({
    int? id,
    int? userId,
    String? title,
    String? body,
    bool? isRead,
    int? remainingTime,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      isRead: isRead ?? this.isRead,
      remainingTime: remainingTime ?? this.remainingTime,
    );
  }

  @override
  String toString() {
    return 'PostModel(id: $id, userId: $userId, title: $title, body: $body, isRead: $isRead, remainingTime: $remainingTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PostModel &&
        other.id == id &&
        other.userId == userId &&
        other.title == title &&
        other.body == body &&
        other.isRead == isRead &&
        other.remainingTime == remainingTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        title.hashCode ^
        body.hashCode ^
        isRead.hashCode ^
        remainingTime.hashCode;
  }
}

