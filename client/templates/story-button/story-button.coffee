Template.storyButton.events
  "click .delete": (e, tmpl) ->
    e.stopPropagation()
    Stories.remove(@story._id)
  "click .add": (e, tmpl) ->
    e.stopPropagation()
    Stories.create
      title: ""
      editing: true
      position: (@story.position + 1)
      depth: @story.depth
  "click .inc-depth": (e, tmpl) ->
    e.stopPropagation()
    Stories.update(@story._id, {$set: {depth: (@story.depth + 1)}})
  "click .dec-depth": (e, tmpl) ->
    e.stopPropagation()
    if @story.depth > 0
      Stories.update(@story._id, {$set: {depth: (@story.depth - 1)}})
