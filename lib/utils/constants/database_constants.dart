class DatabaseConstants {
  DatabaseConstants._();

  static const String databaseName = 'post_database.db';
  static const int databaseVersion = 1;

  // Table Name
  static const String postsTable = 'posts';

  // Table Columns name
  static const String id = 'id';
  static const String title = 'title';
  static const String body = 'body';
  static const String userId = "userId";
  static const String isRead = 'isRead';
  static const String remainingTime = 'remainingTime';
}

