import { dasherize } from "@ember/string";
import { withPluginApi } from "discourse/lib/plugin-api";
import icon from "discourse-common/helpers/d-icon";
import isValidUrl from "../lib/isValidUrl";

function buildIcon(iconNameOrImageUrl, title) {
  if (isValidUrl(iconNameOrImageUrl)) {
    return <template>
      <img src={{iconNameOrImageUrl}} aria-hidden="true" />
      <span class="sr-only">{{title}}</span>
    </template>;
  } else {
    return <template>{{icon iconNameOrImageUrl label=title}}</template>;
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
          const iconTemplate = buildIcon(fragments[1], title);
          const href = fragments[2];
          const className = `header-icon-${dasherize(fragments[0])}`;
          const viewClass = fragments[3].toLowerCase();
          const target = fragments[4].toLowerCase() === "blank" ? "_blank" : "";
          const rel = target ? "noopener" : "";
          const isLastLink =
            link === links[links.length - 1] ? "last-custom-icon" : "";

          const iconComponent = <template>
            <li
              class="custom-header-icon-link
                {{className}}
                {{viewClass}}
                {{isLastLink}}"
            >
              <a
                class="btn no-text icon btn-flat"
                href={{href}}
                title={{title}}
                target={{target}}
                rel={{rel}}
              >
                {{iconTemplate}}
              </a>
            </li>
          </template>;

          const beforeIcon = ["chat", "search", "hamburger", "user-menu"];

          api.headerIcons.add(title, iconComponent, { before: beforeIcon });
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
