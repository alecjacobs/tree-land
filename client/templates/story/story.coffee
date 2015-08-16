window.storyDepth = (id) ->
  parentId = Stories.findOne(id)?.parentId

  if parentId == null
    0
  else
    1 + storyDepth(parentId)

Template.story.events
  "click .story": (e, tmpl) ->
    if ! @editing
      Stories.update @_id, {$set: {editing: true}}, ->
        $(tmpl.find(".title-edit")).focus().select()
  "blur .story": (e, tmpl) ->
    if @editing
      formData = serializeForm(tmpl.find("#storyUpdateForm"))
      formData.editing = false
      Stories.update(@_id, {$set: formData})
  "click .show-children": (e, tmpl) ->
    e.stopPropagation()
    Stories.update(@_id, {$set: {showChildren: (! @showChildren)}})

Template.story.helpers
  state: ->
    if @editing
      "editing"
    else if Session.get("selectedStoryId") == @_id
      "selected"
    else
      ""
  depth: ->
    storyDepth(@_id)
  hasChildren: ->
    Stories.find({parentId: @_id}).count()
  triangleDirection: ->
    if @showChildren
      "bottom"
    else
      "right"
