Stories = new Mongo.Collection("stories")
Schemas = {}
Schemas.Story = new SimpleSchema
  title:
    type: String
    label: "title"
    max: 140
  parent:
    type: String

Stories.attachSchema(Schemas.Story)

sizeClass = (depthLevel) ->
  if depthLevel == 0
    offsetClass = ""
  else
    offsetClass = "col-xs-offset-#{depthLevel}"

  "col-xs-#{12 - depthLevel} #{offsetClass}"

if Meteor.isClient
  Template.body.helpers
    tasks: [
      { text: "Task here", sizeClass: sizeClass(0) }
      { text: "Task here", sizeClass: sizeClass(1) }
      { text: "Task here", sizeClass: sizeClass(1) }
      { text: "Task here", sizeClass: sizeClass(1) }
      { text: "Task here", sizeClass: sizeClass(2) }
      { text: "Task here", sizeClass: sizeClass(1) }
      { text: "Task here", sizeClass: sizeClass(1) }
      { text: "Task here", sizeClass: sizeClass(1) }
      { text: "Task here", sizeClass: sizeClass(2) }
      { text: "Task here", sizeClass: sizeClass(2) }
      { text: "Task here", sizeClass: sizeClass(2) }
      { text: "Task here", sizeClass: sizeClass(2) }
      { text: "Task here", sizeClass: sizeClass(2) }
      { text: "Task here", sizeClass: sizeClass(2) }
      { text: "Task here", sizeClass: sizeClass(1) }
      { text: "Task here", sizeClass: sizeClass(1) }
      { text: "Task here", sizeClass: sizeClass(0) }
      { text: "Task here", sizeClass: sizeClass(0) }
      { text: "Task here", sizeClass: sizeClass(1) }
      { text: "Task here", sizeClass: sizeClass(2) }
      { text: "Task here", sizeClass: sizeClass(2) }
      { text: "Task here", sizeClass: sizeClass(3) }
      { text: "Task here", sizeClass: sizeClass(4) }
      { text: "Task here", sizeClass: sizeClass(5) }
      { text: "Task here", sizeClass: sizeClass(6) }
      { text: "Task here", sizeClass: sizeClass(7) }
    ]
