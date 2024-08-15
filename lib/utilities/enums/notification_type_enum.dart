enum NotificationType {
  postClapped,
}



NotificationType? toType(String? type) {
  final Map<String, NotificationType> typeMap = {
    'post_clapped': NotificationType.postClapped,
    // Add more mappings as needed
  };
  return typeMap[type];
}