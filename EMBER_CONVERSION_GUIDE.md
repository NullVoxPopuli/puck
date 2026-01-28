# Ember.js Conversion Guide

## Overview

This document outlines the approach for converting the React-based Puck visual editor to modern Ember.js.

## Technology Stack

### Current (React)
- **Framework**: React 18/19
- **Build Tool**: tsup (esbuild-based)
- **Testing**: Jest
- **Templates**: TSX/JSX
- **State Management**: Zustand
- **Package Manager**: Yarn
- **Drag and Drop**: @dnd-kit

### Target (Ember.js)
- **Framework**: Ember.js v6.10+
- **Build Tool**: Vite v7.3+
- **Testing**: QUnit with ember-qunit
- **Templates**: GTS (Glimmer TypeScript) - no .hbs files
- **State Management**: Tracked properties and services
- **Package Manager**: pnpm
- **Drag and Drop**: ember-sortable or custom implementation

## Conversion Approach

### 1. Component Conversion

#### React to Ember GTS Pattern

**React Component (TSX):**
```tsx
import { useState } from "react";

export const MyComponent = ({ title, onAction }) => {
  const [isActive, setIsActive] = useState(false);
  
  return (
    <div className="my-component">
      <h1>{title}</h1>
      <button onClick={() => setIsActive(!isActive)}>
        {isActive ? 'Active' : 'Inactive'}
      </button>
    </div>
  );
};
```

**Ember Component (GTS):**
```typescript
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';

interface MyComponentSignature {
  Args: {
    title: string;
    onAction?: () => void;
  };
  Blocks: {
    default: [];
  };
}

export default class MyComponent extends Component<MyComponentSignature> {
  @tracked isActive = false;
  
  @action
  toggleActive() {
    this.isActive = !this.isActive;
  }
  
  <template>
    <div class="my-component">
      <h1>{{@title}}</h1>
      <button {{on "click" this.toggleActive}}>
        {{if this.isActive "Active" "Inactive"}}
      </button>
    </div>
  </template>
}
```

#### Key Conversion Patterns

1. **Props → Args**: `props.title` becomes `@title` (args) or `this.title` (class properties)
2. **useState → @tracked**: React state becomes tracked properties
3. **useEffect → @action/constructor**: Side effects move to actions or lifecycle hooks
4. **className → class**: CSS class names use `class` instead of `className`
5. **onClick → {{on "click"}}**: Event handlers use the `{{on}}` modifier
6. **{children} → {{yield}}**: Child content uses `{{yield}}`

### 2. State Management Conversion

#### React (Zustand):
```typescript
const useStore = create((set) => ({
  count: 0,
  increment: () => set((state) => ({ count: state.count + 1 })),
}));
```

#### Ember (Service with Tracked Properties):
```typescript
import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';

export default class CounterService extends Service {
  @tracked count = 0;
  
  @action
  increment() {
    this.count++;
  }
}
```

### 3. Testing Conversion

#### React (Jest):
```typescript
import { render, screen } from '@testing-library/react';
import { Button } from './Button';

test('renders button', () => {
  render(<Button>Click me</Button>);
  expect(screen.getByText('Click me')).toBeInTheDocument();
});
```

#### Ember (QUnit):
```typescript
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render } from '@ember/test-helpers';
import PuckButton from 'ember-core/components/puck-button';

module('Integration | Component | puck-button', function(hooks) {
  setupRenderingTest(hooks);

  test('it renders', async function(assert) {
    await render(<template><PuckButton>Click me</PuckButton></template>);
    assert.dom('.puck-button').hasText('Click me');
  });
});
```

### 4. Build Configuration

The Ember project uses Vite through @embroider/vite, which provides:
- Fast development server
- Optimized production builds
- Tree-shaking
- Modern JavaScript features

Configuration is in `vite.config.mjs` and uses Embroider for Ember-specific features.

### 5. Drag and Drop

The React version uses `@dnd-kit`. For Ember, we can use:
- **ember-sortable**: For simple sortable lists
- **ember-drag-drop**: For more complex drag-and-drop
- **Custom implementation**: Using native HTML5 Drag and Drop API with tracked properties

### 6. CSS Modules

React uses CSS Modules for component styles. In Ember:
- Use regular CSS files imported in components
- Follow BEM naming convention (e.g., `puck-button`, `puck-button__icon`, `puck-button--primary`)
- Import component styles in `app/styles/app.css`

## Proof of Concept

See `packages/ember-core/app/components/puck-button.gts` for a complete example of converting the Button component from React to Ember GTS.

### What Was Converted

1. **Component Logic**: React functional component → Glimmer component class
2. **State**: `useState` → `@tracked` properties
3. **Event Handlers**: `onClick` → `{{on "click"}}` modifier
4. **Props**: React props → Ember args with TypeScript signatures
5. **Conditional Rendering**: JSX ternaries → `{{if}}` helpers
6. **CSS**: CSS Modules → BEM-style regular CSS
7. **Tests**: Jest → QUnit with ember-qunit

## File Structure

```
packages/ember-core/
├── app/
│   ├── components/         # GTS components (no .hbs files)
│   ├── services/          # Ember services for state management
│   ├── helpers/           # Template helpers
│   ├── modifiers/         # Element modifiers
│   └── styles/            # CSS files
│       ├── app.css        # Main stylesheet
│       └── components/    # Component-specific styles
├── tests/
│   ├── integration/       # Component integration tests
│   └── unit/             # Unit tests
├── vite.config.mjs       # Vite configuration
├── ember-cli-build.js    # Ember build configuration
└── package.json          # Dependencies and scripts
```

## Migration Strategy

1. **Phase 1: Foundation** ✅
   - Set up pnpm workspace
   - Create modern Ember.js addon with Vite
   - Configure QUnit testing
   - Set up GTS support

2. **Phase 2: Core Components** (In Progress)
   - Convert Button component ✅
   - Convert Loader component
   - Convert Icon components
   - Convert basic UI components

3. **Phase 3: Complex Components**
   - Convert DropZone component
   - Convert Puck editor component
   - Convert Render component
   - Convert field components

4. **Phase 4: State Management**
   - Create services for app state
   - Implement reducer logic with tracked properties
   - Convert store slices to services

5. **Phase 5: Testing**
   - Convert all Jest tests to QUnit
   - Add integration tests
   - Add acceptance tests

6. **Phase 6: Documentation & Polish**
   - Update README files
   - Create usage examples
   - Write migration guide
   - Update demo apps

## Next Steps

1. Complete conversion of basic UI components (Loader, IconButton, Drawer)
2. Set up drag-and-drop infrastructure
3. Convert field components (AutoField, SelectField, etc.)
4. Implement state management services
5. Convert the main Puck editor component
6. Update demo applications

## Resources

- [Ember.js Guides](https://guides.emberjs.com/)
- [Glimmer Components](https://guides.emberjs.com/release/components/)
- [GTS (Glimmer TypeScript)](https://github.com/ember-template-imports/ember-template-imports)
- [QUnit Documentation](https://qunitjs.com/)
- [Embroider (Modern Ember Build)](https://github.com/embroider-build/embroider)
- [Vite Documentation](https://vitejs.dev/)
