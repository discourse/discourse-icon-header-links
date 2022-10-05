export default function isValidUrl(string) {
  let url;

  try {
    url = new URL(string);

    if (url) {
      return true;
    }
  } catch (_) {
    return false;
  }

  return true;
}
