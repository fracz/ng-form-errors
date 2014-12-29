describe "validateForm directive", ->
  beforeEach ->
    module 'ngFormErrors'
    fixture('form-with-required-and-minlength')
    inject ($rootScope, @$compile, @$timeout) ->
      @scope = $rootScope.$new()
      @scope.validatedField = 'someForm.someField'
      @scope.myFormSubmitted = => @scope.myFormIsSubmitted = yes
      @element = $compile($("#myForm"))(@scope)
      @scope.$digest()

  it 'should set novalidate on form', ->
    expect(@element.attr('novalidate')).toBeDefined()
    expect(@scope.myForm.$submitted).toBeFalsy()

  it 'should not allow to submit invalid form', ->
    $("#submit").click()
    expect(@scope.myFormIsSubmitted).toBeUndefined()
    expect(@scope.myForm.$submitted).toBeTruthy()

  it 'should allow to submit valid form', ->
    @scope.myForm.required.$setViewValue('some value')
    $("#submit").click()
    expect(@scope.myFormIsSubmitted).toBeTruthy()
    expect(@scope.myForm.$submitted).toBeTruthy()

  it 'should clear errors after submit by default', ->
    fixture('form-pristine-after-submit')
    @scope.myFormSubmitted = =>
      @scope.myModel = '' # clears the form - popular behavior after form submit; should not indicate form errors
    @element = @$compile($("#myForm"))(@scope)
    @scope.myForm.field.$setViewValue('some value')
    $("#submit").click()
    @$timeout.flush()
    expect($(".input-errors li:visible").length).toBe(0)

  it 'should not clear errors after submit when desired', ->
    fixture('form-pristine-after-submit')
    @scope.myFormSubmitted = =>
      @scope.myModel = ''
    @element = @$compile($("#myForm2"))(@scope)
    @scope.myForm.field.$setViewValue('some value')
    $("#submit2").click()
    @$timeout.flush()
    expect($(".input-errors li:visible").length).toBe(1)


