describe "validateField directive", ->

  beforeEach ->
    module 'ngFormErrors'
    fixture('form-with-required-and-minlength')
    inject ($rootScope, @$compile) ->
      @scope = $rootScope.$new()
      @scope.validatedField = 'someForm.someField'
      @element = $compile($("#myForm"))(@scope)
      @scope.$digest()

  it 'should render errors HTML to view', ->
    expect($(".input-errors").length).toBe(1)

  it 'should render HTML message for every validator', ->
    expect($(".input-errors li").length).toBe(2)

  it 'should not display any errors by default', ->
    expect($(".input-errors li:visible").length).toBe(0)

  it 'should display required message if field is dirty and empty', ->
    @scope.myForm.required.$setViewValue('')
    expect($(".input-errors li:visible").length).toBe(1)
    expect($(".input-errors li:visible").text()).not.toBe('MIN')

  it 'should display minlength message if field is dirty and short', ->
    @scope.myForm.required.$setViewValue('a')
    expect($(".input-errors li:visible").length).toBe(1)
    expect($(".input-errors li:visible").text()).toBe('MIN')

  it 'should not display any validation error if value is valid', ->
    @scope.myForm.required.$setViewValue('a some value')
    expect($(".input-errors li:visible").length).toBe(0)

  it 'should display validation errors on form submit', ->
    $("#submit").click()
    expect($(".input-errors li:visible").length).toBe(1)

  it 'should add validators to a field named dynamically', ->
    @scope.name = 'Dynamic'
    fixture('form-with-dynamic-field-name')
    @element = @$compile($("#myForm"))(@scope)
    $("#submit").click()
    expect($(".input-errors li:visible").length).toBe(1)




