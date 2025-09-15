import curryComponent from "ember-curry-component";
import { getOwnerWithFallback } from "discourse/lib/get-owner";
import { withPluginApi } from "discourse/lib/plugin-api";
import CustomHeaderIcon from "../components/custom-header-icon";

const BEFORE_ICONS = ["chat", "search", "hamburger", "user-menu"];

export default {
  name: "header-icon-links",
  initialize() {
    withPluginApi((api) => {
      try {
        const links = settings.header_links || [];

        links.forEach((link) => {
          api.headerIcons.add(
            link.title,
            curryComponent(
              CustomHeaderIcon,
              { link, links },
              getOwnerWithFallback()
            ),
            {
              before: BEFORE_ICONS,
            }
          );
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
