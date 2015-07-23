root = window ? global

root.Stories = new Mongo.Collection("stories")
Schemas = {}
Schemas.Story = new SimpleSchema
  title:
    type: String
    max: 140
  depth:
    type: Number
    min: 0
  parentId:
    type: String
    optional: true
  userId:
    optional: true
    type: String
  editing:
    optional: false
    type: Boolean


Stories.attachSchema(Schemas.Story)

if Meteor.isClient
  Accounts.ui.config
    passwordSignupFields: "USERNAME_ONLY"

  Template.application.helpers
    stories: ->
      Stories.find({})
    noStories: ->
      Stories.find({}).count() == 0

  Template.story.events
    "click .edit": (e, tmpl) ->
      Stories.update(tmpl.data._id, {$set: {editing: true}})
    "click .delete": (e, tmpl) ->
      Stories.remove(tmpl.data._id)

  Template.story.helpers
    sizeClass: (depthLevel) ->
      if depthLevel == 0
        offsetClass = ""
      else
        offsetClass = "col-xs-offset-#{depthLevel}"

      "col-xs-#{12 - depthLevel} #{offsetClass}"
