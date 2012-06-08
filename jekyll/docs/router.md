---
layout: page
title: Router
tagline: " - API documentation"
---

The Chaplin Router is a replacement for [Backbone.Router](http://documentcloud.github.com/backbone/#Router).  Like the standard router, it creates a [Backbone.History](http://documentcloud.github.com/backbone/#History) instance and registers routes on it. In Backbone's concept, there are no controllers. Backbone's Router maps routes to it's own methods, so it servers two purposes.  The Chaplin Router is simply just a router which maps URLs to seperate controllers, in particular controller actions.

The Chaplin Router is a dependancy of [Chaplin.Application](./application.html) which should be extended from by your main application class. Within your application class you should initialize the Router by calling `@initRouter` passing your routes module as an argument.

    ...

      class HelloWorldApplication extends Chaplin.Application

        title: 'Chaplin Example Application'

        initialize: ->
          super

          @initRouter routes

    ...

## createHistory

creates the Backbone.History instance

## startHistory

starts the Backbone.History instance.  This method should be called after all the routes have been registered.

## stopHistory

stops the Backbone.History instance from observing URL changes.

## match(pattern, target, options = {})

connects an address with a controller action.  Directly creates a new Route instance on the Backbone.History instance.

### Parameters:

__pattern:__ A url pattern to match against the current URL.

__target:__ The controller and the action you want to execute on it.

__options:__ Optional object to be passed to the Routes object

## route(path)

Route a given path manually. Returns a boolean after it has been matched against handlers in Backbone.history.handlers.  This looks quite like Backbone.history.loadUrl, but it accepts an absolute URL with a leading slash (e.g. /foo) and passes a changeURL parameter to the callback function.

### Parameters:

__path:__ An absolute URL with a leading slash.

## routeHandler(path, callback)

When the globalized `!router:route` event is emitted call the callback associated with the route.

### Parameters:

__path:__ An absolute URL with a leading slash.

__callback:__ A callback to call when routed.

## changeURL(url)

Changes the current URL and adds a history entry.  Does not trigger any routes.

### Parameters:

__url:__ String that is going to be pushed as the pages url.

## changeURLHandler(url)

Handler for the globalized `!router:changeURL` event.  Calls `@changeURL`.

### Parameters:

__url:__ String that is going to be pushed as the pages url.

## dispose

Stops the Backbone.history instance and removes it from the Router object.  Also unsubscribes any events attached to the Router.  Attempts to freeze the Router to prevent any changes to the Router. See [Object.freeze](https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Object/freeze).


