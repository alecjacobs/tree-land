root = window

Session.setDefault("collectionsLoading")

Tracker.autorun ->
  document.title = Stories.topLevelStory()?.title || "TreeLand"

root.serializeForm = (formElement) ->
  formData = {}
  $(formElement).serializeArray().map (inputObject) ->
    formData[inputObject.name] = inputObject.value
  formData

Template.registerHelper "meteorStatus", ->
  Meteor.status()

Template.registerHelper "collectionsLoaded", ->
  !Session.get("collectionsLoading")

Template.registerHelper "topLevelStory", ->
  Stories.topLevelStory()
