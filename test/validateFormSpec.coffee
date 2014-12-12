describe "validateForm directive", ->

  beforeEach ->
    module 'ngFormErrors'
    fixture('form-with-required-and-minlength')
    inject ($rootScope, $compile) ->
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


