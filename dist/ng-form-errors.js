angular.module('ngFormErrors', []);

angular.module('ngFormErrors').directive('validateForm', ["ngFormErrorsHelper", "$parse", "$timeout", function(ngFormErrorsHelper, $parse, $timeout) {
  return {
    scope: false,
    restrict: 'A',
    priority: 100,
    link: function(scope, element, attrs) {
      var form, formName;
      form = ngFormErrorsHelper.findForm(element);
      form.attr('novalidate', '');
      formName = form.attr('name');
      return element.on('click', function(event) {
        return scope.$apply(function() {
          var setPristineAfterSubmit;
          scope[formName].$setSubmitted();
          if (scope[formName].$invalid) {
            return event.preventDefault();
          } else {
            setPristineAfterSubmit = attrs.validateForm ? $parse(attrs.validateForm)(scope) : true;
            if (setPristineAfterSubmit) {
              return $timeout(function() {
                return scope[formName].$setPristine();
              });
            }
          }
        });
      });
    }
  };
}]);

angular.module('ngFormErrors').directive('validateField', ["$compile", "$parse", "ngFormErrors", "ngFormErrorsHelper", "$interpolate", function($compile, $parse, ngFormErrors, ngFormErrorsHelper, $interpolate) {
  var configurationValid, getFieldFullname, getForm, getFormName, showErrorCondition, validateConfiguration;
  getForm = function(element) {
    return ngFormErrorsHelper.findForm(element);
  };
  getFormName = function(element) {
    return getForm(element).attr('name');
  };
  getFieldFullname = function(element, scope) {
    var fieldName;
    fieldName = $interpolate(element.attr('name'));
    return getFormName(element) + '.' + fieldName(scope);
  };
  showErrorCondition = function(element, scope) {
    var field, form, trigger, triggerOnDirty;
    form = getFormName(element);
    field = getFieldFullname(element, scope);
    triggerOnDirty = element.attr('validate-trigger') ? element.attr('validate-trigger') !== 'submit' : true;
    trigger = "" + form + ".$submitted";
    if (triggerOnDirty) {
      trigger = "(" + field + ".$dirty || " + trigger + ")";
    }
    return "" + field + ".$invalid && " + trigger;
  };
  configurationValid = false;
  validateConfiguration = function(element) {
    if (!getForm(element).length) {
      throw new Error('validate-field is meant to be put on a field inside <form> tag');
    }
    if (!getFormName(element)) {
      throw new Error('<form> that contains validate-field must have a name attribute');
    }
    if (!element.attr('name')) {
      throw new Error('element that has a validate-field directivce must have a name attribute');
    }
    if (!element.attr('ng-model')) {
      throw new Error('element that has a validate-field directivce must have a ng-model attribute');
    }
    return configurationValid = true;
  };
  return {
    scope: false,
    restrict: 'A',
    terminal: true,
    priority: 1000,
    link: {
      pre: function(scope, element) {
        var showErrorCond;
        validateConfiguration(element);
        showErrorCond = showErrorCondition(element);
        element.attr('ng-class', "{'has-error': " + showErrorCond + "}");
        element.removeAttr('validate-field');
        return $compile(element)(scope);
      },
      post: function(scope, element, attrs) {
        var errorHtml, field, li, message, messages, showErrorCond, validator, validators;
        if (configurationValid) {
          field = getFieldFullname(element, scope);
          showErrorCond = showErrorCondition(element, scope);
          if (attrs.validateField) {
            messages = $parse(attrs.validateField)(scope);
          }
          errorHtml = angular.element('<ul>').addClass('input-errors');
          errorHtml.attr('ng-show', showErrorCond);
          if (angular.isString(messages)) {
            li = angular.element('<li>').text(messages);
            errorHtml.attr('ng-show', showErrorCond);
            errorHtml.append(li);
          } else {
            messages = angular.extend(angular.copy(ngFormErrors.getDefaultMessages()), messages);
            validators = angular.copy($parse(field + '.$validators')(scope));
            if (!validators) {
              validators = {};
            }
            validators = angular.extend(validators, angular.copy($parse(field + '.$asyncValidators')(scope)));
            if (element.attr('type') === 'date') {
              validators.date = true;
            }
            for (validator in messages) {
              message = messages[validator];
              if (!(validators[validator] != null)) {
                continue;
              }
              li = angular.element('<li>').text(message);
              li.attr('ng-show', "" + showErrorCond + " && " + field + ".$error." + validator);
              errorHtml.append(li);
            }
          }
          return element.after($compile(errorHtml)(scope));
        }
      }
    }
  };
}]);

angular.module('ngFormErrors').service('ngFormErrorsHelper', function() {
  return new ((function() {
    function _Class() {}

    _Class.prototype.findForm = function(element) {
      var form;
      form = element;
      while (form.length && form.prop('tagName').toUpperCase() !== 'FORM') {
        form = form.parent();
      }
      if (form.length) {
        return form;
      } else {
        return null;
      }
    };

    return _Class;

  })());
});

angular.module('ngFormErrors').service('ngFormErrors', function() {
  var DEFAULT_MESSAGES;
  DEFAULT_MESSAGES = {
    required: 'Value is required',
    minlength: 'Value is too short',
    date: 'Invalid date',
    email: 'Invalid e-mail address'
  };
  return new ((function() {
    function _Class() {}

    _Class.prototype.setDefaultMessages = function(messages) {
      if (!angular.isObject(messages)) {
        throw new Error('Default messages must be an object.');
      }
      return DEFAULT_MESSAGES = messages;
    };

    _Class.prototype.getDefaultMessages = function() {
      return DEFAULT_MESSAGES;
    };

    return _Class;

  })());
});
