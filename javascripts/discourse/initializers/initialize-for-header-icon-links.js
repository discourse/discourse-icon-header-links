import {withPluginApi} from "discourse/lib/plugin-api";
import {iconNode} from "discourse-common/lib/icon-library";
import {dasherize} from "@ember/string";

function parseIcon(icon) {
  const result = icon.match(/\[(.+)]/);
  if (result && result[1]) {
    const icons = result[1].split(" ").map(it => it.trim());
    return icons[Math.floor(Math.random() * icons.length)];
  }
  return icon;
}

export default {
  name: "header-icon-links",
  initialize() {
    withPluginApi("0.8.41", (api) => {
      try {
        const splitLinks = settings.Header_links.split("|").filter(Boolean);

        splitLinks.forEach((link, index, links) => {
          const fragments = link.split(",").map((fragment) => fragment.trim());
          const title = fragments[0];
          const icon = iconNode(parseIcon(fragments[1].toLowerCase()));
          const href = fragments[2];
          const className = `header-icon-${dasherize(fragments[0])}`;
          const viewClass = fragments[3].toLowerCase();
          const target = fragments[4].toLowerCase() === "blank" ? "_blank" : "";
          const rel = target ? "noopener" : "";
          const isLastLink =
            link === links[links.length - 1] ? ".last-custom-icon" : "";
          const selector = `li.custom-header-icon-link.${className}.${viewClass}${isLastLink}`;

          api.decorateWidget("header-icons:before", (helper) => {
            return helper.h(selector, [
              helper.h(
                "a.icon.btn-flat",
                {
                  href,
                  title,
                  target,
                  attributes: {
                    rel,
                  },
                },
                icon
              ),
            ]);
          });
        });
      } catch (error) {
        console.error(error);
        console.error(
          "There's an issue in the header icon links component. Check if your settings are entered correctly"
        );
      }
    });
  },
};
