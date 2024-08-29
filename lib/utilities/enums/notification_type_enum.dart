enum NotificationType {
  postClapped('post_clapped'),
  talkClapped('talk_clapped'),
  newTalk('new_talk');

  final String name;

  const NotificationType(this.name);
}

extension NotificationTypeExtension on NotificationType {
  String get name {
    switch (this) {
      case NotificationType.postClapped:
        return 'post_clapped';
      case NotificationType.talkClapped:
        return 'talk_clapped';
      case NotificationType.newTalk:
        return 'new_talk';
    }
  }
}

NotificationType fromName(String? name) {
  return NotificationType.values.firstWhere(
    (type) => type.name == name,
  );
}
