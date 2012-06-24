---
layout: page
title: Chaplin.Route
tagline: " - API documentation"
---

The `Chaplin Route` is used by `Chaplin.Router` to generate regular expressions and extract pramaters from a given pattern.

## Methods of `Chaplin.Route`

<a name="createRegExp"></a>

### createRegExp

Creates the actual regular expression that Backbone.History#LoadUrl uses to determine if the current url is a match.

-------------------

<a name="addParamName"></a>

### addParamName([match], [paramName])

Determines if the pattern passed is a reserved named, if not than it is added to the `@paramsName` object and returns `([^\/\?]+)` to do a replacement for the character class.

<ul class="arguments">
  <li>
    <strong>match</strong>: the parameter with the colon `:user`
  </li>
  <li>
    <strong>paramName</strong>: the parameter with the colon stripped `user`
  </li>
</ul>

-------------------

<a name="test"></a>

### test([path])

Tests if the route matches a path and applies any parameter constraints.  This is called by Backbone.History#Loadurl.

<ul class="arguments">
  <li>
    <strong>path</strong>: a relative path to check against
  </li>
</ul>

-------------------

<a name="handler"></a>

### handler([path], [options])

The handler is called by Backbone.History when the route is matched.  It is also called by [Router#route](/docs/router.html#routepath) and passes `changeURL: true` as an option.

<ul class="arguments">
  <li>
    <strong>path</strong>: the matched path
  </li>
  <li>
    <strong>options</strong>: an optional object
  </li>
</ul>

-------------------

<a name="buildParams"></a>

### buildParams([path], [options])

Creates a proper Rails-like params hash, not an array like Backbone `matches` and `additionalParams` arguments are optional.

<ul class="arguments">
  <li>
    <strong>path</strong>: the matched URL path
  </li>
  <li>
    <strong>options</strong>: an optional object
  </li>
</ul>

-------------------

<a name="extractParams"></a>

### extractParams([path])

Extracts the named parameters from the URL path.

<ul class="arguments">
  <li>
    <strong>path</strong>: the URL path
  </li>
</ul>

-------------------

<a name="extractQueryParams"></a>

### extractQueryParams([path])

Extracts the parameters from the query string.

<ul class="arguments">
  <li>
    <strong>path</strong>: the URL path
  </li>
</ul>

-------------------

## Usage

A new instance of `Chaplin.Route` is created for each route in the routes file of your application.  This occurs when the [match method](/docs/router.html#matchpattern-target-options) of `Chaplin.Router` is called. The actual routes file should be in the root of your project along with your main application bootstrapper file.

The routes file is basically a module that returns an anonymous function in which the [match method](/docs/router.html#matchpattern-target-options) is passed in as an argument.

## Dependencies

- `underscore`
- `backbone`
- `chaplin/mediator`
- `chaplin/lib/subscriber`
- `chaplin/controllers/controller`

## Code

<pre><code class="coffeescript">
define [
  'underscore'
  'backbone'
  'chaplin/mediator'
  'chaplin/controllers/controller'
], (_, Backbone, mediator, Controller) ->
  'use strict'

  class Route

    # Borrow the static extend method from Backbone
    @extend = Backbone.Model.extend

    reservedParams = ['path', 'changeURL']
    # Taken from Backbone.Router
    escapeRegExp = /[-[\]{}()+?.,\\^$|#\s]/g

    queryStringFieldSeparator = '&'
    queryStringValueSeparator = '='

    # Create a route for a URL pattern and a controller action
    # e.g. new Route '/users/:id', 'users#show'
    constructor: (pattern, target, @options = {}) ->
      # Save the raw pattern
      @pattern = pattern

      # Separate target into controller and controller action
      [@controller, @action] = target.split('#')

      # Check if the action is a reserved name
      if _(Controller.prototype).has @action
        throw new Error 'Route: You should not use existing controller properties as action names'

      @createRegExp()

    createRegExp: ->
      if _.isRegExp(@pattern)
        @regExp = @pattern
        return

      pattern = @pattern
        # Escape magic characters
        .replace(escapeRegExp, '\\$&')
        # Replace named parameters, collecting their names
        .replace(/:(\w+)/g, @addParamName)

      # Create the actual regular expression
      # Match until the end of the URL or the begin of query string
      @regExp = ///^#{pattern}(?=\?|$)///

    addParamName: (match, paramName) =>
      @paramNames ?= []
      # Test if parameter name is reserved
      if _(reservedParams).include(paramName)
        throw new Error "Route#addParamName: parameter name #{paramName} is reserved"
      # Save parameter name
      @paramNames.push paramName
      # Replace with a character class
      '([^\/\?]+)'

    # Test if the route matches to a path (called by Backbone.History#loadUrl)
    test: (path) ->
      # Test the main RegExp
      matched = @regExp.test path
      return false unless matched

      # Apply the parameter constraints
      constraints = @options.constraints
      if constraints
        params = @extractParams path
        for own name, constraint of constraints
          unless constraint.test(params[name])
            return false

      return true

    # The handler which is called by Backbone.History when the route matched.
    # It is also called by Router#follow which might pass options
    handler: (path, options) =>
      # Build params hash
      params = @buildParams path, options

      # Publish a global matchRoute event passing the route and the params
      mediator.publish 'matchRoute', this, params

    # Create a proper Rails-like params hash, not an array like Backbone
    # `matches` and `additionalParams` arguments are optional
    buildParams: (path, options) ->
      params = {}

      # Add params from query string
      queryParams = @extractQueryParams path
      _(params).extend queryParams

      # Add named params from pattern matches
      patternParams = @extractParams path
      _(params).extend patternParams

      # Add additional params from options
      # (they might overwrite params extracted from URL)
      _(params).extend @options.params

      # Add a `changeURL` param whether to change the URL after routing
      # Defaults to false unless explicitly set in options
      params.changeURL = Boolean(options and options.changeURL)

      # Add a `path  param with the whole path match
      params.path = path

      params

    # Extract named parameters from the URL path
    extractParams: (path) ->
      params = {}

      # Apply the regular expression
      matches = @regExp.exec path

      # Fill the hash using the paramNames and the matches
      for match, index in matches.slice(1)
        paramName = if @paramNames then @paramNames[index] else index
        params[paramName] = match

      params

    # Extract parameters from the query string
    extractQueryParams: (path) ->
      params = {}

      regExp = /\?(.+?)(?=#|$)/
      matches = regExp.exec path
      return params unless matches

      queryString = matches[1]
      pairs = queryString.split queryStringFieldSeparator
      for pair in pairs
        continue unless pair.length
        [field, value] = pair.split queryStringValueSeparator
        continue unless field.length
        field = decodeURIComponent field
        value = decodeURIComponent value
        current = params[field]
        if current
          # Handle multiple params with same name:
          # Aggregate them in an array
          if current.push
            # Add the existing array
            current.push value
          else
            # Create a new array
            params[field] = [current, value]
        else
          params[field] = value

      params
</code></pre>
