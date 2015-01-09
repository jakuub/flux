part of flux_helpers;

ifNull(object, fallback) {
  if (object != null) {
    return object;
  }
  return fallback;
}
