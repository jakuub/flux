part of helpers;

ifNull(object, fallback) {
  if (object != null) {
    return object;
  }
  return fallback;
}