import { module, test } from "qunit";
import migrate from "../../../../migrations/settings/0002-migrate-from-deprecated-icon-names";

module(
  "Unit | Migrations | Settings | 0002-migrate-from-deprecated-icon-names",
  function () {
    test("migrate", function (assert) {
      const settings = new Map(
        Object.entries({
          header_links: [
            {
              icon: "fab-facebook",
              title: "Desktop and mobile link",
              url: "https://facebook.com",
              view: "vdm",
              target: "blank",
            },
            {
              icon: "fab-twitter",
              title: "Mobile-only link",
              url: "https://twitter.com",
              view: "vmo",
              target: "blank",
            },
            {
              icon: "fab fa-cog",
              title: "More settings",
              url: "https://example.com",
              view: "vmo",
              target: "blank",
            },
            {
              icon: "user-friends",
              title: "Groups",
              url: "https://example.com",
              view: "vmo",
              target: "blank",
            },
          ],
          Svg_icons: "fab-facebook|fab-twitter|fab fa-cog|user-friends",
        })
      );

      const result = migrate(settings);

      const expectedResult = new Map(
        Object.entries({
          header_links: [
            {
              icon: "fab-facebook",
              title: "Desktop and mobile link",
              url: "https://facebook.com",
              view: "vdm",
              target: "blank",
            },
            {
              icon: "fab-twitter",
              title: "Mobile-only link",
              url: "https://twitter.com",
              view: "vmo",
              target: "blank",
            },
            {
              icon: "fab-gear",
              title: "More settings",
              url: "https://example.com",
              view: "vmo",
              target: "blank",
            },
            {
              icon: "user-group",
              title: "Groups",
              url: "https://example.com",
              view: "vmo",
              target: "blank",
            },
          ],
          svg_icons: "fab-facebook|fab-twitter|fab-gear|user-group",
        })
      );

      assert.deepEqual(Array.from(result), Array.from(expectedResult));
    });

    test("migrate empty settings", function (assert) {
      const settings = new Map(Object.entries({}));
      const result = migrate(settings);
      assert.deepEqual(Array.from(result), Array.from(settings));
    });

    test("migrate same settings", function (assert) {
      const settings = new Map(
        Object.entries({
          header_links: [
            {
              icon: "fab-facebook",
              title: "Desktop and mobile link",
              url: "https://facebook.com",
              view: "vdm",
              target: "blank",
            },
            {
              icon: "fab-twitter",
              title: "Mobile-only link",
              url: "https://twitter.com",
              view: "vmo",
              target: "blank",
            },
            {
              icon: "fab-gear",
              title: "More settings",
              url: "https://example.com",
              view: "vmo",
              target: "blank",
            },
            {
              icon: "user-group",
              title: "Groups",
              url: "https://example.com",
              view: "vmo",
              target: "blank",
            },
          ],
          svg_icons: "fab-facebook|fab-twitter|fab-gear|user-group",
        })
      );
      const result = migrate(settings);
      assert.deepEqual(Array.from(result), Array.from(settings));
    });
  }
);
