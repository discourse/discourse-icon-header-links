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
        })
      );

      assert.deepEqual(Array.from(result), Array.from(expectedResult));
    });
  }
);