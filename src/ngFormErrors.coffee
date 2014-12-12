angular.module('ngFormErrors')
.service 'ngFormErrors', ->
  DEFAULT_MESSAGES =
    required: 'Value is required'
    minlength: 'Value is too short'
    date: 'Invalid date'
    email: 'Invalid e-mail address'

  new class
    setDefaultMessages: (messages) ->
      if not angular.isObject(messages)
        throw new Error('Default messages must be an object.')
      DEFAULT_MESSAGES = messages

    getDefaultMessages: ->
      DEFAULT_MESSAGES
