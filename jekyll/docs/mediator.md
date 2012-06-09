---
layout: page
title: Chaplin.Mediator
tagline: " - API documentation"
---

As all modules are encapsulated and independent from each other, we need a way to make them communicate. That's the Mediator's role. The Mediator implement the [Publish/Subscribe](http://en.wikipedia.org/wiki/Publish/subscribe) (Pub/Sub) pattern to ensure loose coupling of application modules.

To inform other modules that something happened, a module doesn’t send messages directly (i.e. calling methods of specific objects). Instead, it publishes a message to the mediator without having to know who is listening. Other application modules might subscribe to these messages and react upon them.

Note: If you want to give Pub/Sub functionality to a Class, also look at the [Subscriber](/docs/subscriber.html).


## Methods of `Chaplin.mediator`

### on(event, handler, [context])

A wrapper for `Backbone.Events.on`. [Backbone documentation](http://backbonejs.org/#Events-on).

-------------------

### subscribe(event, handler, [context])

Is an alias for `Chaplin.mediator.on`.

-------------------

### off([event], [handler], [context])

A wrapper for `Backbone.Events.off`. [Backbone documentation](http://backbonejs.org/#Events-off).

-------------------

### unsubscribe([event], [handler], [context])

Is an alias for `Chaplin.mediator.off`.

-------------------

### trigger(event, [*args])

A wrapper for `Backbone.Events.trigger`. [Backbone documentation](http://backbonejs.org/#Events-trigger).

-------------------

### publish(event, [*args])

Is an alias for `Chaplin.mediator.trigger`.



## Usage

Any module that need to publish or subscrib to messages to/from other modules must require `Chaplin` as a dependency.

    define ['chaplin', 'otherdependency'], (Chaplin, OtherDependency) ->

For example, if you have a session_controller that login the user, it will tell the mediator (which will tell it to interested modules) that the login happened by doing:

    mediator.trigger 'login', user
    # OR
    mediator.publish 'login', user

Any module that is interested to know about the user login will subscribe to it by doing:

    Chaplin.mediator.on 'login', @doSomething
    # OR
    Chaplin.mediator.subscribe 'login', @doSomething

Finally, if this module needs to stop listening on the login event, it can just unsubscribe by doing:

    Chaplin.mediator.off 'login', @doSomething
    # OR
    Chaplin.mediator.unsubscribe 'login', @doSomething


## Dependencies

- `underscore`
- `chaplin/lib/subscriber`

## Code

<pre><code class="coffeescript">
    # Mediator
    # --------

    # The mediator is a simple object all others modules use to communicate
    # with each other. It implements the Publish/Subscribe pattern.
    #
    # Additionally, it holds objects which need to be shared between modules.
    # In this case, a `user` property is created for getting the user object
    # and a `setUser` method for setting the user.
    #
    # This module returns the singleton object. This is the
    # application-wide mediator you might load into modules
    # which need to talk to other modules using Publish/Subscribe.

    # Start with a simple object
    mediator = {}

    # Publish / Subscribe
    # -------------------

    # Mixin event methods from Backbone.Events,
    # create Publish/Subscribe aliases
    mediator.subscribe   = mediator.on      = Backbone.Events.on
    mediator.unsubscribe = mediator.off     = Backbone.Events.off
    mediator.publish     = mediator.trigger = Backbone.Events.trigger

    # Initialize an empty callback list so we might seal the mediator later
    mediator._callbacks = null

    # Make properties readonly
    utils.readonly mediator,
      'subscribe', 'unsubscribe', 'publish',
      'on', 'off', 'trigger'

    # Sealing the mediator
    # --------------------

    # After adding all needed properties, you should seal the mediator
    # using this method
    mediator.seal = ->
      # Prevent extensions and make all properties non-configurable
      if support.propertyDescriptors and Object.seal
        Object.seal mediator

    # Make the method readonly
    utils.readonly mediator, 'seal'

    # Return our creation
    mediator

</code></pre>