Template.story.events
  "click .story": (e, tmpl) ->
    Stories.update @_id, {$set: {editing: true}}, ->
      $(tmpl.find(".title-edit")).focus().select()
  "blur .story": (e, tmpl) ->
    formData = serializeForm(tmpl.find("#storyUpdateForm"))
    formData.editing = false
    Stories.update(@_id, {$set: formData})

Template.story.helpers
  sizeClass: (depthLevel) ->
    if depthLevel == 0
      offsetClass = ""
    else
      offsetClass = "col-xs-offset-#{depthLevel}"

    "col-xs-#{12 - depthLevel} #{offsetClass}"
