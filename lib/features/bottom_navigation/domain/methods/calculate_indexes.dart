(int, int) calculateCurrentAndSelectedIndex(
  double sumOfScreenSizes,
  double offset,
  int screenCounts, {
  bool reverse = false,
}) {
  List<double> screenOffsets = List.generate(
    screenCounts,
    (index) => index * (sumOfScreenSizes / (screenCounts - 1)),
  );
  (int, int)? indexes;
  for (int i = 0; i < screenOffsets.length; i++) {
    if (indexes != null) {
      break;
    }
    if (!reverse) {
      if (offset >= screenOffsets[i] && offset <= screenOffsets[i + 1]) {
        indexes = (i, i + 1);
      }
      if (offset == 0) {
        indexes = (0, 0);
      }
    } else {
      if (offset >= screenOffsets[i] && offset < screenOffsets[i + 1]) {
        indexes = (i + 1, i);
        break;
      }
      if (offset == sumOfScreenSizes) {
        indexes = (screenOffsets.length - 1, screenOffsets.length - 1);
      }
    }
  }
  if (indexes == null) {
    return (0, 0);
  } else {
    return indexes;
  }
}
