angular.module('ngFormErrors')
.service 'ngFormErrorsHelper', ->
  new class
    findForm: (element) ->
      form = element
      while form.length and form.prop('tagName').toUpperCase() != 'FORM'
        form = element.parent()
      if form.length then form else null
