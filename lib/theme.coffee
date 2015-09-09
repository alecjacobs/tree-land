root = window ? global

root.Theme = {}

Theme.defaultValues =
  background: "#333"
  text: "lightgrey"
  indicators: "#438acc"

Theme.colorValues = ->
  if Meteor.isClient
    _.extend({}, Theme.defaultValues, Stories.topLevelStory()?.themeColors)
  else
    Theme.defaultValues
