angular.module('ngFormErrors')
.directive 'validateForm', (ngFormErrorsHelper, $parse, $timeout) ->
  scope: false
  restrict: 'A'
  priority: 100
  link: (scope, element, attrs) ->
    form = ngFormErrorsHelper.findForm(element)
    form.attr('novalidate', '')
    formName = form.attr('name')

    element.on 'click', (event) ->
      scope.$apply ->
        scope[formName].$setSubmitted()
        if scope[formName].$invalid
          event.preventDefault()
        else
          setPristineAfterSubmit = if attrs.validateForm then $parse(attrs.validateForm)(scope) else yes
          if setPristineAfterSubmit
            $timeout -> scope[formName].$setPristine()
