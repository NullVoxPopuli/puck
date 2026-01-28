import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { modifier } from 'ember-modifier';

export interface ButtonSignature {
  Element: HTMLButtonElement | HTMLAnchorElement | HTMLSpanElement;
  Args: {
    href?: string;
    onClick?: (e: Event) => void | Promise<void>;
    variant?: 'primary' | 'secondary';
    type?: 'button' | 'submit' | 'reset';
    disabled?: boolean;
    tabIndex?: number;
    newTab?: boolean;
    fullWidth?: boolean;
    size?: 'medium' | 'large';
    loading?: boolean;
  };
  Blocks: {
    default: [];
    icon?: [];
  };
}

/**
 * A flexible Button component that can render as a button, link, or span.
 * 
 * @example
 * <PuckButton @variant="primary" @onClick={{this.handleClick}}>
 *   Click me
 * </PuckButton>
 * 
 * @example
 * <PuckButton @href="/path" @newTab={{true}}>
 *   Link Button
 * </PuckButton>
 */
export default class PuckButtonComponent extends Component<ButtonSignature> {
  @tracked isLoading = false;

  get variant() {
    return this.args.variant || 'primary';
  }

  get size() {
    return this.args.size || 'medium';
  }

  get loading() {
    return this.args.loading || this.isLoading;
  }

  get elementType(): 'button' | 'a' | 'span' {
    if (this.args.href) return 'a';
    if (this.args.type) return 'button';
    return 'span';
  }

  get classes() {
    const classes = ['puck-button'];
    
    if (this.variant === 'primary') classes.push('puck-button--primary');
    if (this.variant === 'secondary') classes.push('puck-button--secondary');
    if (this.args.disabled) classes.push('puck-button--disabled');
    if (this.args.fullWidth) classes.push('puck-button--full-width');
    if (this.size === 'medium') classes.push('puck-button--medium');
    if (this.size === 'large') classes.push('puck-button--large');
    
    return classes.join(' ');
  }

  @action
  async handleClick(event: Event) {
    if (!this.args.onClick) return;

    this.isLoading = true;
    try {
      await Promise.resolve(this.args.onClick(event));
    } finally {
      this.isLoading = false;
    }
  }

  <template>
    {{#if (eq this.elementType "a")}}
      <a
        href={{@href}}
        class={{this.classes}}
        target={{if @newTab "_blank"}}
        rel={{if @newTab "noreferrer"}}
        tabindex={{@tabIndex}}
        {{on "click" this.handleClick}}
        ...attributes
      >
        {{#if (has-block "icon")}}
          <div class="puck-button__icon">
            {{yield to="icon"}}
          </div>
        {{/if}}
        {{yield}}
        {{#if this.loading}}
          <div class="puck-button__spinner">
            <PuckLoader @size={{14}} />
          </div>
        {{/if}}
      </a>
    {{else if (eq this.elementType "button")}}
      <button
        type={{@type}}
        class={{this.classes}}
        disabled={{or @disabled this.loading}}
        tabindex={{@tabIndex}}
        {{on "click" this.handleClick}}
        ...attributes
      >
        {{#if (has-block "icon")}}
          <div class="puck-button__icon">
            {{yield to="icon"}}
          </div>
        {{/if}}
        {{yield}}
        {{#if this.loading}}
          <div class="puck-button__spinner">
            <PuckLoader @size={{14}} />
          </div>
        {{/if}}
      </button>
    {{else}}
      <span
        class={{this.classes}}
        tabindex={{@tabIndex}}
        {{on "click" this.handleClick}}
        ...attributes
      >
        {{#if (has-block "icon")}}
          <div class="puck-button__icon">
            {{yield to="icon"}}
          </div>
        {{/if}}
        {{yield}}
        {{#if this.loading}}
          <div class="puck-button__spinner">
            <PuckLoader @size={{14}} />
          </div>
        {{/if}}
      </span>
    {{/if}}
  </template>
}
