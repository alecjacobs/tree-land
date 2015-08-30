Meteor.publish "stories", (secretKey) ->
  Stories.find({secretKey: secretKey})

Meteor.methods
  newWorkspace: ->
    secretKey = Random.secret()
    Stories.create({title: "welcome!", secretKey: secretKey})
    secretKey
