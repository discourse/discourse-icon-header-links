export default function isValidUrl(string) {
  try {
    const url = new URL(string);

    if (url) {
      return true;
    }
  } catch (_) {
    return false;
  }

  return true;
}
