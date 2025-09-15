import Component from "@glimmer/component";
import { service } from "@ember/service";
import { htmlSafe } from "@ember/template";
import { eq } from "truth-helpers";
import concatClass from "discourse/helpers/concat-class";
import icon from "discourse/helpers/d-icon";
import dasherize from "discourse/helpers/dasherize";
import { escapeExpression } from "discourse/lib/utilities";
import isValidUrl from "../lib/isValidUrl";

export default class CustomHeaderIcon extends Component {
  static shouldRender(args, context) {
    return context.site.mobileView
      ? args.link.view === "vmo" || args.link.view === "vdm"
      : args.link.view === "vdo" || args.link.view === "vdm";
  }

  @service site;

  get className() {
    return `header-icon-${dasherize(this.args.link.title)}`;
  }

  get isLastLink() {
    const visibleLinks = this.args.links.filter((item) =>
      this.site.mobileView
        ? item.view === "vmo" || item.view === "vdm"
        : item.view === "vdo" || item.view === "vdm"
    );

    return this.args.link === visibleLinks.at(-1);
  }

  get style() {
    const numericWidth = Number(this.args.link.width);
    return Number.isFinite(numericWidth)
      ? htmlSafe(`width: ${escapeExpression(numericWidth)}px`)
      : undefined;
  }

  <template>
    <li
      class={{concatClass
        "custom-header-icon-link"
        this.className
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
