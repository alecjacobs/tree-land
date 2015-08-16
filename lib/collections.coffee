root = window ? global

root.Stories = new Mongo.Collection("stories")
root.Schemas = {}

Schemas.Stories = new SimpleSchema
  title:
    type: String
    max: 140
    optional: true
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
  showChildren:
    type: Boolean

Stories.attachSchema(Schemas.Stories)

Stories.defaults =
  title: ""
  parentId: null
  userId: null
  editing: false
  position: 0
  showChildren: true

Stories.create = (storyData) ->
  resultDoc = _.extend({}, @defaults, storyData)
  Stories.insert(resultDoc)
