export default function isValidUrl(string) {
  try {
    const url = new URL(string);

    if (url) {
      return true;
    }
  } catch {
    return false;
  }

  return true;
}
