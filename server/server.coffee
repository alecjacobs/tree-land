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
    Stories.create {title: "Use the arrow keys to navigate", secretKey: secretKey}, (error, result) ->
      Stories.create {title: "Right arrow to expand", secretKey: secretKey, parentId: result, showChildren: false}, (error, result) ->
        Stories.create {title: "Left arrow to collapse", secretKey: secretKey, parentId: result}, (error, result) ->
          Stories.create {title: "N creates a new story below", secretKey: secretKey, parentId: result}, (error, result) ->
            Stories.create {title: "D deletes things", secretKey: secretKey, parentId: result}, (error, result) ->
              Stories.create {title: "H toggles the shortcuts cheatsheet below", secretKey: secretKey, parentId: result, showChildren: false}, (error, result) ->
                Stories.create({title: "And that's pretty much it!", secretKey: secretKey, parentId: result, showChildren: false})


    secretKey
