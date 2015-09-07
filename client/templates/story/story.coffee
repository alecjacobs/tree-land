window.storyDepth = (id) ->
  parentId = Stories.findOne(id)?.parentId
  if parentId == null
    0
  else
    1 + storyDepth(parentId)

Template.story.events
  "click .story": (e, tmpl) ->
    Session.set("selectedStoryId", @_id)
    if ! @editing
      Stories.update @_id, {$set: {editing: true}}, ->
        $(tmpl.find(".title-edit")).focus().select()
  "blur .story": (e, tmpl) ->
    if @editing
      formData = serializeForm(tmpl.find("#storyUpdateForm"))
      formData.editing = false
      Stories.update(@_id, {$set: formData})
  "click .show-children, click .state-indicator": (e, tmpl) ->
    e.stopPropagation()
    Stories.update(@_id, {$set: {showChildren: !@showChildren}})
  "keydown": (e, tmpl) ->
    if e.which == 27 && @editing
      formData = serializeForm(tmpl.find("#storyUpdateForm"))
      formData.editing = false
      Stories.update(@_id, {$set: formData})

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
  showStoriesList: ->
    @showChildren && (Stories.find({parentId: @_id}).count() > 0)
