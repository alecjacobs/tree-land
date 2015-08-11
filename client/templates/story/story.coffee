Template.story.events
  "click .story": (e, tmpl) ->
    if ! @editing
      Stories.update @_id, {$set: {editing: true}}, ->
        $(tmpl.find(".title-edit")).focus().select()
  "blur .story": (e, tmpl) ->
    formData = serializeForm(tmpl.find("#storyUpdateForm"))
    formData.editing = false
    Stories.update(@_id, {$set: formData})

Template.story.helpers
  state: ->
    if @editing
      "editing"
  widthPercentage: (depthLevel) ->
    maximumDepth = 24
    
    if depthLevel == 0
      100
    else if depthLevel > maximumDepth
      20
    else
      100 - (80 * (depthLevel / maximumDepth))
