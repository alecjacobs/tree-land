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

Template.registerHelper "meteorStatus", ->
  Meteor.status()

Template.application.onCreated ->
  @subscribe "stories", ->
    Tracker.autorun ->
      if Meteor.status().connected && (Stories.find({}).count() == 0)
        Stories.create({title: "life"})
