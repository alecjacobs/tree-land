root = window ? global

root.Stories = new Mongo.Collection("stories")
root.Schemas = {}

Schemas.Stories = new SimpleSchema
  title:
    type: String
    max: 140
    optional: true
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
    type: Boolean
  position:
    type: Number

Stories.attachSchema(Schemas.Stories)

Stories.defaults =
  title: ""
  depth: 0
  parentId: null
  userId: null
  editing: false
  position: 0

Stories.create = (storyData) ->
  resultDoc = _.extend(@defaults, storyData)
  Stories.insert(resultDoc)
