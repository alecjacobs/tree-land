Template.colorPicker.events
  "changeColor .background.color-picker": (e, tmpl) ->
    newColor = e.color.toHex()
    Stories.update(Stories.topLevelStory()._id, {$set: {backgroundColor: newColor}})

Template.colorPicker.onRendered ->
  $(@find(".color-picker")).colorpicker()
