---
layout: page
title: Chaplin.Router
tagline: " - API documentation"
---

The `Chaplin Router` is a replacement for [Backbone.Router](http://documentcloud.github.com/backbone/#Router).  Like the standard router, it creates a [Backbone.History](http://documentcloud.github.com/backbone/#History) instance and registers routes on it. In Backbone's concept, there are no controllers, instead the Backbone Router maps routes to it's own methods, so it servers two purposes.  The Chaplin Router is simply just a router which maps URLs to seperate controllers, in particular controller actions.


## Methods of `Chaplin.Router`

<a name="createHistory"></a>

### createHistory

Creates the Backbone.History instance

-------------------

<a name="startHistory"></a>

### startHistory

Starts the Backbone.History instance.  This method should be called after all the routes have been registered.

-------------------

<a name="stopHistory"></a>

### stopHistory

Stops the Backbone.History instance from observing URL changes.

-------------------

<a name="match"></a>

### match([pattern], [target], [options={}])

Connects an address with a controller action.  Directly creates a new Route instance on the Backbone.History instance.

<ul class="arguments">
  <li>
    <strong>pattern</strong>: a url pattern to match against the current URL
  </li>
  <li>
    <strong>target</strong>: the controller and the action you want to execute on it
  </li>
  <li>
    <strong>options</strong>: optional object to be passed to the Routes object
  </li>
</ul>

-------------------

<a name="route"></a>

### route([path])

Route a given path manually. Returns a boolean after it has been matched against handlers in Backbone.history.handlers.  This looks quite like Backbone.history.loadUrl, but it accepts an absolute URL with a leading slash (e.g. /foo) and passes a changeURL parameter to the callback function.

<ul class="arguments">
  <li>
    <strong>path</strong>: an absolute URL with a leading slash
  </li>
</ul>

-------------------

<a name="routeHandler"></a>

### routeHandler([path], [callback])

When the globalized `!router:route` event is emitted call the callback associated with the route.

<ul class="arguments">
  <li>
    <strong>path</strong>: an absolute URL with a leading slash
  </li>
  <li>
    <strong>callback</strong>: a callback to call when routed
  </li>
</ul>

-------------------

<a name="changeURL"></a>

### changeURL([url])

Changes the current URL and adds a history entry.  Does not trigger any routes.

<ul class="arguments">
  <li>
    <strong>url</strong>: string that is going to be pushed as the pages url
  </li>
</ul>

-------------------

<a name="changeURLHandler"></a>

### changeURLHandler([url])

Handler for the globalized `!router:changeURL` event.  Calls `@changeURL`.

<ul class="arguments">
  <li>
    <strong>url</strong>: string that is going to be pushed as the pages url
  </li>
</ul>

-------------------

<a name="dispose"></a>

### dispose

Stops the Backbone.history instance and removes it from the Router object.  Also unsubscribes any events attached to the Router.  Attempts to freeze the Router to prevent any changes to the Router. See [Object.freeze](https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Object/freeze).


## Usage 
The Chaplin Router is a dependancy of [Chaplin.Application](./application.html) which should be extended from by your main application class. Within your application class you should initialize the Router by calling `@initRouter` passing your routes module as an argument.

    define [
      'chaplin',
      'routes'
    ], (Chaplin, routes) ->
      'use strict'

      class MyApplication extends Chaplin.Application

        title: 'The title for your application'

        initialize: ->
          super

          @initRouter routes

## Dependencies

- `underscore`
- `backbone`
- `chaplin/mediator`
- `chaplin/lib/subscriber`
- `chaplin/lib/route`

## Code


<pre><code class="coffeescript">
define [
  'underscore'
  'backbone'
  'chaplin/mediator'
  'chaplin/lib/subscriber'
  'chaplin/lib/route'
], (_, Backbone, mediator, Subscriber, Route) ->
  'use strict'

  # The router which is a replacement for Backbone.Router.
  # Like the standard router, it creates a Backbone.History
  # instance and registers routes on it.

  class Router # This class does not extend Backbone.Router

    _(@prototype).extend Subscriber

    constructor: (@options = {}) ->
      _(@options).defaults
        pushState: true

      @subscribeEvent '!router:route', @routeHandler
      @subscribeEvent '!router:changeURL', @changeURLHandler

      @createHistory()

    # Create a Backbone.History instance
    createHistory: ->
      Backbone.history or= new Backbone.History()

    startHistory: ->
      # Start the Backbone.History instance to start routing
      # This should be called after all routes have been registered
      Backbone.history.start @options

    # Stop the current Backbone.History instance from observing URL changes
    stopHistory: ->
      Backbone.history.stop()

    # Connect an address with a controller action
    # Directly create a route on the Backbone.History instance
    match: (pattern, target, options = {}) =>

      # Create a route
      route = new Route pattern, target, options

      # Register the route at the Backbone.History instance
      Backbone.history.route route, route.handler

    # Route a given URL path manually, returns whether a route matched
    # This looks quite like Backbone.History::loadUrl but it
    # accepts an absolute URL with a leading slash (e.g. /foo)
    # and passes a changeURL param to the callback function.
    route: (path) =>
      # Remove leading hash or slash
      path = path.replace /^(\/#|\/)/, ''

      for handler in Backbone.history.handlers
        if handler.route.test(path)
          handler.callback path, changeURL: true
          return true
      false

    # Handler for the global !router:route event
    routeHandler: (path, callback) ->
      routed = @route path
      callback? routed

    # Change the current URL, add a history entry.
    # Do not trigger any routes (which is Backbone’s
    # default behavior, but added for clarity)
    changeURL: (url) ->
      Backbone.history.navigate url, trigger: false

    # Handler for the global !router:changeURL event
    changeURLHandler: (url) ->
      @changeURL url

    # Disposal
    # --------

    disposed: false

    dispose: ->
      return if @disposed

      # Stop Backbone.History instance and remove it
      @stopHistory()
      delete Backbone.history

      @unsubscribeAllEvents()

      # Finished
      @disposed = true

      # You’re frozen when your heart’s not open
      Object.freeze? this

</code></pre>
