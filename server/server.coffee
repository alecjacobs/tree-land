Meteor.publish "stories", ->
  Stories.find({})
