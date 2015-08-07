Template.storyUpdateForm.events
  "submit #storyUpdateForm": (e, tmpl) ->
    e.preventDefault()
    formData = serializeForm(e.currentTarget)
    formData.editing = false
    Stories.update(@editingStory._id, {$set: formData})
