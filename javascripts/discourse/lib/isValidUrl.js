export default function isValidUrl(string) {
  try {
    URL(string);
  } catch (_) {
    return false;
  }

  return true;
}
