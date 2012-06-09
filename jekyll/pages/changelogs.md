---
layout: page
title: Changelogs
group: navigation
---

## Current Version: 0.3

The current stable version is **0.3**, released on 2012-03-23.

To use the stable version, please clone the repository and [check out the tag 0.3](https://github.com/chaplinjs/chaplin/tree/0.3).

See also the [Changelog](https://github.com/chaplinjs/chaplin/blob/master/CHANGELOG.md).

## Upcoming Version: Chaplin as a Library

While the stable version is merely an example application structure, our goal is to generalize Chaplin into a separate, reusable and unit-tested library.

There’s a major rewrite going on and the `master` branch already reflects these changes. We’re working on several topics:

- Improving and generalizing the Chaplin architecture
- Writing tests for all Chaplin core components
- Writing an up-to-date documentation and writing a class & method reference
- Creating a boilerplate app, outsourcing the current application examples



### [1.0](https://github.com/chaplinjs/chaplin/tree/1.0) - [Read the documentation]({{ "1.0" | version_url }})

TODO



## Older versions

### [0.3](https://github.com/chaplinjs/chaplin/tree/0.3) - [Read the documentation]({{ "0.3" | version_url }})

**Date:** 2012-03-23

**Commit:** [1dad18c38c](https://github.com/chaplinjs/chaplin/commit/1dad18c38c)

- Bug fix: In CollectionView, get the correct item position when rendering
  the item view. Fixes the rendering of sorted Collections. Before the fix,
  the item views might have been displayed in the wrong order.

----------------------------------

### [0.2](https://github.com/chaplinjs/chaplin/tree/0.2)

**Date:** 2012-03-09

**Commit:** [4a66c8a581](https://github.com/chaplinjs/chaplin/commit/4a66c8a581)

- Bug fix: Correctly unsubscribe global handlers when disposing a collection
- Code formatting

----------------------------------

### [0.1](https://github.com/chaplinjs/chaplin/tree/0.1)

**Date:** 2012-02-26

**Commit:** [f6ba02b4f3](https://github.com/chaplinjs/chaplin/commit/f6ba02b4f3)

Initial release

----------------------------------
