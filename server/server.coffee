Meteor.publish "stories", (secretKey) ->
  Stories.find({secretKey: secretKey})

Meteor.methods
  newWorkspace: ->
    secretKey = Random.secret()
    Stories.create {title: "Use the arrow keys to navigate", secretKey: secretKey}, (error, result) ->
      Stories.create {title: "Right arrow to expand", secretKey: secretKey, parentId: result, showChildren: false}, (error, result) ->
        Stories.create {title: "Left arrow to collapse", secretKey: secretKey, parentId: result}, (error, result) ->
          Stories.create {title: "N creates a new story below", secretKey: secretKey, parentId: result}, (error, result) ->
            Stories.create {title: "D deletes things", secretKey: secretKey, parentId: result}, (error, result) ->
              Stories.create {title: "H toggles the shortcuts cheatsheet below", secretKey: secretKey, parentId: result, showChildren: false}, (error, result) ->
                Stories.create({title: "And that's pretty much it!", secretKey: secretKey, parentId: result, showChildren: false})


    secretKey
