Meteor.publish "stories", (secretKey) ->
  Stories.find({secretKey: secretKey})

Meteor.methods
  newWorkspace: ->
    secretKey = Random.secret()
    Stories.create {title: "Welcome to to your tree!", secretKey: secretKey}, (error, result) ->
      Stories.create {title: "Saving/Sharing", secretKey: secretKey, parentId: result, showChildren: false, position: 5}, (error, result) ->
        Stories.create({title: "This generated url is unique to this 'tree' - anyone who has the link can view/edit it", secretKey: secretKey, parentId: result, position: 1})
        Stories.create({title: "You can also export the whole tree as a markdown document", secretKey: secretKey, parentId: result, position: 0})
      Stories.create {title: "Navigation (use arrow keys)", secretKey: secretKey, parentId: result, showChildren: false, position: 4}, (error, result) ->
        Stories.create({title: "'enter' starts editing/saves a story", secretKey: secretKey, parentId: result, position: 4})
        Stories.create({title: "'n' adds a story", secretKey: secretKey, parentId: result, position: 3})
        Stories.create({title: "'x' toggles a story being done or not", secretKey: secretKey, parentId: result, position: 2})
        Stories.create({title: "hold the shift key to move a story around", secretKey: secretKey, parentId: result, position: 1})
        Stories.create({title: "See the cheatsheet below for all commands", secretKey: secretKey, parentId: result, position: 0})
      Stories.create {title: "Infinetly nest things", secretKey: secretKey, parentId: result, showChildren: false, showChildren: false, position: 3}, (error, result) ->
        Stories.create {title: "let's", secretKey: secretKey, showChildren: false, parentId: result}, (error, result) ->
          Stories.create {title: "just", secretKey: secretKey, showChildren: false, parentId: result}, (error, result) ->
            Stories.create {title: "see", secretKey: secretKey, showChildren: false, parentId: result}, (error, result) ->
              Stories.create {title: "where", secretKey: secretKey, showChildren: false, parentId: result}, (error, result) ->
                Stories.create {title: "this", secretKey: secretKey, showChildren: false, parentId: result}, (error, result) ->
                  Stories.create({title: "goes", secretKey: secretKey, showChildren: false, parentId: result})
      Stories.create {title: "Math!", secretKey: secretKey, parentId: result, showChildren: false, position: 2}, (error, result) ->
        Stories.create({title: "press \"l\" on the story below to toggle evaluation", secretKey: secretKey, parentId: result, position: 1})
        Stories.create {title: "sum|children", secretKey: secretKey, parentId: result, eval: true, position: 0}, (error, result) ->
          Stories.create({title: "200", secretKey: secretKey, parentId: result, position: 2})
          Stories.create({title: "300", secretKey: secretKey, parentId: result, position: 1})
          Stories.create({title: "500", secretKey: secretKey, parentId: result, position: 0})
      Stories.create({title: "You can customize the colors of this tree", secretKey: secretKey, parentId: result, position: 1})
      Stories.create({title: "To learn more: https://gist.github.com/alecjacobs/a259ce5d0f698773522c", secretKey: secretKey, parentId: result, position: 0})

    secretKey
