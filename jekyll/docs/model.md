---
layout: page
title: Chaplin.Model
tagline: " - API documentation"
---

`Chaplin.Model` extends the standard `Backbone.Model`. It adds disposal for cleaning up and the Pub/Sub pattern via the `Chaplin.Subscriber` mixin.


## Methods of `Chaplin.Model`
All `Backbone.Model` [methods](http://backbonejs.org/#Model).

TODO


## Usage
Please do not register their methods directly as Pub/Sub listeners, use `subscribeEvent` instead. This forces the handler context so the handler might be removed again on model/collection disposal. It’s crucial to remove all references to model/collection methods to allow them to be garbage collected.

## Dependencies
- `underscore'`
- `backbone'`
- `chaplin/lib/utils`
- `chaplin/lib/subscriber`
- `chaplin/lib/sync_machine`


## Code
<pre><code class="coffeescript">
    class Model extends Backbone.Model

      # Mixin a Subscriber
      _(@prototype).extend Subscriber

      # Mixin a Deferred
      initDeferred: ->
        _(this).extend $.Deferred()

      # Mixin a synchronization state machine
      initSyncMachine: ->
        _(this).extend SyncMachine

      # This method is used to get the attributes for the view template
      # and might be overwritten by decorators which cannot create a
      # proper `attributes` getter due to ECMAScript 3 limits.
      getAttributes: ->
        @attributes

      # Private helper function for serializing attributes recursively,
      # creating objects which delegate to the original attributes
      # when a property needs to be overwritten.
      serializeAttributes = (model, attributes, modelStack) ->
        # Create a delegator on initial call
        unless modelStack
          delegator = utils.beget attributes
          modelStack = [model]
        else
          # Add model to stack
          modelStack.push model
        # Map models to their attributes
        for key, value of attributes when value instanceof Model
          # Don’t change the original attribute, create a property
          # on the delegator which shadows the original attribute
          delegator = delegator or utils.beget attributes
          delegator[key] = if value is model or value in modelStack
            # Nullify circular references
            null
          else
            # Serialize recursively
            serializeAttributes(
              value, value.getAttributes(), modelStack
            )
        # Remove model from stack
        modelStack.pop()
        # Return the delegator if it was created, otherwise the plain attributes
        delegator or attributes

      # Return an object which delegates to the attributes
      # (i.e. an object which has the attributes as prototype)
      # so primitive values might be added and altered safely.
      # Map models to their attributes, recursively.
      serialize: (model) ->
        serializeAttributes this, @getAttributes()

      # Disposal
      # --------

      disposed: false

      dispose: ->
        return if @disposed

        # Fire an event to notify associated collections and views
        @trigger 'dispose', this

        # Unbind all global event handlers
        @unsubscribeAllEvents()

        # Remove all event handlers on this module
        @off()

        # If the model is a Deferred, reject it
        # This does nothing if it was resolved before
        @reject?()

        # Remove the collection reference, internal attribute hashes
        # and event handlers
        properties = [
          'collection',
          'attributes', 'changed'
          '_escapedAttributes', '_previousAttributes',
          '_silent', '_pending',
          '_callbacks'
        ]
        delete this[prop] for prop in properties

        # Finished
        @disposed = true

        # You’re frozen when your heart’s not open
        Object.freeze? this

</code></pre>
