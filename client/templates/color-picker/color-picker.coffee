Template.colorPicker.events
  "changeColor .color-picker": (e, tmpl) ->
    newColor = e.color.toHex()
    updateDoc = {$set: {}}
    updateDoc.$set["themeColors.#{@name}"] = newColor

    Stories.update(Stories.topLevelStory()._id, updateDoc)

Template.colorPicker.helpers
  backgroundColor: ->
    Theme.colorValues()[@name]

Template.colorPicker.onRendered ->
  $pickerElement = $(@find(".#{@data.name}.color-picker"))
  name = @data.name

  Tracker.autorun ->
    if Session.get("collectionsLoaded")
      $pickerElement.colorpicker({color: Theme.colorValues()[name]})
