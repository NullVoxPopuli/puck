import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render, click } from '@ember/test-helpers';
import { tracked } from '@glimmer/tracking';
import PuckButton from 'ember-core/components/puck-button';

module('Integration | Component | puck-button', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders with default variant and size', async function (assert) {
    await render(<template><PuckButton>Click me</PuckButton></template>);

    assert.dom('.puck-button').exists();
    assert.dom('.puck-button').hasText('Click me');
    assert.dom('.puck-button--primary').exists();
    assert.dom('.puck-button--medium').exists();
  });

  test('it renders as secondary variant', async function (assert) {
    await render(<template><PuckButton @variant="secondary">Secondary</PuckButton></template>);

    assert.dom('.puck-button--secondary').exists();
    assert.dom('.puck-button--primary').doesNotExist();
  });

  test('it renders as large size', async function (assert) {
    await render(<template><PuckButton @size="large">Large</PuckButton></template>);

    assert.dom('.puck-button--large').exists();
    assert.dom('.puck-button--medium').doesNotExist();
  });

  test('it renders as a link when href is provided', async function (assert) {
    await render(<template><PuckButton @href="/test">Link</PuckButton></template>);

    assert.dom('a.puck-button').exists();
    assert.dom('a.puck-button').hasAttribute('href', '/test');
  });

  test('it opens in new tab when newTab is true', async function (assert) {
    await render(<template><PuckButton @href="/test" @newTab={{true}}>Link</PuckButton></template>);

    assert.dom('a.puck-button').hasAttribute('target', '_blank');
    assert.dom('a.puck-button').hasAttribute('rel', 'noreferrer');
  });

  test('it renders as a button with type', async function (assert) {
    await render(<template><PuckButton @type="submit">Submit</PuckButton></template>);

    assert.dom('button.puck-button').exists();
    assert.dom('button.puck-button').hasAttribute('type', 'submit');
  });

  test('it handles click events', async function (assert) {
    let clickCount = 0;
    const handleClick = () => {
      clickCount++;
    };

    await render(<template><PuckButton @onClick={{handleClick}}>Click</PuckButton></template>);

    await click('.puck-button');
    assert.strictEqual(clickCount, 1, 'Click handler was called once');

    await click('.puck-button');
    assert.strictEqual(clickCount, 2, 'Click handler was called twice');
  });

  test('it shows loading state', async function (assert) {
    await render(<template><PuckButton @loading={{true}}>Loading</PuckButton></template>);

    assert.dom('.puck-button__spinner').exists();
  });

  test('it disables button when disabled', async function (assert) {
    await render(<template><PuckButton @type="button" @disabled={{true}}>Disabled</PuckButton></template>);

    assert.dom('button.puck-button').isDisabled();
    assert.dom('.puck-button--disabled').exists();
  });

  test('it renders with full width', async function (assert) {
    await render(<template><PuckButton @fullWidth={{true}}>Full Width</PuckButton></template>);

    assert.dom('.puck-button--full-width').exists();
  });

  test('it handles async click events with loading state', async function (assert) {
    let resolveClick;
    const promise = new Promise((resolve) => {
      resolveClick = resolve;
    });
    
    const handleClick = () => promise;

    await render(<template><PuckButton @onClick={{handleClick}}>Async</PuckButton></template>);

    const clickPromise = click('.puck-button');
    
    // Should show loading state while promise is pending
    assert.dom('.puck-button__spinner').exists();
    
    resolveClick();
    await clickPromise;
    
    // Loading state should be cleared after promise resolves
    assert.dom('.puck-button__spinner').doesNotExist();
  });

  test('it renders icon block', async function (assert) {
    await render(<template>
      <PuckButton>
        <:icon>⭐</:icon>
        With Icon
      </PuckButton>
    </template>);

    assert.dom('.puck-button__icon').exists();
    assert.dom('.puck-button__icon').hasText('⭐');
  });
});
