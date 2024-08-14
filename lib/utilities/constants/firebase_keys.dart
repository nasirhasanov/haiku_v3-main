class FirebaseKeys {
  const FirebaseKeys._();

  // Collections
  static const posts = 'posts';
  static const users = 'users';
  static const claps = 'claps';
  static const talks = 'talks';
  static const notifications = 'notifications';

  // Fields
  static const time = 'time';
  static const countryCode = 'country_code';
  static const userId = 'user_id';
  static const postId = 'post_id';

  // Post document fields
  static const postText = 'post_text';
  static const username = 'username';
  static const posterUserId = 'user_id';
  static const clapCount = 'clapCount';
  static const popularity = 'popularity';
  static const postTime = 'time';
  static const talkCount = 'talkCount';
  static const popularityResetTime = 'popularity_reset_time';
  static const latitude = 'latitude';
  static const longitude = 'longitude';

// Talk document fields
  static const commentText = 'comment_text';
  static const posterIdForTalk = 'poster_id';
  static const timestamp = 'timestamp';

// Clap detail fields
  static const clappedPostId = 'clappedPostId';
  static const clapperId = 'clapperId';
  static const clapperName = 'clapperName';
  static const posterId = 'posterId';
  static const score = 'score';

// User Data fields
  static const profilePicPath = 'profile_pic_path';
  static const uid = 'uid';
  static const email = 'email';
  static const bio = 'bio';
  static const deviceToken = 'deviceToken';

// Firebase Storage folder names
  static const profilePicFolder = 'profilePictures/';

// Notification document fields
  static const fromId = 'from_id';
  static const toId = 'to_id';
  static const notificationText = 'notification_text';
  static const notificationType = 'notification_type';
  static const fromUsername = 'from_username';
}
