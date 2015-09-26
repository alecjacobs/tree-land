getcontrast = (hex) ->
    r = parseInt(hex.substr(1, 2), 16)
    g = parseInt(hex.substr(3, 2), 16)
    b = parseInt(hex.substr(5, 2), 16)
    yiq = ((r * 299) + (g * 587) + (b * 114)) / 1000
    if (yiq >= 128) then 'black' else 'white'

Template.colorPicker.events
  "changeColor .color-picker": (e, tmpl) ->
    newColor = e.color.toHex()
    updateDoc = {$set: {}}
    updateDoc.$set["themeColors.#{@name}"] = newColor

    Stories.update(Stories.topLevelStory()._id, updateDoc)

Template.colorPicker.helpers
  backgroundColor: ->
    Theme.colorValues()[@name]
  outlineColor: ->
    getcontrast(Theme.colorValues().background)

Template.colorPicker.onRendered ->
  $pickerElement = $(@find(".#{@data.name}.color-picker"))
  name = @data.name

  Tracker.autorun ->
    if !Session.get("collectionsLoading")
      $pickerElement.colorpicker({color: Theme.colorValues()[name]})
