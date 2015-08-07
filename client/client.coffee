root = window

root.serializeForm = (formElement) ->
  formData = {}

  $(formElement).serializeArray().map (inputObject) ->
    formData[inputObject.name] = inputObject.value

  formData

Accounts.ui.config
  passwordSignupFields: "USERNAME_ONLY"

Template.application.helpers
  stories: ->
    Stories.find({})

Template.application.onCreated ->
  @subscribe "stories", ->
    Tracker.autorun ->
      if Stories.find({}).count() == 0
        Stories.create({title: "life"})
