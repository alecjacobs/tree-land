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
    else if @selected
      "selected"
    else
      ""
      
  widthPercentage: (depthLevel) ->
    maximumDepth = 24
    
    if depthLevel == 0
      100
    else if depthLevel > maximumDepth
      20
    else
      100 - (80 * (depthLevel / maximumDepth))

Template.story.onCreated ->
  #Mousetrap.bind "esc", ->
    #console.log "esc key pressed"
    #Stories.update({editing: true}, {editing: false}, {multi: true})
    