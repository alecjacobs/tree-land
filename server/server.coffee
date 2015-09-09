Meteor.publish "stories", (secretKey) ->
  Stories.find({secretKey: secretKey})

storiesToMarkdown = (topLevelStory) ->
  responseBody = ""
  responseBody += topLevelStory.title
  responseBody += "\n"
  _.times topLevelStory.title.length, ->
    responseBody += "="
  responseBody += "\n\n"

  renderChildren = (inspectingStory) ->
    _.each inspectingStory.children().fetch(), (currentChild) ->
      indent = ""
      depth = storyDepth(currentChild._id)
      _.times depth, ->
        indent += "  "

      if currentChild.done
        responseBody += "#{indent}* ~~#{currentChild.title}~~\n"
      else
        responseBody += "#{indent}* #{currentChild.title} \n"

      if currentChild.children().count()
        renderChildren(currentChild)

  renderChildren(topLevelStory)
  responseBody


Api = new Restivus
  prettyJson: false
  apiPath: "export/"

Api.addRoute ':secretKey',
  get: ->
    secretKey = @urlParams.secretKey.replace(".md", "")
    topStory = Stories.findOne({secretKey: secretKey, parentId: null})

    if topStory
      statusCode: 200
      headers:
        "Content-Type": "text/markdown"
        "Content-Disposition": "attachment; filename=#{topStory.title}.md"
      body: storiesToMarkdown(topStory)
    else
      statusCode: 404
      headers:
        "Content-Type": "text"
      body: "404 - Nothing found!"

Meteor.methods
  newWorkspace: ->
    secretKey = Random.secret()
    Stories.create {title: "Hi! Welcome to TreeLand - a simple outliner/tasklist", secretKey: secretKey}, (error, result) ->
      Stories.create({title: "This generated url is unique to this 'tree' - anyone who has the link can view/edit it", secretKey: secretKey, parentId: result, position: 7})
      Stories.create({title: "All navigation / editing designed to be keyboard friendly", secretKey: secretKey, parentId: result, position: 6})
      Stories.create {title: "You can infinetly nest things!", secretKey: secretKey, parentId: result, showChildren: false, position: 5}, (error, result) ->
        Stories.create {title: "let's", secretKey: secretKey, showChildren: false, parentId: result}, (error, result) ->
          Stories.create {title: "just", secretKey: secretKey, showChildren: false, parentId: result}, (error, result) ->
            Stories.create {title: "see", secretKey: secretKey, showChildren: false, parentId: result}, (error, result) ->
              Stories.create {title: "where", secretKey: secretKey, showChildren: false, parentId: result}, (error, result) ->
                Stories.create {title: "this", secretKey: secretKey, showChildren: false, parentId: result}, (error, result) ->
                  Stories.create({title: "goes", secretKey: secretKey, showChildren: false, parentId: result})

      Stories.create({title: "You can also export the whole tree as a markdown document", secretKey: secretKey, parentId: result, position: 4})
      Stories.create {title: "Use the arrow keys to navigate", secretKey: secretKey, parentId: result, position: 3}, (error, result) ->
        Stories.create({title: "hold the shift key to move a story around", secretKey: secretKey, parentId: result, position: 3})
        Stories.create({title: "press enter to start editing a story", secretKey: secretKey, parentId: result, position: 2})
        Stories.create({title: "'n' adds a story", secretKey: secretKey, parentId: result, position: 2})
        Stories.create({title: "'x' toggles a story being done or not", secretKey: secretKey, parentId: result, position: 1})
        Stories.create({title: "See the cheatsheet below for all commands", secretKey: secretKey, parentId: result, position: 0})
      Stories.create({title: "This is a work in progress, so please excuse any bugs / funkyness", secretKey: secretKey, parentId: result, position: 2})
      Stories.create({title: "You can customize the colors of this tree", secretKey: secretKey, parentId: result, position: 1})
      Stories.create({title: "To learn more: https://gist.github.com/alecjacobs/a259ce5d0f698773522c", secretKey: secretKey, parentId: result, position: 0})



    secretKey
