import { module, test } from "qunit";
import migrate from "../../../../migrations/settings/0001-migrate-to-object-settings";

module(
  "Unit | Migrations | Settings | 0001-migrate-to-object-settings",
  function () {
    test("migrate", function (assert) {
      const settings = new Map(
        Object.entries({
          Header_links:
            "Desktop mobile link, fab-facebook, https://facebook.com, vdm, blank|Mobile-only link, fab-twitter, https://twitter.com, vmo, blank",
        })
      );

      const result = migrate(settings);

      const expectedResult = new Map(
        Object.entries({
          Header_links: [
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
          ],
        })
      );

      assert.deepEqual(Array.from(result), Array.from(expectedResult));
    });
  }
);
