# @puckeditor/ember-core

The open-source visual editor for Ember.js - an Ember.js implementation of Puck.

This is a modern Ember.js v6+ implementation of the Puck visual editor, using:
- **pnpm** for package management
- **Vite** for building
- **QUnit** for testing  
- **GTS** (Glimmer TypeScript) for components (no .hbs files)
- **Tracked properties** for state management
- **Modern Ember.js patterns** throughout

## Status

🚧 **Work in Progress** - This is an active conversion from the React-based Puck editor to Ember.js.

## Prerequisites

You will need the following things properly installed on your computer.

- [Git](https://git-scm.com/)
- [Node.js](https://nodejs.org/)
- [pnpm](https://pnpm.io/)
- [Google Chrome](https://google.com/chrome/)

## Installation

- `git clone <repository-url>` this repository
- `cd ember-core`
- `pnpm install`

## Running / Development

- `pnpm start`
- Visit your app at [http://localhost:4200](http://localhost:4200).
- Visit your tests at [http://localhost:4200/tests](http://localhost:4200/tests).

### Code Generators

Make use of the many generators for code, try `pnpm ember help generate` for more details

### Running Tests

- `pnpm test`

### Linting

- `pnpm lint`
- `pnpm lint:fix`

### Building

- `pnpm vite build --mode development` (development)
- `pnpm build` (production)

### Deploying

Specify what it takes to deploy your app.

## Further Reading / Useful Links

- [ember.js](https://emberjs.com/)
- [Vite](https://vite.dev)
- Development Browser Extensions
  - [ember inspector for chrome](https://chrome.google.com/webstore/detail/ember-inspector/bmdblncegkenkacieihfhpjfppoconhi)
  - [ember inspector for firefox](https://addons.mozilla.org/en-US/firefox/addon/ember-inspector/)
