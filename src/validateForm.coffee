angular.module('ngFormErrors')
.directive 'validateForm', (ngFormErrorsHelper) ->
  scope: false
  restrict: 'A'
  priority: 100
  link: (scope, element) ->
    form = ngFormErrorsHelper.findForm(element)
    form.attr('novalidate', '')
    formName = form.attr('name')

    element.on 'click', (event) ->
      scope.$apply ->
        scope[formName].$setSubmitted()
        if scope[formName].$invalid
          event.preventDefault()
