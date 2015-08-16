Template.storyButton.events
  "click .inc-depth": (e, tmpl) ->
    e.stopPropagation()
    Stories.update(@_id, {$set: {depth: (@depth + 1)}})
  "click .dec-depth": (e, tmpl) ->
    e.stopPropagation()
    if @depth > 0
      Stories.update(@_id, {$set: {depth: (@depth - 1)}})
  "click .add": (e, tmpl) ->
    e.stopPropagation()
    Stories.update(@_id, {$set: {showChildren: true}})

    stories = Stories.find({parentId: @_id}).fetch()

    if stories.length
      maxStory = _.max stories, (story) ->
        story.position

      position = maxStory.position + 1
    else
      position = Stories.defaults.position

    Stories.create
      title: ""
      editing: true
      position: position
      parentId: @_id
  "click .delete": (e, tmpl) ->
    e.stopPropagation()
    Stories.remove(@_id)
