Template.storyUpdateForm.events
  "submit #storyUpdateForm": (e, tmpl) ->
    e.preventDefault()
    formData = serializeForm(e.currentTarget)
    formData.editing = false
    Stories.update(@editingStory._id, {$set: formData})

Template.storyUpdateForm.helpers
  titleMaxChars: ->
    Schemas.Stories._schema.title.max
