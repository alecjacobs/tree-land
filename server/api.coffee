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
