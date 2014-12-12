angular.module('ngFormErrors')
.directive 'validateField', ($compile, $parse, ngFormErrors, ngFormErrorsHelper) ->
  getForm = (element) ->
    ngFormErrorsHelper.findForm(element)

  getFormName = (element) ->
    getForm(element).attr('name')

  getFieldFullname = (element) ->
    getFormName(element) + '.' + element.attr('name')

  showErrorCondition = (element) ->
    form = getFormName(element)
    field = getFieldFullname(element)
    triggerOnDirty = if element.attr('validate-trigger') then element.attr('validate-trigger') != 'submit' else yes
    trigger = "#{form}.$submitted"
    if triggerOnDirty
      trigger = "(#{field}.$dirty || #{trigger})"
    "#{field}.$invalid && #{trigger}"

  configurationValid = no

  validateConfiguration = (element) ->
    throw new Error('validate-field is meant to be put on a field inside <form> tag') if not getForm(element).length
    throw new Error('<form> that contains validate-field must have a name attribute') if not getFormName(element)
    throw new Error('element that has a validate-field directivce must have a name attribute') if not element.attr('name')
    throw new Error('element that has a validate-field directivce must have a ng-model attribute') if not element.attr('ng-model')
    configurationValid = yes

  scope: false
  restrict: 'A'
  terminal: true
  priority: 1000
  link:
    pre: (scope, element) ->
      validateConfiguration(element)
      showErrorCond = showErrorCondition(element)
      element.attr('ng-class', "{'has-error': #{showErrorCond}}")
      element.removeAttr('validate-field')
      $compile(element)(scope)

    post: (scope, element, attrs) ->
      if configurationValid
        field = getFieldFullname(element)
        showErrorCond = showErrorCondition(element)

        messages = $parse(attrs.validateField)(scope) if attrs.validateField
        errorHtml = angular.element('<ul>').addClass('input-errors')
        errorHtml.attr('ng-show', showErrorCond)
        if angular.isString(messages)
          li = angular.element('<li>').text(messages)
          errorHtml.attr('ng-show', showErrorCond)
          errorHtml.append(li)
        else
          messages = angular.extend(angular.copy(ngFormErrors.getDefaultMessages()), messages)
          validators = angular.copy($parse(field + '.$validators')(scope))
          validators = {} if not validators
          validators = angular.extend(validators, angular.copy($parse(field + '.$asyncValidators')(scope)))
          validators.date = yes if element.attr('type') == 'date'
          for validator, message of messages when validators[validator]?
            li = angular.element('<li>').text(message)
            li.attr('ng-show', "#{showErrorCond} && #{field}.$error.#{validator}")
            errorHtml.append(li)

        element.after($compile(errorHtml)(scope))
