import Component from "@glimmer/component";
import { dasherize } from "@ember/string";
import { htmlSafe } from "@ember/template";
import concatClass from "discourse/helpers/concat-class";
import icon from "discourse/helpers/d-icon";
import { withPluginApi } from "discourse/lib/plugin-api";
import { escapeExpression } from "discourse/lib/utilities";
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
    withPluginApi((api) => {
      try {
        let links = settings.header_links;

        links.forEach((link, index) => {
          const iconTemplate = buildIcon(link.icon, link.title);
          const className = `header-icon-${dasherize(link.title)}`;
          const target = link.target === "blank" ? "_blank" : "";
          const rel = link.target ? "noopener" : "";
          const isLastLink =
            index === links.length - 1 ? "last-custom-icon" : "";

          let style;
          if (link.width && !isNaN(link.width)) {
            style = htmlSafe(`width: ${escapeExpression(link.width)}px`);
          }

          const iconComponent = class extends Component {
            static shouldRender(args, context) {
              if (context.site.mobileView) {
                return link.view === "vmo" || link.view === "vdm";
              } else {
                return link.view === "vdo" || link.view === "vdm";
              }
            }

            <template>
              <li
                class={{concatClass
                  "custom-header-icon-link"
                  className
                  link.view
                  isLastLink
                }}
              >
                <a
                  class="btn no-text icon btn-flat"
                  href={{link.url}}
                  title={{link.title}}
                  target={{target}}
                  rel={{rel}}
                  style={{style}}
                >
                  {{iconTemplate}}
                </a>
              </li>
            </template>
          };

          const beforeIcon = ["chat", "search", "hamburger", "user-menu"];

          api.headerIcons.add(link.title, iconComponent, {
            before: beforeIcon,
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
