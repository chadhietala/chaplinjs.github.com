---
layout: page
title: Chaplin.SyncMachine
tagline: " - API documentation"
---

The  `Chaplin.SyncMachine` is a [finite-state machine](http://en.wikipedia.org/wiki/Finite-state_machine) for synchronization of models/collections. There are three states in which a model or collection can be in; unsynced, syncing, and synced. When a state transition (unsynced, syncing, synced, and syncStateChange) occurs Backbone events are called on the model or collection.

## Methods of `Chaplin.SyncMachine`

<a name="syncState"></a>

### syncState

Returns the current synchronization state of the machine.

-------------------

<a name="isUnsynced"></a>

### isUnsynced

Returns a boolean to determine if model or collection is unsynced.

-------------------

<a name="isSynced"></a>

### isSynced

Returns a boolean to determine if model or collection is synced.

-------------------

<a name="isSyncing"></a>

### isSyncing

Returns a boolean to determine if model or collection is currently syncing.

-------------------

<a name="unsync"></a>

### unsync

Sets the state machine's state to `unsynced` then triggers any events listening for the `unsynced` and `syncStateChanged` events.

-------------------

<a name="beginSync"></a>

### beginSync

Sets the state machine's state to `syncing` then triggers any events listening for the `syncing` and `syncStateChanged` events.

-------------------

<a name="beginSync"></a>

### finishSync

Sets the state machine's state to `synced` then triggers any events listening for the `synced` and `syncStateChanged` events.

-------------------

<a name="abortSync"></a>

### abortSync

Sets state machine's state back to the previous state if the state machine is in the `syncing` state. Then triggers any events listening for the previous state and `syncStateChanged` events.

## Usage

The `Chaplin.SyncMachine` is a dependency of `Chaplin.Model` and `Chaplin.Collection` and should be used for complex synchronization of models and collections.

<pre><code class="coffeescript">
    define [
      'chaplin'
      'models/post' # Post model
    ], (Chaplin.Collection, Post) ->

      class Posts extends Chaplin.Collection

        model: Post

        initialize: ->
          super

          # Initialize the SyncMachine
          @initSyncMachine()

          # Will be called on every state change
          @syncStateChange announce

          fetch()

        # Custom fetch method which warrents
        # the sync machine
        fetch: =>

          #Set the machine into `syncing` state
          @beginSync()

          # Do something interesting like calling
          # a 3rd party service
          $.get 'http://some-service.com/posts', @processPosts

        processPosts: (response) =>
          # Exit if for some reason this collection was
          # disposed prior to the response
          return if @disposed

          # Update the collection
          @reset(if response and response.data then response.data else [])

          # Set the machine into `synced` state 
          @finishSync()

        announce: =>
          console.debug 'state changed'
</code></pre>

## Dependencies

No dependencies.


## Code
<pre><code class="coffeescript">
define [
  'underscore',
  'backbone',
  'chaplin/lib/utils'
  'chaplin/lib/subscriber'
  'chaplin/lib/sync_machine'
], (_, Backbone, utils, Subscriber, SyncMachine) ->
  'use strict'

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
      # Map model/collection to their attributes
      for key, value of attributes
        if value instanceof Model
          # Don’t change the original attribute, create a property
          # on the delegator which shadows the original attribute
          delegator ?= utils.beget attributes
          delegator[key] = if value is model or value in modelStack
            # Nullify circular references
            null
          else
            # Serialize recursively
            serializeAttributes(
              value, value.getAttributes(), modelStack
            )
        else if value instanceof Backbone.Collection
          delegator ?= utils.beget attributes
          delegator[key] = for item in value.models
            serializeAttributes(
              item, item.getAttributes(), modelStack
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
