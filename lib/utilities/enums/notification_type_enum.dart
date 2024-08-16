enum NotificationType {
  postClapped,
}

extension NotificationTypeExtension on NotificationType {
  String get name {
    switch (this) {
      case NotificationType.postClapped:
        return 'post_clapped';
      // Add more cases as needed
    }
  }
}

NotificationType fromName(String? name) {
  return NotificationType.values.firstWhere(
    (type) => type.name == name,
  );
}