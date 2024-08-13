import {
  withPluginApi
} from "discourse/lib/plugin-api";
import {
  iconNode
} from "discourse-common/lib/icon-library";
import {
  dasherize
} from "@ember/string";

export default {
  name: "target-specific-header-icon-links",
  initialize() {
    withPluginApi("0.8.41", (api) => {

      const render = (Header_links) => {
        try {
          const splitLinks = Header_links.split("|").filter(Boolean);

          splitLinks.forEach((link, index, links) => {
            const fragments = link.split(",").map((fragment) => fragment.trim());
            const title = fragments[0];
            const icon = iconNode(fragments[1].toLowerCase());
            const href = fragments[2];
            const className = `header-icon-${dasherize(fragments[0])}`;
            const viewClass = fragments[3].toLowerCase();
            const target = fragments[4].toLowerCase() === "blank" ? "_blank" : "";
            const rel = target ? "noopener" : "";
            const isLastLink =
              link === links[links.length - 1] ? ".last-custom-icon" : "";
            const selector = `li.custom-header-icon-link.${className}.${viewClass}${isLastLink}`;

            api.headerIcons.add(title, () => {
              return helper.h(
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
              );
            }, { before: "search" });
            

            // api.decorateWidget("header-icons:before", (helper) => {
            //   return helper.h(selector, [
            //     helper.h(
            //       "a.icon.btn-flat", {
            //         href,
            //         title,
            //         target,
            //         attributes: {
            //           rel,
            //         },
            //       },
            //       icon
            //     ),
            //   ]);
            // });
          });
        } catch (error) {
          console.error(error);
          console.error(
            "There's an issue in the header icon links component. Check if your settings are entered correctly"
          );
        }
      }

      const checkGroup = (groups) => {
        const userGroup = currentUser.groups.map(u => u.name);

        const found = groups.split('|').some(r => userGroup.indexOf(r) >= 0)

        return found
      }

      const currentUser = api.getCurrentUser();

      if (currentUser == null) {
        render(settings.Header_links_for_not_login_user)
        return;
      }

      if (settings.group_set_1) {
        if (checkGroup(settings.group_set_1)) {
          render(settings.Header_links_set_1)
          return;

        }
      }

      if (settings.group_set_2) {
        if (checkGroup(settings.group_set_2)) {
          render(settings.Header_links_set_2)
          return;
        }
      }

      if (settings.exclude_group) {
        if (!checkGroup(settings.exclude_group)) {
          render(settings.Header_links_for_other_group)
          return
        }
      }

    });
  },
};