import { withPluginApi } from "discourse/lib/plugin-api";
import { iconNode } from "discourse-common/lib/icon-library";
import { dasherize } from "@ember/string";
import isValidUrl from "../lib/isValidUrl";
import { h } from "virtual-dom";

function buildIcon(icon) {
  if (isValidUrl(icon)) {
    return h(
      "img",
      {
        attributes: {
          src: icon,
        },
      },
      ""
    );
  } else {
    return iconNode(icon.toLowerCase());
  }
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
          const icon = buildIcon(fragments[1]);
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
        // eslint-disable-next-line no-console
        console.error(
          error,
          "There's an issue in the header icon links component. Check if your settings are entered correctly"
        );
      }
    });
  },
};
