---
layout: page
title: Chaplin.Subscriber
tagline: " - API documentation"
---

The Subscriber offer an interface to interact with [Chaplin.mediator](/docs/mediator.html). As of Backbone 0.9.2, the subscriber just serves the purpose that a handler cannot be registered twice for the same event.


## Methods of `Chaplin.Subscriber`

### subscribeEvent(event, handler)
Unsubcribe the `handler` to the `event` (if it exists) before subscribing it. It is like `Chaplin.mediator.subscribe` except it cannot subscribe twice.

-------------------

### unsubscribeEvent(event, handler)
Unsubcribe the `handler` to the `event`. It is like `Chaplin.mediator.unsubscribe`.

-------------------

### subscribeAllEvents()
Unsubcribe all handlers for all events.


## Usage

To give a Class the Pub/Sub patter, you just need to make it extend the Chaplin.Subscriber:

    _(@prototype).extend Subscriber



## Dependencies
- `Chaplin.mediator`


## Code
<pre><code class="coffeescript">
    # Add functionality to subscribe to global Publish/Subscribe events
    # so they can be removed afterwards when disposing the object.
    #
    # Mixin this object to add the subscriber capability to any object:
    # _(object).extend Subscriber
    # Or to a prototype of a class:
    # _(@prototype).extend Subscriber
    #
    # Since Backbone 0.9.2 this abstraction just serves the purpose
    # that a handler cannot be registered twice for the same event.

    Subscriber =

      subscribeEvent: (type, handler) ->
        if typeof type isnt 'string'
          throw new TypeError 'Subscriber#subscribeEvent: ' +
            'type argument must be a string'
        if typeof handler isnt 'function'
          throw new TypeError 'Subscriber#subscribeEvent: ' +
            'handler argument must be a function'

        # Ensure that a handler isn’t registered twice
        mediator.unsubscribe type, handler, this

        # Register global handler, force context to the subscriber
        mediator.subscribe type, handler, this

      unsubscribeEvent: (type, handler) ->
        if typeof type isnt 'string'
          throw new TypeError 'Subscriber#unsubscribeEvent: ' +
            'type argument must be a string'
        if typeof handler isnt 'function'
          throw new TypeError 'Subscriber#unsubscribeEvent: ' +
            'handler argument must be a function'

        # Remove global handler
        mediator.unsubscribe type, handler

      # Unbind all global handlers
      unsubscribeAllEvents: ->
        # Remove all handlers with a context of this subscriber
        mediator.unsubscribe null, null, this

    # You’re frozen when your heart’s not open
    Object.freeze? Subscriber

    Subscriber
</code></pre>
