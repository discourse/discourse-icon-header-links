# frozen_string_literal: true
RSpec.describe "Discourse icon header links", system: true do
  let(:theme) { Fabricate(:theme) }
  let!(:component) { upload_theme_component(parent_theme_id: theme.id) }

  before { theme.set_default! }

  context "when in desktop" do
    it "renders the correct icon" do
      visit("/")

      expect(
        page.find(
          ".custom-header-icon-link.header-icon-desktop-and-mobile-link.vdm.last-custom-icon",
        ),
      ).to have_link(
        title: "Desktop and mobile link",
        href: "https://facebook.com",
        target: "_blank",
      )
      expect(
        page.find(
          ".custom-header-icon-link.header-icon-desktop-and-mobile-link.vdm.last-custom-icon",
        ),
      ).to have_selector(".d-icon-fab-facebook")
    end
  end

  context "when using the width attribute" do
    before do
      component.update_setting(
        :header_links,
        [
          {
            icon: "fab-facebook",
            url: "https://facebook.com",
            title: "Desktop and mobile link",
            width: 200,
            view: "vdm",
          },
        ],
      )
      component.save!
    end

    it "renders the icon with the correct width" do
      visit("/")

      expect(page.find(".custom-header-icon-link .icon").style("width")).to eq(
        { "width" => "200px" },
      )
    end
  end

  context "when in mobile", mobile: true do
    it "renders the correct icon" do
      visit("/")

      expect(
        page.find(".custom-header-icon-link.header-icon-desktop-and-mobile-link.vdm"),
      ).to have_link(
        title: "Desktop and mobile link",
        href: "https://facebook.com",
        target: "_blank",
      )
      expect(
        page.find(".custom-header-icon-link.header-icon-desktop-and-mobile-link.vdm"),
      ).to have_selector(".d-icon-fab-facebook")

      expect(
        page.find(".custom-header-icon-link.header-icon-mobile-only-link.vmo.last-custom-icon"),
      ).to have_link(title: "Mobile-only link", href: "https://twitter.com", target: "_blank")
      expect(
        page.find(".custom-header-icon-link.header-icon-mobile-only-link.vmo.last-custom-icon"),
      ).to have_selector(".d-icon-fab-twitter")
    end
  end
end
