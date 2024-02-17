extension ListExtensions on List {
  int get paginatedLength => isNotEmpty
      ? (length < 10 ? length : length + 1)
      : 0;
}
