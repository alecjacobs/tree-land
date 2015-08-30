Template.storyTitle.events
  "submit #storyUpdateForm": (e, tmpl) ->
    e.preventDefault()
    formData = serializeForm(e.currentTarget)
    formData.editing = false
    Stories.update(@_id, {$set: formData})

Template.storyTitle.helpers
  titleMaxChars: ->
    Schemas.Stories._schema.title.max
  aboutToDelete: ->
    Session.get("pendingDeleteId") == @_id
