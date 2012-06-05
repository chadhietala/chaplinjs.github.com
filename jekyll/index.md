---
layout: page
title: Chaplin
tagline: An Application Architecture Using Backbone.js
---

![Chaplin](http://s3.amazonaws.com/imgly_production/3401027/original.png)

## An Application Architecture Using Backbone.js

Chaplin is an architecture for JavaScript applications using the [Backbone.js](http://documentcloud.github.com/backbone/) library. The code is derived from [moviepilot.com](http://moviepilot.com/), a large single-page application.

## Key Features

* Module encapsulation and lazy-loading using AMD modules
* Cross-module communication using the Mediator and Publish/Subscribe patterns
* Controllers for managing individual UI views
* Rails-style routes which map URLs to controller actions
* A route dispatcher and a top-level layout manager (Layout)
* Extended model, view and collection classes to avoid repetition and enforce conventions
* Strict memory management and object disposal
* A collection view for easy and intelligent list rendering

* Current Version / Release Notes / Changelog
* Download and Getting Started
* Chaplin main repository
* Examples
* Getting involved
* License
* Authors


## Changelogs

----------------------------------

### [1.0](https://github.com/chaplinjs/chaplin/tree/1.0) - [Read the documentation]({{ "1.0" | version_url }})

TODO

----------------------------------

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
