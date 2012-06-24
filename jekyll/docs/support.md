---
layout: page
title: Chaplin.support
tagline: " - API documentation"
---

Currently `Chaplin.support` only offers feature detection for `defineProperty`.

## Methods of `Chaplin.support`

-------------------

<a name="propertyDescriptors"></a>

### propertyDescriptors

Determines if `Object.defineProperty` is supported. It's important to note that IE8 has an implementation of `Object.defineProperty` however the method can only be used on DOM objects.

## Usage

Support is used for feature detection and will return a boolean weather or not eh feature is detected.

## Code

<pre><code class="coffeescript">
define ->
  'use strict'

  # Feature detection
  # -----------------

  support =

    # Test for defineProperty support
    # (IE 8 knows the method but will throw an exception)
    propertyDescriptors: do ->
      unless typeof Object.defineProperty is 'function' and
        typeof Object.defineProperties is 'function'
          return false
      try
        o = {}
        Object.defineProperty o, 'foo', value: 'bar'
        return o.foo is 'bar'
      catch error
        return false

  support
</code></pre>
