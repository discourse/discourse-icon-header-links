import Component from "@glimmer/component";
import { service } from "@ember/service";
import { htmlSafe } from "@ember/template";
import { eq } from "truth-helpers";
import concatClass from "discourse/helpers/concat-class";
import icon from "discourse/helpers/d-icon";
import dasherize from "discourse/helpers/dasherize";
import { escapeExpression } from "discourse/lib/utilities";
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
    return Number.isFinite(numericWidth)
      ? htmlSafe(`width: ${escapeExpression(numericWidth)}px`)
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
