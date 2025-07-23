double calculateAnimationValue(
  double viewPortSize,
  double offset, {
  bool reverse = false,
}) {
  if (offset == 0) {
    return 1;
  }
  double cleanedOffset = offset % viewPortSize;
  if (offset != 0 && offset % viewPortSize == 0) {
    return 1.0;
  }
  double animationValue = cleanedOffset / viewPortSize;
  return reverse ? 1 - animationValue : animationValue;
}
