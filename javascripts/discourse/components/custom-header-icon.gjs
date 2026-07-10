import Component from "@glimmer/component";
import { service } from "@ember/service";
import { htmlSafe } from "@ember/template";
import concatClass from "discourse/helpers/concat-class";
import icon from "discourse/helpers/d-icon";
import dasherize from "discourse/helpers/dasherize";
import { escapeExpression } from "discourse/lib/utilities";
import { eq } from "discourse/truth-helpers";
import isValidUrl from "../lib/isValidUrl";

const MOBILE_VIEWS = new Set(["vmo", "vdm"]);
const DESKTOP_VIEWS = new Set(["vdo", "vdm"]);

function shouldRenderViewMode(view, isMobile) {
  return isMobile ? MOBILE_VIEWS.has(view) : DESKTOP_VIEWS.has(view);
}

export default class CustomHeaderIcon extends Component {
  static shouldRender(args, context) {
    return shouldRenderViewMode(args.link.view, context.site.mobileView);
  }

  @service site;

  get iconClassName() {
    return `header-icon-${dasherize(this.args.link.title)}`;
  }

  get isLastLink() {
    return this.args.link === this.visibleLinks.at(-1);
  }

  get style() {
    const numericWidth = Number(this.args.link.width);
    // `!important` is needed to override the header icon width that core
    // sets with `!important` when the "modernize foundation theme" upcoming
    // change is enabled (`.uc-modernize-foundation-theme .d-header-icons
    // .btn.icon { width: 2em !important }`).
    return Number.isFinite(numericWidth)
      ? htmlSafe(`width: ${escapeExpression(numericWidth)}px !important`)
      : undefined;
  }

  get visibleLinks() {
    return this.args.links.filter((link) =>
      shouldRenderViewMode(link.view, this.site.mobileView)
    );
  }

  <template>
    <li
      class={{concatClass
        "custom-header-icon-link"
        this.iconClassName
        @link.view
        (if this.isLastLink "last-custom-icon")
      }}
    >
      <a
        class="btn no-text icon btn-flat"
        href={{@link.url}}
        title={{@link.title}}
        target={{if (eq @link.target "blank") "_blank"}}
        rel={{if @link.target "noopener"}}
        style={{this.style}}
      >
        {{#if (isValidUrl @link.icon)}}
          <img src={{@link.icon}} aria-hidden="true" />
          <span class="sr-only">{{@link.title}}</span>
        {{else}}
          {{icon @link.icon label=@link.title}}
        {{/if}}
      </a>
    </li>
  </template>
}
