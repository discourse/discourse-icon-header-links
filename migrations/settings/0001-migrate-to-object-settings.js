export default function migrate(settings) {
  const oldSetting = settings.get("Header_links");

  if (!oldSetting) {
    return settings;
  }

  const newSetting = oldSetting.split("|").map((link) => {
    const [title, icon, url, view, target] = link
      .split(",")
      .map((s) => s.trim());

    const newLink = {
      title,
      icon,
      url,
      view,
      target,
    };

    Object.keys(newLink).forEach((key) => {
      if (newLink[key] === undefined) {
        delete newLink[key];
      }
    });

    return newLink;
  });

  settings.set("Header_links", newSetting);
  return settings;
}
