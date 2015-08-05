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
    type: Boolean
  position:
    type: Number

Stories.attachSchema(Schemas.Story)
