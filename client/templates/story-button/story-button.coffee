Template.storyButton.events
  "click .inc-depth": (e, tmpl) ->
    e.stopPropagation()
    Stories.update(@_id, {$set: {depth: (@depth + 1)}})

  "click .dec-depth": (e, tmpl) ->
    e.stopPropagation()
    if @depth > 0
      Stories.update(@_id, {$set: {depth: (@depth - 1)}})

  "click .delete": (e, tmpl) ->
    e.stopPropagation()
    Stories.remove(@_id)
