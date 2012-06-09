---
layout: page
title: Chaplin.Application
tagline: " - API documentation"
---

The `Chaplin.Application` is a bootstrapper which provides methods to start other core modules as needed:
* `Router`
* `Dispatcher`
* `Layout`



## Methods of `Chaplin.Application`

### initDispatcher([options={}])
Initialize `Chaplin.Dispatcher`. [Chaplin.Dispatcher documentation](/docs/dispatcher.html)

-------------------

### initLayout([options={}])
Initialize `Chaplin.Layout`. [Chaplin.Layout documentation](/docs/layout.html)

-------------------

### initRouter(routes, [options={}])
Initialize `Chaplin.Router`. [Chaplin.Router documentation](/docs/router.html)



## Usage
The `Chaplin.Application` is intended to be extended by your Application. The `initialize` method instanciate the `Chaplin.Dispatcher`, `Chaplin.Layout` and `Chaplin.Router` by calling the `Chaplin.Application.init*` methods:

    define [
      'chaplin',
      'routes'
    ], (Chaplin, routes) ->
      'use strict'

      class MyApplication extends Chaplin.Application

        title: 'The title for your application'

        initialize: ->
          super

          # Initialize core components
          @initDispatcher()
          @initLayout()
          @initRouter routes


In this exemple, we don't extend the Layout but it is likely that you will need to. In this case, you will load it as a dependency and overwrite the `initLayout` (or skip it):

    define [
      'chaplin',
      'views/layout' # our extend Layout
    ], (Chaplin, Layout) ->
      'use strict'

      class MyApplication extends Chaplin.Application

        title: 'The title for your application'

        initialize: ->
          # ...

          @layout = new Layout {@title} # option 1: instanciate directly the Layout
          # OR
          @initLayout()                 # option 2: we still call initLayout...

        initLayout: ->                  #           ... and overwrite it to load the good Layout
          @layout = new Layout {@title}


## Dependencies
- `chaplin/mediator`
- `chaplin/dispatcher`
- `chaplin/views/layout`
- `chaplin/lib/router`


## Code
<pre><code class="coffeescript">
    class Application

      # The site title used in the document title
      title: ''

      # The application instantiates these three core modules
      dispatcher: null
      layout: null
      router: null

      initialize: ->

      initDispatcher: (options) ->
        @dispatcher = new Dispatcher options

      initLayout: (options = {}) ->
        options.title ?= @title
        @layout = new Layout options

      # Instantiate the dispatcher
      # --------------------------

      # Pass the function typically returned by routes.coffee
      initRouter: (routes, options) ->
        # Save the reference for testing introspection only.
        # Modules should communicate with each other via Pub/Sub.
        @router = new Router options

        # Register all routes declared in routes.coffee
        routes? @router.match

        # After registering the routes, start Backbone.history
        @router.startHistory()

      # Disposal
      # --------

      disposed: false

      dispose: ->
        return if @disposed

        properties = ['dispatcher', 'layout', 'router']
        for prop in properties
          this[prop].dispose()
          delete this[prop]

        @disposed = true

        # You’re frozen when your heart’s not open
        Object.freeze? this
</code></pre>
